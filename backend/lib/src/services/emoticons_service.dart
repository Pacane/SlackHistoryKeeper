library slack_history_keeper.emoticons_service;

import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_shared/slack_cache.dart';

class EmoticonsService {
  final SlackCache slackCache;

  EmoticonsService(this.slackCache);

  List<Emoticon> fetchEmoticons() => slackCache.getEmoticons();
}
