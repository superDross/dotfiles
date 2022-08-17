# Technical

Split into 2 parts of 45 minutes:
  - Talking through a project from your previous experience
  - System design problem


## System Design

There was a Django app that was dependant upon a slow old system that contained interaction data.

The data in the Django app was stored in a postgres database.

The members data and job data were present separate tables.


The answer was to migrate the members data along with all associated jobs applied to into a single documents.

Then migrate all the interaction data via APIs and match with member data and add the interactions as an array to the individual member document.

By doing this no joins are required and all the data is consolidated into one document.


## Questions to Ask


- What is you deployment process? How often do you deploy?

- Describe the levels of engineers on the team and the total number (what percentage composition are senior/mid/junior)

- Say I were to pick up a feature request ticket, can you walk me through what the process would be for me closing that ticket and getting that work deployed to production?

- How often do you and your devs do overtime (work outside the core hours)?

- Do you have tests? What is the coverage? Are tests added as part of each MR?

- What is you deployment process? How often do you deploy?

- Version control setup?

- Is there a standardised development environment and how quickly can a dev setup one locally? Docker?


### Important Questions

- What is the systems architecture?

- What are the biggest tech debt issues at this time? Are you actively reducing this debt and if so how?

- Do teams own specific projects? Or are they assigned to whatever project needs worke done at any given time?

- What is the biggest change you have noticed since you started x years ago?

- What is the one thing you would change at this company?

- How do engineers collaborate? Design meetings, pair programming etc.

- Any restrictions on OS, software or editor usage?


### To Managers

- What is the biggest process improvement you have made over the last year to make devs lives better?

- What is the process for determining what task I'll be working on?

- What would you expect in the first 3-6 months from a successful candidate?

- How often do you encourage your devs to explore new technologies? (IF YES), When was the last time you did this and what was the problem to solve?

- How often do you guys do meetings? What are the purpose of those meetings?


## Project

## IVWBot

### Problem

Scripting errors were being ignored, we needed away to alert scripters so they know when an error is out in the field and it needs to be rectified.

### Proposal

Create a SlackBot that receives New Relic errors and posts alerts to a given slack channel and tags the scripter.

They can then interact with the message (in progress, complete, etc.)

### Architecture

Mongo for the back end with base model for collection.

FastAPI as the framework, for validation at api endpoints

Slack bolt and slack sdk for creating blocks & pushing notifications.

We have a new relic app that calls the error_raised endpoint that performs all the logic

lru_cache for a lot of heavy endpoints that do not change much:
  - getting channel data (channel id from channel name, requires iterating through all conversations until we hit the correct channel name)
  - getting user name from user id or user email
  - getting user email from user name


#### Endpoints

- error_raised - posting alerts to slack
- error_get_raised - get alert form db 
- status - get feature flags status
- report_outage - report outage based on new relic data

#### Features
Feature flags for turning off of on stuff like notifications/alerts toggle, outage report,


## Scriptie

Gets the alerts data from mongo by creating an endpoint to expose said information in a preferred format for the FE

This returns all error for a given questionnaire version.

This allows the FE guys to expose the alerts inside the scripters online editor so they know if there is an existing issue with a given version or not.

Some data manipulation needed like sorting the interactions and renaming them e.g. error_solved to closed.

Creating the Slack url from pieces of info we have (channel id, message id etc.)
