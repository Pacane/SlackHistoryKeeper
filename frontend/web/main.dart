import 'package:angular2/bootstrap.dart';
import 'package:angular2/router.dart';
import 'package:angular2/angular2.dart';

import 'dart:async';

import 'package:slack_history_keeper_frontend/app.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';
import 'package:slack_history_keeper_frontend/services/query_parser.dart';

Future<ComponentRef> main() => bootstrap(App, [
      ROUTER_BINDINGS,
      provide(APP_BASE_HREF, useValue: '/'),
      provide(LocationStrategy, useClass: HashLocationStrategy),
      SlackService,
      provide(NameToId, useExisting: SlackService),
      QueryParser
    ]);
