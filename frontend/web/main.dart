import 'package:angular2/bootstrap.dart';
import 'package:angular2/router.dart';
import 'package:angular2/angular2.dart';

import 'package:slack_history_keeper_frontend/app.dart';
import 'dart:async';

Future<ComponentRef> main() => bootstrap(App, [
  ROUTER_BINDINGS,
  bind(APP_BASE_HREF).toValue('/'),
  bind(LocationStrategy).toClass(HashLocationStrategy)
]);
