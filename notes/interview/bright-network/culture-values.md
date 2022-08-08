# Culture & Values

## Values


The company has 3 values and a question around each of them during the interview. Below contains the values and some examples I have around that meet said values.

### Growth Mindset

Value: you proactively seek out opportunities to push yourself knowing that there's no such thing as failure (only learning from mistakes)

Examples:


- Pushed to architect, create tickets and lead on a project

- We have an slack bot the pushes NR errors in our questionnaires from NR to our Slack instance to alert scripters of any qx errors
- The problem is not all users pay attention to slack so we needed away to display these in the editor scripters use to create the questionnaires.
  - Me and the lead developer created an micro service using FastAPI to aid displaying various alerts in our primary monolith (Gryphon)
  - This alerts are present in Slack (via a slack bot) and the data for the alerts are stored in Mongo
  - This essentially took the relevant documents from mongo, modified it to the FE liking and constructed a slack url to access the original alert
  - This data was then available via an endpoint


- **Headers** where the message is bound to queues based on multiple criteria (in a JSON like format)


- Took on a ticket without knowing the underlying technology (fedora messaging in weblate) was a blocker for releasing the project with middle managements eyes on it (no one else wanted to do it)
  - fedora messaging is built atop rabbitmq, weblate has its own package that modifies fedora messaging behaviour and docs are awful
  - webalte only allowed fanout exchange, but topic exchange was recently introduced
  - We could not correctly configure the messages to route to specific consumers so we could not scale up until modifying it to topic exchange
  - played around with fedora messaging and weblate variant that evening
  - Solution:
    - required multiple changes to toml files for weblate application
    - required configuration changes to the fedora consumer including binding alterations and declaring correct exchange type
    - alter the consumer to take the action from the header


- Giving talks about technology (Pact, upcoming command line) even though I get quite anxious doing it


### Will to Win

Value: striving to exceed expectations and deliver the highest quality results for the business.

- To exceed expectations I often refactor to simplify areas of the code I am working on when completing a ticket
- Efficiency; some of our projects have long unit test times, long CI or deployment process which does not require input. During these times I have, resumed linkedin learning courses e.g. Async python, respond to slack questions, help out the grad
- Push ourselves; often if there are no tasks in the backlog I will push for refinements (often of tickets I have created).


### Quality of Our Work

- Often ask for help and deliver it if required
- Mistakes own up to
  - give the Weblate DB deletion (lockfile disallowed modifying files) example learn not to panic.
  - migration using the API instead of using the Django ORM to migrate the data.


## Questions to Ask

Ally Monk (people)
  - What has been implemented to encourage/ensure the three cultural values are adhered to?
    - How do you encourage people to continue to grow professionally and go the extra mile? 
    - Will to win and push themselves independently?
    - Trusted to deliver; give me an example of a time someone made a mistake that had repercussions on the business, how did you handle that with said person (no blame culture)?
    - Ensure that the best ideas win (people have egos)?

Ailsa Simpson (product)
  - Can you give me a time when the developers pushed back against a feature request? How did you deal with that situation?
  - Is Agile Scrum strictly adhered to? Have you ever adapted it to suit the developers needs, example?


Tom Brightwell (CTO)
  - What is your leadership style and how do you like to *be* lead?
  - Opportunities to work on other projects or is one team only working on one project at a time?
  - How do you see the team evolving over the next couple of years?
  - What do you think are the biggest challenges that the company face in the upcoming year(s)?
  - If there is one thing you would like to see your development improve upon, what would it be?

