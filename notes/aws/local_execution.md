# Guide to Invoking and Debugging Locally

This guide will allow one to invoke and debug their lambda function code in their local environment using real resources (s3, DyanmoDB etc.) that are active in the cloud and/or using mocked resources.

It is assumed that reader has some familiarity with SAM and LocalStack.

NOTE: The recommended approach by infrastructure is to use LocalStack to mock as much as possible locally and only use live services that cannot be mocked e.g. Amazon Connect. However, connecting to live services in the AWS SolDev account is the best environment for debugging and discovering real errors due to the limitations of mocking resources (see below caveats).

## Caveats

### Using Real AWS Resources

- This solution will not entirely work with the AAD-CX-Sandbox-Dev-SolDev account due to permission limitations applied to the account e.g. AccessDenied error when executing the S3 PutObject operation with this account. As such, you may need to recreate some of your resources within the AAD-CX-Learning-SolAdmin account to use this method.

### Using Mocked AWS Resources via LocalStack

- LocalStack is not officially supported by AWS, as such there will be API changes and missing services that aren't replicated correctly by it which can lead to differing “solutions” when debugging using LocalStack and using real resources hosted in AWS.

- It does not currently mock all AWS resources including Amazon Connect. So if part of your lambda uses the SDK to communicate with a connect instance, then you must connect to a real instance hosted within the cloud.

- Mocked local services may have to be setup as similar to the real services as possible to allow one to accurately debug an issue. For example, if debugging requires an S3 bucket with a lot of objects within it then we have to manually add those objects to the locally mocked bucket. This is a time consuming and error prone process.

## 1. Preparation

Installing Dependencies

```sh
brew install awscli aws-sam-cli
pip install localstack
```

To install Docker, make sure you do so via this link as installing via brew will only lead to a chronic migraine.

### CF Template Alterations

Some alterations to your CloudFormation template will need to be made to allow SAM to invoke your Lambda function locally.

You will need to copy your current template and create a local version:

```sh
cp \
  templates/<name>.cf-template.yml \
  templates/<name>.local.cf-template.yml
```

You will make all template modifications to the `templates/<name>.local.cf-template.yml` file.

The CodeUri property for your function resource will need to be changed to point to a local directory containing the function(s) of interest:

```yaml
# From
rMyCoolAppFunction:
  Type: AWS::Serverless::Function
  Properties:
    CodeUri:
      Bucket: !Ref pArtifactS3BucketName
      Key: !Ref pArtifactS3Key
  ...

# To
rMyCoolAppFunction:
  Type: AWS::Serverless::Function
  Properties:
    CodeUri: ../src/backup_connect_resources/
  ...
```

You will want to do the above for the rPreTrafficLambdaFunction and rPostTrafficLambdaFunction resources too.

### Overriding Environment Variables

You may need to override the environment variables parsed to your lambda function with a JSON file.

Pseudo parameters and parameters defined with defaults that have been parsed to the function as environment variables will not need to be overriden.

NOTE: if you are parsing the `ci/<name>.config.json` files parameters to the lambda function as environment variables, then you will have to override them. Otherwise, the environment variables will be parsed as the parameter/resource name you defined within the template instead of the parameters assigned value defined within the aforementioned config file e.g. `CONNECT_INSTANCE_ID` environment variables value will be parsed literally as “pConnectInstanceId” to your Lambda function in the below example.

#### Example

In the below example template snippet, `CONNECT_INSTANCE_ID` will need to be overridden as no default value is provided in the referenced parameter pConnectInstanceId. The `BUCKET_NAME` will need to be overridden as no bucket name is defined within the referenced resource rBackupResourcesBucket.

```yaml
# templates/<name>.cf-template.yml

# PARAMETERS

pLogLevel:
  Description: verbosity level of function loggers
  Type: String
  Default: DEBUG
  AllowedValues:
    - CRITICAL
    - ERROR
    - WARNING
    - INFO
    - DEBUG

pEnableDailyBackUp:
  Description: Enable Lambda function invokation every 24 hours
  Type: String
  Default: DISABLED
  AllowedValues:
    - ENABLED
    - DISABLED

pConnectInstanceId:
  Description: Connect instance id to get resources from
  Type: String

# RESOURCES

rBackupResourcesBucket:
  Type: AWS::S3::Bucket
  DeletionPolicy: Retain
  UpdateReplacePolicy: Retain

rBackupResourcesAppFunction:
  Type: AWS::Serverless::Function
  Properties:
    Environment:
      Variables:
        LOG_LEVEL: !Ref pLogLevel
        CONNECT_INSTANCE_ID: !Ref pConnectInstanceId
        BUCKET_NAME: !Ref rBackupResourcesBucket
        REGION: !Ref AWS::Region
```

