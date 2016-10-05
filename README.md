# Mirror based dependency injection for client side Dart

Most dependency injection frameworks for Dart is dependent on annotations
on the classes that will be injected. This is a problem, because not only
does it force your business logic to have a source code dependency on
the DI framework, sometimes the classes you want to inject is not even
a part of your code. It can reside in a library.

We can use `dart:mirrors` to resolve this issue, because then we can use
reflection to look at the constructor parameters of a class and inject
those dependencies recursively.

However, there's a problem with using `dart:mirrors` in the browser, because
all that meta information yields excessive JS output. To resolve *that* issue,
we can use the `reflectable` package, which uses special annotations to
describe the meta information we need at runtime, so that only that information
will be included at compile time, using a transformer.

This is the reason that DI frameworks for the client has annotations like
`@inject` to enable that `reflectable` functionality.

It turns out, though, that you can move the `reflectable` annotations to
other classes that have some sort of type relationship with the actual
class we need to inject.

This library is an attempt to do just that. It moves the source code dependency
on the DI framework to the outside of the actual classes, while still making
it feasible to use mirrors with the Dart2JS compiler.

## Usage

Let's say you have a class called `Car`, which has a dependency on an abstract
`Engine` class:

```dart
class Car {
  final Engine engine;

  Car(this.engine);

  void drive() {
    engine.run();
  }
}

abstract class Engine {
  void run();
}
```

Then we have two different concrete implementations of that interface:

```dart
class PetroleumEngine implements Engine {
  void run() {
    print('Wroom!');
  }
}

class ElectricEngine implements Engine {
  void run() {
    print('Humm...');
  }
}
```

If we want to inject the dependency in the `Car` class, we can use the following
code in the `main` part of your app:

```dart
import 'package:ioc/ioc.dart';

final container = new Container();

main() {
  container.bind(Engine, toClass: ElectricEngine);

  final Car car = container.make(Car);

  car.drive(); // <-- Error!
}
```

However, this won't work yet, for the reason that is mentioned in the preface
of this readme; we don't have any runtime type information on the `Car` class!

All we need to do to describe that we need this capability is to add this piece
of code to somewhere in your `main`:

```dart
// Describing the dependencies in the Car class
class CarToken extends Car with Token {
  CarToken() : super(new EngineToken());
}

// Describing that we want to be able to inject an engine
class EngineToken extends Engine with Token {}

// Describing the ElectricEngine
class ElectricEngineToken extends ElectricEngine with Token {}
```

That's it. The code in `main` will now work as expected:

```dart
main() {
  container.bind(Engine, toClass: ElectricEngine);

  final Car car = container.make(Car);

  car.drive(); // Humm...
}
```

Notice that we haven't touched the actual business classes for our app! Profit!
