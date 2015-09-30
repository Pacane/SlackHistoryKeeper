library rest_api;

import 'package:redstone/redstone.dart' as app;
import 'package:di/di.dart';
import 'package:redstone_mapper/plugin.dart';
import 'dart:async';
import 'package:slack_history_keeper_backend/slack_history_keeper.dart';
import 'package:slack_history_keeper_shared/models.dart';

part 'groups/channels_group.dart';
part 'interceptors/cors_interceptor.dart';

const String baseUrl = '/api';
const int port = 8084;

startApiServer() async {
  app.addPlugin(getMapperPlugin());
  app.addModule(repositoryModule);
  app.addModule(databaseModule);
  app.addModule(new Module()..bind(SlackConnector)..bind(ChannelsService));

  app.start(port: port);
}
