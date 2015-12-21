import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task()
test() {
  var testRunner = new TestRunner();
  testRunner.testAsync(runOptions: new RunOptions(workingDirectory: 'backend'));
  testRunner.testAsync(
      runOptions: new RunOptions(workingDirectory: 'frontend'));
}

@DefaultTask()
@Depends(get, test)
build() {
  Pub.build(runOptions: new RunOptions(workingDirectory: 'frontend'));
}

@Task()
get() {
  Pub.get();
  Pub.get(runOptions: new RunOptions(workingDirectory: 'shared'));

  Dart.run('build.dart',
      runOptions: new RunOptions(workingDirectory: 'shared'));

  Pub.get(runOptions: new RunOptions(workingDirectory: 'frontend'));
  Pub.get(runOptions: new RunOptions(workingDirectory: 'backend'));
}

@Task()
upgrade() {
  Pub.upgrade();
  Pub.upgrade(runOptions: new RunOptions(workingDirectory: 'shared'));

  Dart.run('build.dart',
      runOptions: new RunOptions(workingDirectory: 'shared'));

  Pub.upgrade(runOptions: new RunOptions(workingDirectory: 'frontend'));
  Pub.upgrade(runOptions: new RunOptions(workingDirectory: 'backend'));
}

@Task()
clean() => defaultClean();
