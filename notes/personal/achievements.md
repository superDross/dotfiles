# Achievements

## 2020

- Fixed the global approver system in Datum (commit:692e8e45)
  - issues where the global status was not working due to bad SQLAlchemy

- Created audit process that records random missing cases
  - refactored existing code so components are reused (with audit) and adding tests that were not there

- Setup black template repo as means to keep consistancy (headed doc writing)
- Fixed numerous long standing bugs in Capn, coming from Crunch
- Trained Joju to help out in crunch-dev by doing pair programming when troubleshooting issues.

- Added search functionality in our data storage web app.
- Fix streamer when it causes problems

Weblate
  - Organised documentation, meeting & discussion about utilising weblate client Python API instead of creating our own
    - https://confluence.yougov.net/display/SST/Weblates+Python+API+Evaluation
  - 


Weblate:
  - Fixed unable to upload translations to Weblate via Dragoman which was preventing us from progressing (b2a94699: dragoman-core)
  - Identified and fixed a race condition affecting Dragoman/Weblate (after the release) whereby under certain circumstances a new phrase could be added twice to the database, which was affecting the integration; users unable to manipulate their translations in weblate via dragoman-ui (424c5a59: dragoman-core)
  - Did the majority of the work for the dragoman migration effort, including identifying & rectifying (the neverending) edge cases associated with this effort.
  - Created almost all of the documentation for the Dragoman-Weblate effort (including the release plan) DRA-192
  - Documentation created for allowing developers to develop during the weblate efforts (

## 2021

### 12th Feb

- [GRYP-6377] the ticket asked to reimplement/port some behaviour in qdf lib to the quesadilla library so it can parse objects sets
  - instead I found we could simply replace the queso library with qdf library in philae
  - this reduced code duplication across repos, the time taken to complete the task & number of philae dependencies

- [GRYP-6395] create weblate components when adding new translations
  - we were reimplementing alot of weblate client code for this and previous tickets
  - I suggested in using a common libraray (yg.weblate) that would reduce code duplication across respos for all present and future translation projects

### 19th Feb

- Found a bug in wlc and the newest version of weblate (4.4.2) that broke importing po files in Dragoman the day before releasing 4.4.2
  - pair programmed with Adrian & Ian to quickly find a solution (alteration in how requests are made in wlc broke when weblate upgraded the translation-toolkit package in weblate 4.4.2)
  - https://github.com/WeblateOrg/wlc/pull/88

- [GRYP-6395] facilitate qx/component and locale creation, and uploading multiple translation files to weblate via philae.
  - provided the majority of the core philae to weblate functionality

### 28th Feb

- [DRA-402] - moved the majority of webalte client code from dragoman-core to yg.weblate
  - this meant we had no duplicate weblate client code between dragoman and philea; they were sharing the same code

### 5th March

- [DRA-418] - found and fixed an issue that was breaking source string uploads when testing this ticket jsut before the release of Weblate 4.5 internally.
  - this was due to some unannounced changes to the component model in the newest version of weblate that broke our workflow
  - https://gitlab.yougov.net/G/yg.weblate/-/merge_requests/10


### 15th March

- [GRYP-6530 & GRYP-6531] - only route messages to the correct consumer and allow the use of multiple consumer procs
  - modified consumer and producer to headers exchange type and simplified the logic of the consumers too
  - this was an issue as we could not scale properly with only one consumer
  - https://gitlab.yougov.net/G/weblate-deployments/-/merge_requests/68
  - https://gitlab.yougov.net/y/dragoman/-/merge_requests/39

### 26th March

- [DRA-437] - Found a bug whereby the redis and mongodb translations were out of sync, managed to implement the fix and increase testing accuracy
  - we wanted to keep them both in sync in case we bail on Weblate and go back to using mongo in philae, if they are out of sync it would be impossible to do this

### 2nd April

- discussed with the dev lead about my concerns regarding the maintainability of philae with our changes. Which led to GRYP-6549 being created.
- created flow diagrams (in MIRO) and a document https://confluence.yougov.net/display/SSPD/Refactor+Suggestions
- resulted in numerous tickets being created that helped reduce the complexity of our work and increase maintainability


### 9th April

- [GRYP-6554] - dependency trees for qx versions, fixed the panoptic development environment as part of this ticket.
- https://gitlab.yougov.net/G/gryphon/-/merge_requests/890 (use the same mongodb as panoptic)
- https://gitlab.yougov.net/G/panoptic/-/merge_requests/307/commits (feature, includes making local panoptic mountable)
- https://gitlab.yougov.net/G/panoptic/-/merge_requests/308 (removal of sed in dockerfile broke the dev container)

### 16th April

- Acted as lead developer while Adrian was off
  - Asked David G to liase with Darwin regarding a potential issue with UAT and redis secrets
  - Supprted DP when was having issues with making requests to weblate staging (needed correct key)

- Refactored some philae code GRYP-6559 & GRYP-6560

### 23rd April

- [GRYP-6562] - sped up gryphon production by caching (most) panoptic responses in philae in `main` branch (we gained 10ms per request to philae so 25% decrease in response time) and drastically reduced the number of overall requests to panoptic.
  - first attempt did not work due to non centralised chache (lru cache) being utilised
  - second attempt also did not work (using redis) picking and unpickling `QuestionnarieVersion` to and from redis causes data corruption when deserializing

### 7th May

- Deployed most of the NR APM tickets e.g. GRYP-6569
- Fixed wlc issues causing nightmares - GRYP-6627

### 14th May

- Uneventful week

- GRYP-6627: created wlc custom exception message. Message was not being parsed to the exception, which was problematic when debugging. Ticket was my own suggestion.

### 21st May

- Helped Dani get dragoman-ui with a local weblate setup (this was a blocker for him). Found a bug in the process, fixed said bug (`https://gitlab.yougov.net/G/yg.weblate/-/merge_requests/19`) immediately and updated the dragoman-ui documentation to ensure future developers can get their local environment setup ASAP. 

- Fixed numerous Queso validators bugs and created some new ones

### 28th May

- Completed all backend tickets for the Datum Permission sprint several days before the deadline (IS THIS TRUE?)
- Reduced technical burden by suggesting to implement the hierarchy logic on the FE only
  - I found to alter a codebooks you have to send the entire codebook tree in JSON format on the PUT request
  - FE had to create the hierarchy logic on the FE anyway so the permissions would visually change as the user revoked permissions throughout the tree
  - As the entire codebook tree had to be sent to the BE, we could simply utilise this to modify the values of the DB without having to reimplemnt the algo on the BE

### 4th June


### 11th June

- Migrated the airportlocker to utilising the mongos available to the clusters node and updated it to use helm3 (GRYP-6674)

### 4th July

- Researching Pact

### 12th July

- created ygapp charts to migrate philae over to k8s (GRYP-6772)
- came up with a Pact POC plan with Garana

### 6th Aug

- Introduced the entire SST team to Pact Contract testing by:
  - giving a talk on how it works
  - creating some documentation: https://confluence.yougov.net/pages/viewpage.action?pageId=157286563
  - created demo consumer and provider applications hooked up to the YGO pact broker with pact integrated into the CI pipelines (`https://gitlab.yougov.net/G/pact_consumer`, `https://gitlab.yougov.net/david.ross/pact_provider`)
  - created a recording of me explain the above demo applications and demonstrating the process when a contract is broken and fixed.

- Added integration testing to our ivwbot both executable locally and in the pipeline: `https://gitlab.yougov.net/sst/ivwbot/-/merge_requests/6`
  - prior to this there was no means of executing testing in the pipeline or locally due to a lack of slack mocked server

- Added testing pipeline for the platform control pipeline
  - prior to this there was zero tests and no pipeline stage for executing the tests: `https://gitlab.yougov.net/devops/platform-control/-/merge_requests/8/diffs?commit_id=41413e950e56c00f3957bcd427ba948de39b8337`

### 12th Aug

- Identified & fixed numerous bugs affecting production
  - https://jira.yougov.net/browse/GRYP-6943 (variable not given a default value, causing all empty interlude messages failing to be published)
  - https://jira.yougov.net/browse/GRYP-6944 (KUBE HOST IP not resolving correctly)

- Modified live monitoring to use ivwbot
  - https://jira.yougov.net/browse/GRYP-6862

- Taught & guided a new stremaing team to maintain gryphon-streaming
  - included ad hoc program pairing
  - guidance and answering technical questions

### 21st Aug

- Started buddy mentoring program with Ras graduate developer
- Introduced 4 graduate developers to our translation applications

- Added home view for IVWbot to enable disable streaming
  - https://jira.yougov.net/browse/GRYP-6896


### 27th Aug

- Helped move over the live montioring script to sst namespace and set up Gitlab CI to build and deploy it to k8s
  - GRYP-6892 when Ian did the outages etc.

### 10th Sept

- Mentored Ras


### 1st Oct

- mark qx as bad using async requests GRYP-7097

### 8th Oct

- Added new field in the qdf (`qsl_lineno`): https://jira.yougov.net/browse/GRYP-7085


ADD FIX FOR GRYP-7146 WITH DETAILED EXPLANATION


### 15th Oct

A change to panoptic caused scripters to be unable to commit questionnaires

GRYP-7146 was created:

- https://gitlab.yougov.net/G/queso/-/merge_requests/161
- https://jira.yougov.net/browse/GRYP-7146

We have a function that adjusts an given string index number (pointing to a char of interest `{`)
after a string has been decoded.  Decoding the string alters the position of the character so the
given string index number has to be adjusted.

The old algorithm uses `difflib.SequenceMatcher` to check for changes. The results are iterated
over and any non equal matches found results in the given index number being incremented/decremented
(inc if decoded string larger than original string). The adjusted index number is returned.

This is slow because it compares every single character in both strings and compares them, generates an
object that represents a change/equal/replacement. This is very inefficient and unfeasable for long strings.

The pre-existing algorithm was so slow that it substantially increased response time resulting in scripters
being un able to commit qsl scripts.


```py
def _adjust_interlude_charno(self, interlude_charno, decoded_src):
    """
    Adjusts a given interlude character number after decoding the qsl src code.

    Decoding qsl source containing non-ascii characters will reduce its length,
    we will therefore need to adjust the interlude location to ensure it is
    accurate relative to the decoded version.

    :param: interlude_charno: character number in which an interlude begins in self.src
    :type: interlude_charno: int
    :param: decoded_src: a decoded version of self.src
    :type: decoded_src: str
    :rtype: int
    """
    diff = len(self.src) - len(decoded_src)
    if diff:
        # we need to get the index of the decoded character
        match = difflib.SequenceMatcher(None, self.src, decoded_src)
        decoded_chars = [char for char in match.get_opcodes() if char[0] != "equal"]
        decoded_charno = decoded_chars[0][1]
        if interlude_charno >= decoded_charno:
            interlude_charno -= diff
    return interlude_charno
```

The fix was to create a custom algorithm that checks for the difference betwwen the
length of the original string and decoded string. This difference (a number) was then
iterated/decremented over and added to the original index number. We compare the character
at this modified index number at each iteratcion and return the modified index number if the
character matches the original character.

For example, if the decoded version of the string is 6 characters longer and the original index
number is 20. We incrementally check the character at index 21-27 of the decoded string for a match,
increment the index number. We return the the modified index number (say 23) when a match is found.

This is substantially faster as we are not comparing every character but rather only comparing characters
relative to the change in length.


```py
def _adjust_interlude_charno(self, interlude_charno, decoded_src):
    diff = len(decoded_src) - len(self.src)
    if diff:
        char = self.src[interlude_charno]
        decoded_char = decoded_src[interlude_charno]
        if char == decoded_char:
            return interlude_charno

        if diff > 0:
            for n in six.moves.range(1, diff + 1):
                interlude_charno += 1
                decoded_char = decoded_src[interlude_charno]
                if char == decoded_char:
                    return interlude_charno

        if diff < 0:
            for n in six.moves.range(1, abs(diff) + 1):
                interlude_charno -= 1
                decoded_char = decoded_src[interlude_charno]
                if char == decoded_char:
                    return interlude_charno
    return interlude_charno
```

I tested the function with 20 million character strings with differences
inserted into each one randomly and found the average execution time for:

- The old function is 8.9 seconds
- The new funciton is  0.0000009 seconds

```
def _adjust_interlude_charno(self, subtree, decoded_src):
    """
    Adjusts a given interlude character number after decoding the qsl src code.

    Decoding qsl source containing non-ascii characters will reduce its length,
    we will therefore need to adjust the interlude location to ensure it is
    accurate relative to the decoded version.

    We adjust the interlude start and ending indexes based upon the difference in length.
    If the resulting indexes can be used to slice the expected interlude code from the
    decoded source then we have the correct index number.

    Otherwise, we have unicode character(s) after or within the interlude of interest.
    We therefore have to use a sliding window technique to find the true interlude
    starting index number in the decoded string.

    if unicode characters are used within the interlude, then the interlude will be of a
    different length. Hence the need for `starswith` method.

    Note: decoded strings are always shorter e.g. 'D\xc3\xbcff' decodes to u'D\xfcff'

    :param: subtree: contains interludes start and end characters indexes
    :type: interlude_charno: tuple
    :param: decoded_src: a decoded version of self.src
    :type: decoded_src: str
    :rtype: int
    """
    inter_idx, inter_idx_end = subtree[1], subtree[2]
    diff = len(self.src) - len(decoded_src)

    if diff:
        # adjust the decoded interlude starting index based on qsl length difference
        dec_inter_idx = inter_idx - diff
        dec_inter_idx_end = dec_inter_idx + (inter_idx_end - inter_idx)

        interlude_code = self.src[inter_idx:inter_idx_end].decode("utf-8")
        decoded_interlude_code = decoded_src[dec_inter_idx:dec_inter_idx_end]

        if interlude_code == decoded_interlude_code:
            return dec_inter_idx

        while dec_inter_idx < inter_idx:
            dec_inter_idx += 1
            decoded_interlude_code_start = decoded_src[dec_inter_idx:]
            if decoded_interlude_code_start.startswith(interlude_code):
                return dec_inter_idx

    return inter_idx
```

Final solution


## 29th Oct

- Convinced team to use Neo4J as the graph database of choice by showing an academic paper with query time estimates across multiple graph databases
- Did an analysis of most promising graph databases and documented the pros and cons
https://confluence.yougov.net/display/SST/Graph+Databases+Comparision

## 5th Nov

Graph Database

- found various issues with our setup:
  - added release stage pipeline to graph-utils ci
  - convinced team to use neo4j enterprise (constraints locked behind it, can't have PK without it)
  - inputted and critisced the data model made suggestions the team employed

- Created test data for the project
  

## 12th Nov

- Part of a presentation showing our POC to directors/stakeholders
- Added some endpoints to the poc

## 19th Nov

- Developed a means to wait for neo4j to start before executing tests. This allowed us to use the neo4j service with our tests.
 https://gitlab.yougov.net/sst/POC_gotoproject/-/commit/16f8a499e450c0ae99151c5f8aa9fa6cfe207f1e

- Setup AWS Neptune with our graph POC implementation.

## 3rd Dec

- Completed the Goto Graphs POC


## 10th Dec

Not sure if there is anything note worthy this week...


## 17th Dec

Created new method for history interlude syntax. Add `get` method where you can return a default value.

This checks for the answers an panelist gave for a given surveys question and supplies a given default value if none are found.

```py
{
  answer = 'no'
  if 1 in history.survey.get('question', []):
      answer = 'yes'
}
```

Was difficult as there was no documentation on how to do this:

  - https://gitlab.yougov.net/G/queso/-/merge_requests/170
  - https://gitlab.yougov.net/G/queso/-/merge_requests/172
  - https://gitlab.yougov.net/G/queso/-/merge_requests/173
  - https://gitlab.yougov.net/G/gryphon/-/merge_requests/1221


## 23rd Dec

- DRA-514 moved dragoman over to k8s
- DRA-514 dockerised dragoman/weblate application

- DAT-5454: fixed a bug in the codebook permissions whereby the permission is not set when a new category or entry is created
https://gitlab.yougov.net/y/datum/-/merge_requests/1094/diffs


## 14th Jan

- Deploying dragoman to k8s
- Used AST to detect '_' calls in qsl and give warning: https://gitlab.yougov.net/G/queso/-/merge_requests/178


## 21st Jan

- 100% dragoman to k8s
- Fixed a bug that caused the widget text to be shown in english regard less of requested language
  - https://jira.yougov.net/browse/GRYP-7498

## 28th Jan

Nothin I am particularly proud of

## 18th Feb

- Migration of compass data
- Setup deployment environments
- Update underscore AST to find instances when func is called within concatenation and not caseted as a string

## 11th March

- created pipeline jobs to detect changes in transltion POT file and upload it if found: https://gitlab.yougov.net/G/gryphon/-/merge_requests/1548

## 25th March

- Add endpoint to panoptic to ensure we can get rid of panman RPC

## 27th May

- GRYP-8188 moved logic to using database error alerts data instead of getting slack post, modying and updating them
https://gitlab.yougov.net/sst/ivwbot/-/merge_requests/113

Not a trivial task, took a lot of work and testing to ensure it was good prior to deploying to production.

## 1st July

- GRYP-8406 separated nr streamer into a new project

- GRYP-8348 refactored some of the logic along with fulfilling the tickets AC (I WANT TO HAVE MULTIPLE CASES OF THIS PRESENT OVER THE YEAR)

## 15th July

- refactored ivwbot logic further, including organising meeting with other devs about how we want to abstract the db model for ErrorAlert
 - Create a base model class that has pydantic base model as a parent: https://jira.yougov.net/browse/GRYP-8400


## 13th Aug

- created documentation to spin up weblate locally, this was not possible before and required a lot of time to do so.
  - this was important as it was something we had not had before and was something people did not want to do
	https://gitlab.yougov.net/G/weblate-deployments/-/merge_requests/115
