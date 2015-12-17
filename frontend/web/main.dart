import 'package:angular2/bootstrap.dart';
import 'package:angular2/router.dart';
import 'package:angular2/angular2.dart';

import 'package:event_bus/event_bus.dart';
import 'package:slack_history_keeper_frontend/app.dart';
import 'dart:async';
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';

Future<ComponentRef> main() => bootstrap(App, [
  ROUTER_BINDINGS,
  bind(APP_BASE_HREF).toValue('/'),
  bind(LocationStrategy).toClass(HashLocationStrategy),
  bind(NameToId).toClass(SlackService),
  bind(EventBus).toValue(new EventBus())
]);
