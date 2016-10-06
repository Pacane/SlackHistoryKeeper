import 'dart:async';
import 'package:grinder/grinder.dart';

Future main(List<String> args) => grind(args);

@Task()
void test() {
  var testRunner = new TestRunner();
  testRunner.testAsync(runOptions: new RunOptions(workingDirectory: 'backend'));
  testRunner.testAsync(
      runOptions: new RunOptions(workingDirectory: 'frontend'));
}

@DefaultTask()
@Depends(get, test)
void build() {
  Pub.build(runOptions: new RunOptions(workingDirectory: 'frontend'));
}

@Task()
void get() {
  Pub.get();
  Pub.get(runOptions: new RunOptions(workingDirectory: 'shared'));

  Dart.run('build.dart',
      runOptions: new RunOptions(workingDirectory: 'shared'));

  Pub.get(runOptions: new RunOptions(workingDirectory: 'frontend'));
  Pub.get(runOptions: new RunOptions(workingDirectory: 'backend'));
}

@Task()
void upgrade() {
  Pub.upgrade();
  Pub.upgrade(runOptions: new RunOptions(workingDirectory: 'shared'));

  Dart.run('build.dart',
      runOptions: new RunOptions(workingDirectory: 'shared'));

  Pub.upgrade(runOptions: new RunOptions(workingDirectory: 'frontend'));
  Pub.upgrade(runOptions: new RunOptions(workingDirectory: 'backend'));
}

@Task()
void clean() => defaultClean();
