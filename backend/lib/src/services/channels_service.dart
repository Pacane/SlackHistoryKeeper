library slack_history_keeper.channels_service;

import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_shared/slack_cache.dart';

class ChannelsService {
  final SlackCache slackCache;

  ChannelsService(this.slackCache);

  List<Channel> getChannels() => slackCache.getChannels();
}
