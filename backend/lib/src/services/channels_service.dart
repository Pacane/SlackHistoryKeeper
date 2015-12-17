import 'package:slack_history_keeper_shared/models.dart';

class ChannelsService {
  final SlackCache slackCache;

  ChannelsService(this.slackCache);

  List<Channel> getChannels() => slackCache.getChannels();
}
