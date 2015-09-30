import 'dart:async';
import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_backend/slack_history_keeper.dart';

class ChannelsService {
  final SlackConnector slackConnector;

  ChannelsService(this.slackConnector);

  Future<List<Channel>> fetchChannelsFromSlackApi() =>
      slackConnector.fetchChannels();
}
