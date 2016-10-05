class Car {
  final Engine engine;

  Car(this.engine);

  void drive() {
    this.engine.run();
  }
}

abstract class Engine {
  void run();
}

class PetroleumEngine implements Engine {
  void run() {
    print('Wroom!');
  }
}

class ElectricEngine implements Engine {
  void run() {
    print('Hummm...');
  }
}