We therefore explicitly define the environment variables and their values within a new file named `ci/debug_env.json`.

```json
{
  "rBackupResourcesAppFunction": {
    "BUCKET_NAME": "my-bucket-name-2bvxon1qf35y",
    "CONNECT_INSTANCE_ID": "xxxx9x9-9999-99xx-xx99-99999x9x99xx"
  }
}
```

The JSON file we constructed will be parsed to SAM when we are ready to invoke our lambda locally.

#### Requirements File

We need to generate a requirements.txt file for SAM as it does not currently work with pipenv.

You will have to do this in the `src/<name>/` directory.

Ensure to append your debugger package at the end of the requirements file.

```sh
pipenv lock -r > requirements.txt

# required for the pre/post traffic functions to work locally
cp requirements.txt test/integration/
```

If you receive an error, like a `PythonPipBuilder` error, during the SAM build process then you can try and create a requirements file using this script.

```python
pipfile2requirements.py --pipfile /path/to/Pipfile --output /path/to/output/dir/
```

## 2. Local Lambda Invocation

### Permissions and Credentials

NOTE: Only follow this step if you need to connect to real AWS resources.

Login via aada:

```sh
aada login -n --profile aad

# pick the required role
```

Alter your `~/.aws/credentials` file such that all the credentials for `[aad]` and `[default]` are the same:

```
[default]
aws_access_key_id = AAD_ACCESS_KEY
aws_secret_access_key = AAD_SECRET
aws_session_token = AAD_SESSION_TOKEN

[aad]
aws_access_key_id = AAD_ACCESS_KEY
aws_secret_access_key = AAD_SECRET
aws_session_token = AAD_SESSION_TOKEN
```

NOTE: the above should not be required, you should be able to use the `--profile aad` flag with SAM to specify a role. However, the function seems to raise an access denied exception when using said flag so the above hack is required.

### LocalStack Setup

NOTE: Only follow this step if you intend to connect to mocked AWS resources.

Open a new terminal and execute the following command and leave it running:

```sh
localstack start
```

You may need to create resources. For example to create an S3 bucket locally:

```sh
aws --endpoint-url=http://localhost:4572 s3 mb s3://testing-bucket
```

You will need to change all connections to the client/resources in your Lambda functions code to point to an endpoint created by LocalStack. The below snippet shows an example of how to connect to an mocked S3 client:

```py
# before

s3 = boto3.client("s3")

# after

s3 = boto3.client("s3", endpoint_url="http://host.docker.internal:4572")

# before

dynamodb = boto3.client("dyanmodb")

# after

dynamodb = boto3.client("dynamodb", endpoint_url="http://host.docker.internal:4569")
```

NOTE: Each AWS resource is accessible via a specific port; s3 → 4572, dynamodb → 4569 etc. Each port is documented within the LocalStack github README.

### Build Process

```sh
sam build -t templates/<name>.local.cf-templates.yml
```

Local Invocation

Ensure you create an `event.json` with the correct key/values to trigger your function.

In this instance it will be using an empty json:

```
{}
```

Invoke the lambda by parsing the event, environment variables and resource you wish to invoke:

```sh
sam local invoke \
 --region eu-west-2 \
 --event event.json \
 --env-vars ci/debug_env.json \
 rMyCoolAppFunction
```

## 3. Using a Debugger

Add your debugger statement to your code.

### PUDB

```python
from pudb.remote import set_trace

set_trace(term_size=(160, 40),host='0.0.0.0', port=6900)
```

### Remote PDB

```python
from remote_pdb import RemotePdb

RemotePdb('0.0.0.0', 6900).set_trace()
```

### PTVSD & VSCode

Specific instructions for setting up local debugging with VSCode can be found here.

### Trigger

You will have to rebuild and invoke with the debugging flag to specify the port of interest (should be the same as the one used with your inline debugging statement).

```sh
sam build -t src/<name>.local.cf-templates.yml

sam local invoke \
 --region eu-west-2 \
 --event event.json \
 --env-vars ci/debug_env.json \
 --debug-port 6900 \
 rMyCoolAppFunction
```

In a new terminal, use the below command to connect to it:

```sh
telnet localhost 6900
```

You can now use your debugger to debug code
