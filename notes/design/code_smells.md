# Code Smells

## Definition

Smells are structures in the code that indicate violation of fundamental design principles and negatively impact design quality.

- warnings pointing inefficiencies and potential weaknesses
- makes code brittle

Designs smells are architectural issues like:
- improper abstractions
- unhealthy dependencies

### Code Smell Example

An example would be to duplicate a new method across multiple classes.

It is a smell because if you want to add a method you would have to do it to all three classes.

This leads to bugs/crashes if you forget to put it in one place.

Solution would be to use a helper function instead.

### Design Smell Example

Numerous examples: `http://www.designsmells.com/articles/does-your-architecture-smell/`


## Method Level

- method names that are too long or too short
- bloated methods the are very long (break up method into multiple)
- excessive method arguments
- excessive amounts of return data (like a tuple with multiple values)
- God line; a line so long and hard to read it is impossible to refactor, debug or reuse

More often than not the solution is to break up the functionality into multiple vars/methods to
ensure readability.

- Find the core purpose of you methods
- Focus on what the code does and not how it does it

## Class Level

- **oversized classes (AKA God objects)**; classes so long they become unreadable and do too much
- **undersized class**; does it even need to be its own class or part of existing one.
- **feature envy**; when a class excessively uses methods from another class (becomes dependent and brittle)
  - transfer code to dependent class(es) or use dependency injection techniques
- **inappropriate intimacy**; class is dependent on another class's implementation e.g. calling other classes private methods
  - refactor code or create a shared implementation
- **literal usage**; hard-coded values lead to errors and modifications difficult
  - keep them in a database instead of as constants
- **data clumping**; passing around the same primitive data values
  - create a data model or object and pass that instead

Think about classes as individual and self-sufficient.

## Application Level

- shotgun surgery; so much duplication code throughout the code base that your code will break
- contrived complexity; using design patterns just for the sake of it; being complex for the sake of complexity

## Design Smells

### Abstraction

- missing abstraction (aka data clumping); literals used instead of a data model
- multifaceted abstractions; class that has more than one responsibility e.g. one that encodes, decoding, writes and reads data
  - separate into 2 classes; encode/decode and read/write
- duplicate abstractions; classes that have the same name/behavior
  - look for similar class responsibilities and rector them into a single abstraction
- incomplete abstractions; classes that do not fully support a responsibility
  - derived classes aren't forced to fully implement their responsibility from parent class

### Encapsulation

- deficient encapsulation; abstraction are exposed or poorly protected
- unrestrained encapsulation; globally visible abstraction state
- unexploited encapsulation; using excessive conditionals/switches that execute different behaviour depending on the objects type
  - use polymorphic methods in the object and decouple client code from object type checking

### Modularisation

- insufficient modularisation; an abstraction is still too long
- broken modularisation; shows when data that should be grouped and spread across multiple abstractions
  - focus on refactoring together like minded behaviors or information
- cyclically dependent modularisation; tightly coupled abstractions
  - refactor out dependent code to decouple implementations

### Hierarchy

- polygon hierarchy; base abstraction repeatedly inherited
- broken hierarchy; when a base and derived abstraction
  - replace the inheritance with composition
- complex hierarchy; tangled hierarchy graphs
  - decompose complexity
- cyclic hierarchy; supertype contain a subtype object etc.
