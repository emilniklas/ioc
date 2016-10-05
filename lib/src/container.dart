import 'reflector.dart';

class Container {
  final Map<Type, Function> _bindings = {};

  dynamic/*=T*/ make/*<T>*/(Type type) {
    if (_bindings.containsKey(type)) {
      return _bindings[type]();
    }

    final ClassMirror mirror = reflector.reflectType(type);
    final MethodMirror constructor = mirror.declarations[mirror.simpleName];
    final List params = constructor.parameters.map(_makeParameter).toList();
    return mirror.newInstance('', params);
  }

  dynamic _makeParameter(ParameterMirror parameter) {
    return make(parameter.type.reflectedType);
  }

  void bind(Type type, {
    Function to,
    Function toSingleton,
    Type toClass,
    Type toSingletonClass,
  }) {
    if (to != null) {
      return _bindToFactory(type, to);
    }

    if (toSingleton != null) {
      return _bindToSingletonFactory(type, toSingleton);
    }

    if (toClass != null) {
      return _bindToClass(type, toClass);
    }

    if (toSingletonClass != null) {
      return _bindToSingletonClass(type, toSingletonClass);
    }

    throw new ArgumentError(
        'A binding target was not supplied. Please provide any of the '
        '[to], [toSingleton], [toClass] or [toSingletonClass] parameters'
    );
  }

  void _bindToClass(Type type, Type toClass) {
    _bindings[type] = () => make(toClass);
  }

  void _bindToSingletonClass(Type type, Type toSingletonClass) {
    var instance;
    _bindings[type] = () {
      return instance ??= make(toSingletonClass);
    };
  }

  void _bindToFactory(Type type, Function factory) {
    _bindings[type] = factory;
  }

  void _bindToSingletonFactory(Type type, Function factory) {
    var instance;
    _bindings[type] = () {
      return instance ??= factory();
    };
  }
}
