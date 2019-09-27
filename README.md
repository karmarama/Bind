# Bind

**Bind** is a framework for simple reactive style programming, designed as analternative to frameworks such as RxSwift. It can be used in conjuction with an implementation of Promises, such as [When](https://github.com/vadymmarkov/).

###Output

**Output** is a store for a generic mutable property and a collection of closures that will be called when that property is updated. In our architecture **Output** is typically used in the View Model.

**Initialising**

An Output is  initialised with its initial value, or starts with a nil as its initial value.

**Updating**

An value stored by an **Output** can be updated by calling its `update` function. This function also calls any closures bound to the **Output**.

**Bind**

Calling one of the **bind** functions adds a closure to the dictionary of closures mantained by the **Output** and also calls the closure for the current stored value, if there is one. 

**bind** can be either called directly with a closure, or by passing one or more **Binders** 

###Binder

A `Binder` defines a closure to be called when an `Output` is updated. A  `Binder` is typically returned from an extensions on a type conforming to `Bindable`. **Bind** contains a set of `Bindable` extensions for many UIKit classes so that `Output` can be bound to these classes out of the box. Custom classes can be similarly extended to conform to `Bindable` and `BindableCompatible`. In our architecture, `Output` from the View Model are typically bound to `BindablCompatible` elements of the View from the viewDidLoad method of the View Controller.

###Relay

`Relay` is a special subclass of `Output` that is useful for initiating a chain of reactive events. It is an `Output` that doesn't store any value but will call any stored closures when its `fire` method is called. 

###Subscription

`Subscription` and `SubscriptionContainer` provide a mechanism for unbinding closures from an `Output`, and is useful when using resuable elements such as TableView cells. 

###Functional Extensions

**Bind** also contains some functional extensions that allow `Output` to be transformed in various ways

`combine` combines two `Output`, of type A and B into a new `Output` of type (A, B) that is updated whenever either one is updated and the other has a value. 

`merge` takes two `Output` of the same type, and creates a new Output of that type that is updated whenever either of them is updated. 

`map`  performs a transform over a Value and returns it as `TransformedValue` wrapped in its own `Output`
the `transform` property is the function that transform `Value` into `TransformedValue`, and `map` returns an `Output` of type `TransformedValue`

`flatMap` performs a transform over a Value and returns it as `Output` of type `TransformedValue` by flattening the nested Outputs
the `transform` property is the function that transform `Value` into a new `Output` of type `TransformedValue` and `flatmap` returns a flattened `Output` of type `TransformedValue`


