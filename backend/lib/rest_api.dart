library rest_api;

import 'dart:async';

import 'dart:io';
import 'package:di/di.dart';
import 'package:redstone/redstone.dart' as app;

import 'package:slack_history_keeper_shared/slack_cache.dart';

import 'slack_history_keeper.dart';
import 'slack_connector.dart';

import 'package:shelf/shelf.dart' as shelf;

part 'src/rest_api/interceptors/cors_interceptor.dart';

part 'src/rest_api/groups/channels_group.dart';
part 'src/rest_api/groups/emoticons_group.dart';
part 'src/rest_api/groups/messages_group.dart';
part 'src/rest_api/groups/users_group.dart';

const String baseUrl = '/api';
const int port = 8084;

Future startApiServer() async {
  await init();

  app.start(port: port);
}

init() async {
  app.addModule(repositoryModule);
  app.addModule(databaseModule);
  app.addModule(new Module()
    ..bind(SlackConnector)
    ..bind(ChannelsService)
    ..bind(UsersService)
    ..bind(MessagesService)
    ..bind(EmoticonsService)
    ..bind(SlackCache, toValue: injector.get(SlackCache)));

  await app.redstoneSetUp();
}

serveRequest(HttpRequest request) {
  app.handleRequest(request);
}
