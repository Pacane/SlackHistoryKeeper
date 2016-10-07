import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:event_bus/event_bus.dart';
import 'package:slack_history_keeper_frontend/app.dart';
import 'package:slack_history_keeper_frontend/emojis/emojis.dart';
import 'package:slack_history_keeper_frontend/services/message_parser.dart';
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';
import 'package:slack_history_keeper_frontend/services/query_parser.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';

Future<ComponentRef> main() async {
  await Emojis.init();
  return bootstrap(
      App,
      [
        [
          ROUTER_BINDINGS,
          provide(APP_BASE_HREF, useValue: '/'),
          provide(LocationStrategy, useClass: HashLocationStrategy),
          SlackService,
          provide(NameToId, useExisting: SlackService),
          QueryParser,
          provide(EventBus, useValue: new EventBus())
        ],
        parserBindings
      ].expand((i) => i).toList());
}
