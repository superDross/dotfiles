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
</p>
```

Interpolation; data binding to views by applying curly braces around a component property

```
<h1>{{movie.title}}</h1>
```

Dependency injection (DI) are used in class constructors.

Inversion of control; architect code in a way that you provide modules with other modules it needs.

DI uses IoC

Service; a JS class/function that encapsulates some business logic as a service for our app.

Service; used to create components that can be used across the entrie app

Components use services (do not place business logic within components)

Routing;
