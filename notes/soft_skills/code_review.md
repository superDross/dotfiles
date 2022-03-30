# Code Reviews

Taken from `https://app.gumroad.com`

## Googles Summary on CR

- Be kind
- Explain your reasoning
- Balance explicit directions and letting the developer decide
- Encourage code simplification

## Process

### Bad

- LGTM almost immediately after publishing CR
- Extremely critical `This code is horrible and unmaintainable`, creates a toxic environment
- Don't overly review a hotfix e.g. during an outage due to a bug
- Adding new comments in other sections after the initial code review; sign the reviewer was not being very thorough. This is time consuming.
- Minor bugs regularly being introduced
- MR going through many review cycles (7+)
- CR blocked for styling etc.


### Good

#### Authors

- Small simple code changes in CR are preferred (easier to review, less risk of bugs being missed, time effective)
- The change should be deployable and able to be rolled back (eg. backward db schema changes) 
- CR description should:
  - what and why
  - related tickets, MRs etc
  - images
  - roll back safety (if possible say when not able to rollback after deploying)
  - mention if not backwards compatible 
- Assign the right reviewer (ideally someone who has modified that code recently)
- Author should deal with conflicts about disagreements etc.

#### Reviewers

- Be kind
- Exhibit ownership and responsibility (if a bug gets through you take partial responsibility)
- Start reviewing as fast as possible (within 24 hours)
- Be pragmatic, not striving for perfection
- Be thorough in one review the whole change

- Justified reasoning for blocking:
  - too big to read (split them into multiple MR)
  - overly complex or maintain
  - unreadable code
  - testing gaps, broken builds, fails manual testing
  - risks (making changes during high volume)


## Guidelines

- We should have guidelines:
  - when to open a CR
  - size and scope of CRs
  - author and reviewer expectations
  - MR template
  - escalation procedures
  - when to refactor; part of the CR or a separate CR for refactoring?

- Explicit is better than implicit
- Repetition is better than the wrong abstraction (apply DRY smartly)
- Leave things better than how you found them

## Tooling

- Amazon CodeGuru for auto reviewing some AWS code changes


## Reviewing Checklist

- Check if this actually solves the problem
- Check it fulfils the AC

### Within The Diffs

- Look for edge cases
- Ensure tests cover *all* changes
- Unexpected behaviour changes (raising a different exception/http-error which may break client tools)

- Optimisation; ensure it is performant if appropriate
- Documentation; docstrings, README, confluence
- Complexity; hacks, over engineered, difficult to read.
- Readability; ensure it is simple to read (intent should be obvious) such that anyone, even a junior, can read it.
- Abstraction; class/function should be doing one thing (e.g. a class reading db, calling APIs & cleaning data is doing too many things)
- Module Directory; ensure class in the correct place (e.g. utility func should be in a utils module)

### Outside The Diffs

- Refactoring does not break anything outside changes (e.g. ensure function signature change is changed everywhere when being called)
- Side effects
- Backward incompatible changes (e.g. add new API param that is required; breaks client code)
- Rollback risks (e.g. db migrations that cannot be undone)

TLDR; think about how the code affects the system and dependant systems


## Writing Comments

- Write clear reasoned comments
- Examples of good work, mentoring, raising code quality bar etc. (something to show management)

### Bad Comments

- Don't use 'you' as it sounds like you are blaming them leading to a defensive response
- Not explaining reasoning why it should change
- Don't sound like you are making demands

### Good Comments

- Ask a question e.g. What would happen if the input value is null?

### Comparing

Bad: you didn't check for a null value
Good: this value could be null, causing a server error. If null, a client error should be thrown.

Bad: Change the variable name
Good: I recommend changing the variable name to something more explicit about the data it stores.

Bad: cache the response here
Good: we should cache the response so we are not making the same call over and over again. The data does not change in the <other-service> so we should store the value in memory to speed up the function and not burden the other service with unnecessary calls.
