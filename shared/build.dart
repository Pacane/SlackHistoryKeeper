import 'dart:async';
import 'package:dogma_codegen/build.dart';

Future<Null> main(List<String> args) async {
  await build(args, unmodifiable: false);
}
