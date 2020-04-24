# AngularJS

Framework to build single page applications.

## Features

Directives; custom HTML attributes and commands that allow angular to attach specific behaviour to the DOM.

```html
<input data-ng-model="foo">
```

Uses MVC structure:

  Model; the data, usually in JSON
  View; HTML template that allows one to insert JS code via directives
  Controller; the JS that links the data to the templates

Data Binding; ability to syncronise the data and views together

For example, if the data in a model changes the view reflects that change and vice versa.

Expressions; how you output something from the controller to the template.

```js
// controller.js
$scope.definition = {name: 'name', category: 'colours'}
```

```html
// view.html
<div>
  {{ definition.name }}
</div>
```

## Binding & Directives

`ng-app` directive is required to treat a section as an angular application.

If you want the whole app to be treated as an angular app, you can place it in the html tag.

```html
<html ng-app="app-name">
  <head>
    ...
    <script src="lib/angular/angular.min.js"></script>
    <script src="lib/angular/angular-route.min.js"></script>
    <script src="js/app.js"></script>
    <script src="js/controllers.js"></script>
```

`ng-model` binds user input as a variable that can be used as an expression.

```html
<div>
  <input ng-model="query"> 
</div>
<div>
  <label>
    search {{ query }}
  </label>
</div>
```

## Modules and Controllers

To define a module, place something like this at the top of the JS file:

```js
myApp = angular.module(<module-name>, [<dependency>, <dependency>])
```

`$scope` is a global object that is shared between the controller and the view.
This should be placed inside the controller.

To create a controller in the same file:

```js
myApp.controller('MyController', function myController($scope) {
  $scope.artist = { 'name': 'Bob Dylan' }
}
```

The scope can now be used in the view as an expression `{{ artist.name }}`.

## Services

Services are uses to organise and share code across your app.

There are some built in ones like `$http`, this allows you to handle Ajax requests.

It is run async and returns a promise.

Example usage:

```js
myApp.controller('MyController', function myController($scope, $http) {
  $http.get('js/data.json')
    .then(function(response) {
      $scope.data = response.data;
    });
}
```

## Filters

These can be used to convert text, numbers etc. in an expression.

For Example, converting all strings to uppercase:

```html
<div>
  {{ item.name | uppercase }}
</div>
```

Indexing a list:

```html
<li ng-repeat="item in artists | limitTo:4">
// equivalent to list[:4]
```

Filtering artists by those that partially match user inputted text:

```html
<div>
  <input ng-model="query"> 
  <li ng-repeat="item in artists | filter: query">
</div>
```

Order by a attribute name in reverse:

```html
<li ng-repeat="item in artists | orderBy:'name'":reverse>
```

Using an model for ordering:

```html
<input data-ng-model="artistOrder">
<li ng-repeat="item in artists | orderBy:artistOrder":reverse>
```

## Deep Linking

Deep Linking; making URLs load different content

Handled with `ngRoute` and can be configured with the `$routeProvider`
which can specify which URLs can load what content.

The directive `ng-view` will load up the code depending on your URL.

To Be Continued (don't need to know more now)
