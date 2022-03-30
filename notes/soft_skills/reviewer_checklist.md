# Reviewers Checklist


## Before The Diffs

- Read the description and ticket
- Check if this actually solves the problem
- Check it fulfils the AC


## Within The Diffs

- Look for edge cases
- Ensure tests cover *all* changes
- Unexpected behaviour changes (raising a different exception/http-error which may break client tools)

- Optimisation; ensure it is performant if appropriate
- Documentation; docstrings, README, confluence
- Complexity; hacks, over engineered, difficult to read.
- Readability; ensure it is simple to read (intent should be obvious) such that anyone, even a junior, can read it.
- Abstraction; class/function should be doing one thing (e.g. a class reading db, calling APIs & cleaning data is doing too many things)
- Module Directory; ensure class in the correct place (e.g. utility func should be in a utils module)


## Outside The Diffs

- Refactoring does not break anything outside changes (e.g. ensure function signature change is changed everywhere when being called)
- Side effects
- Backward incompatible changes (e.g. add new API param that is required; breaks client code)
- Rollback risks (e.g. db migrations that cannot be undone)

TLDR; think about how the code affects the system and dependant systems


## Writing Comments

- Be kind
- You are making recommendations, not demands
- Explain your reasoning
- Balance explicit directions and letting the developer decide
- Encourage code simplification

- Leave some positive comments if you found something you learned or is outstanding
- Don't use `you`, say the code is problematic
- Don't write like you are demanding, use something like `I would recommend doing...`
- Mention nitpicks explicitly stating they are not blockers
- Provide learning resources associated with these changes if talking to a junior

Use the `Start Review` feature to add and edit comments as you go
