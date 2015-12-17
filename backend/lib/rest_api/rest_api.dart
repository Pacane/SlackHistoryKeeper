library rest_api;

import 'dart:async';

import 'package:di/di.dart';
import 'package:redstone/redstone.dart' as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:shelf/shelf.dart';
import 'package:slack_history_keeper_backend/slack_history_keeper.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_backend/src/services/users_service.dart';

part 'groups/channels_group.dart';
part 'groups/messages_group.dart';
part 'groups/users_group.dart';
part 'interceptors/cors_interceptor.dart';

const String baseUrl = '/api';
const int port = 8084;

Future startApiServer() async {
  app.addPlugin(getMapperPlugin());
  app.addModule(repositoryModule);
  app.addModule(databaseModule);
  app.addModule(new Module()
    ..bind(SlackConnector)
    ..bind(ChannelsService)
    ..bind(UsersService)
    ..bind(MessagesService)
    ..bind(SlackCache, toValue: injector.get(SlackCache)));

  app.start(port: port);
}
