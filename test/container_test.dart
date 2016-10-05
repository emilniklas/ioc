import 'package:quark/quark.dart';
export 'package:quark/init.dart';
import 'package:ioc/ioc.dart';

class ContainerTest extends UnitTest {
  Container container;

  @before
  setUp() {
    container = new Container();
  }

  @test
  itCanMakeAnInstanceOfAClass() {
    expect(
        container.make(SimpleClass),
        new isInstanceOf<SimpleClass>()
    );
  }

  @test
  itCanMakeTheNeededDependencies() {
    expect(
        container.make(ClassWithDependency),
        new isInstanceOf<ClassWithDependency>()
    );
  }

  @test
  itCanBindAnAbstractType() {
    container.bind(AbstractClass, toClass: ConcreteClass);

    expect(
        container.make(AbstractClass),
        new isInstanceOf<ConcreteClass>()
    );
  }

  @test
  itCanBindASingletonClass() {
    container.bind(AbstractClass, toSingletonClass: ConcreteClass);

    expect(
        container.make(AbstractClass),
        container.make(AbstractClass)
    );
  }

  @test
  itCanBindAFactory() {
    container.bind(AbstractClass, to: () => new ConcreteClass());

    expect(
        container.make(AbstractClass),
        new isInstanceOf<ConcreteClass>()
    );
  }

  @test
  itCanBindASingletonFactory() {
    container.bind(AbstractClass, toSingleton: () => new ConcreteClass());

    expect(
        container.make(AbstractClass),
        container.make(AbstractClass)
    );
  }
}

// Plain classes
class SimpleClass {}
class ClassWithDependency {
  final SimpleClass dependency;
  ClassWithDependency(this.dependency);
}
abstract class AbstractClass {}
class ConcreteClass implements AbstractClass {}

// Token registry
class SimpleClassToken extends SimpleClass with Token {}
class ClassWithDependencyToken extends ClassWithDependency with Token {
  ClassWithDependencyToken() : super(new SimpleClassToken());
}
class ConcreteClassToken extends ConcreteClass with Token {}
