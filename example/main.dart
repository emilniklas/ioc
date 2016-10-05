import 'package:ioc/ioc.dart';
import 'lib.dart';

// We need to define these tokens to make it clear
// for the Dart2JS compiler what type information
// needs to remain in the JS runtime.

class CarToken extends Car with Token {
  CarToken() : super(new EngineToken());
}

class EngineToken extends Engine with Token {}

class PetroleumEngineToken extends PetroleumEngine with Token {}
class ElectricEngineToken extends ElectricEngine with Token {}

void main() {
  final container = new Container();

  container.bind(Engine, toClass: PetroleumEngine);

  final Car car = container.make(Car);

  car.drive();
}
