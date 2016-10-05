import 'package:reflectable/reflectable.dart';
export 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector() : super(
      typeCapability,
      superclassQuantifyCapability,
      subtypeQuantifyCapability,
      newInstanceCapability,
      declarationsCapability,
  );
}

const reflector = const Reflector();
