# Overview

+44 141 846 0257

## Definitions

- _Contact Control Panel (CCP)_ - allows agents to communicate with customers.
- _Customer Relationship Management (CRM)_ - software to manage interaction with customers by leveraging customer information/analytics to increase sales and maintain customer retention.
- _Interactive Voice Response (IVR)_ - telephony menu system, traditionally press number on phone to traverse a tree of menu options.
- _Contact Trace Records (CTR)_ - capture events associated with your customer for each call; call metadata e.g. time spent on hold, call time, queue placement. This is captured in real time and stored as historical data.
- _Amazon Lex_ - the voice recognition software used to power Alexa
- _Workforce Management (WFM)_ - set of processes to optimise employee productivity

## Benefits

- 100% cloud based & easy setup
- Can leverage the entire AWS ecosystem

- Contact flows to design conversational interactions/IVR
- Lambdas can be used to custom specific funtionality inside the contact flow
- Open Platform -- intigrate with CRM, DB, data warehouse etc.

- Pay as you go (per customer connected minutes).
- Automatic Scaling

## Features

### CCP

- Web base, so don't ned to install software (use on any device)
- Design contact flows & IVR
- Single console to mange users
- Claim phone numbers
- Contact trace records

### IVR

- Uses Lex for NLP
- Skills based routing to route customer to the relevent agent

### Storage

- Store call recordings on S3 buckets
- Easy access to data and contact records

### Metrics

- Contact Trace Metrics

  - real time metrics reports
  - historical metrics reports
  - agent trace report (login/logout history etc.)
  - contact search reports
  - export as a csv

### Open API

- Allows the facilitation of custom integrations
- Integrates with CRMs & WFM
- Integrate with systems via Lambda
- CTR data streaming with Kinesis
- Monitor/Alert with Cloudwatch

# Setting Up Call Centre

## Launching an Instance

### Dependencies

- AWS Identity & Access Management (IAM)
  - Manages/defines user/group access to your AWS services
- AWS Directory Service
  - Managed Microsoft AD in the AWS cloud
- AWS Key Management Service (KMS)
  - Manages secrets/keys across services
- AWS Simple Storage Services (S3)

#### IAM

All roles are linked to services

- Trust policy are linked to specific roles. By default no policies are given.

- 

## Configuring An Instance

- Choose users to reside in AD via Directory Services
- S3 created automatically for storage, option to use different S3 buckets for recordings and reports
- Claim a phone number

NOTE: I think the below processing is called `routing profiles`

- IVR flows lead to specialised agents, if they are not available then they are placed in a queue if an agent is around and on hold if no agent is available

### Pre-existing Security Profiles

- Admin
  - can access/edit all available resources & actions
- Agent
  - allows access to the CCP only
- Call Center Manager
  - allows access to user management, metrics & routing settings
- Quality Analyst
  - access to metrics only

New/custom ones can be added.

### Routing Profiles

A collection of queues that determines how customers are routed to agents.

These are assigned to agents, multiple queues can be assigned to them.

Priorities can be set.

### Agent Hierarchy

- Agents can be grouped by country/region/status etc.

### Users Add

- Can be added using CSV file or by inputting data

# Integration

## AWS Lambda

- write code and upload to serverless
- charged for every 100ms
- can be directly triggered by S3, Kinesis, DynamoDB, CloudWatch & Connect

### Integration with your own services

Amazon connect can interact with your own services via Lambda functions.

This works by fetching results in an IVR, parse to Lambda function which can then be used to interact with your own services or other AWS services.

Resource policy must be set on the AWS lambda function.

### When to Use

- Real time file processing
- Real time stream processing
- ETL
- Mobile Backends
- Web Apps

### Interaction Models

JSON containing parameters, contact data & user attributes is parsed from Contact to the Lambda function.

## AWS Redshift (NoSQL)

Data warehouse designed for large scale data set storage and analysis. Used to perform large scale DB migrations.

Uses columnar databases system

I DONT UNDERSTAND, SOME SOURCES SAY IT IS NOSQL BUT OTHERS SAY IT USES SQL.

Used to data warehouse of CTRs

### When to Use

- Run traditional relational databses in the cloud
- Data warehouses, used to pull data from different resources

## Amazon Kinesis

Analytics for data streaming

### when to use

- routing records
- multiple apps to consumes the same stream concurrently

- Used to deliver CTRs




# TEST

- firehouse !Routing related records (WRONG)

- admin can set phone preferences and role-based access through security profiles
- Open APIs can integration of CCP

- support directories include aws ds, ad, simple ad
