# Lambda

## Handlers

Acts as a `main` function and is the entry point for invokation of a Lambda function.

```python

def lambda_handler(event, context):
    ...
    return something
```

`event` is what is parsed to your lambda function and is essentially a dictionary with all the data you wish for your lambda function to process.

```python
event = {'first_name': 'David', 'last_name': 'Ross'}
```

`context` this seems to be automatically parsed to the handler from Lambda. Its an object that provides execution metadata.

The returned value is JSON serialized and sent back to the client.


