# Angular

Notes on [HTML DOM](https://www.w3schools.com/whatis/whatis_htmldom.asp)

Angular uses a similar concept where there is a component tree model.

The first component is loaded, looks in the HTML view and checks for nested components. These components are run on those. This repeats down the component tree.

## Features

Component is actually a directive with a template

Directives are here and they are very similar to AngularJS, except the user can construct their own with a `Decorator`.

Directive types:
  - Structural; modify layout by altering elements in the DOM
  - Attribute; change the behavior or appearance of an existing DOM element.

```js
<ul>
  < *ngFor="#item of items">Media Item</li>
</ul>
```

Pipes allow you to transform data without building additional logic. Users can create their own `@Pipe`.

```js
<p>
  My name is {{name | uppercase}}
```


Dependency injection (DI) are used in class constructors.

Service; a JS class/function that encapsulates some business logic.

Components use services (do not place business logic within components)
