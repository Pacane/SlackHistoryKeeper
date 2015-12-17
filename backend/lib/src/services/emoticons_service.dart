import 'package:slack_history_keeper_shared/models.dart';

class EmoticonsService {
  final SlackCache slackCache;

  EmoticonsService(this.slackCache);

  List<Emoticon> fetchEmoticons() =>
      slackCache.getEmoticons();
}
