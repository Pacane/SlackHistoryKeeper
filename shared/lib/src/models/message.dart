library slack_history_keeper_shared.src.models.message;

import 'package:dogma_convert/serialize.dart';
import 'package:slack_history_keeper_shared/convert.dart';

class Message {
  static const String type = 'message';

  @Serialize.field('user')
  String userId;

  @Serialize.field('subtype')
  String subtype;

  @Serialize.field('ts')
  String timestamp;

  @Serialize.field('text')
  String text;

  @Serialize.field('channelId')
  String channelId;

  @Serialize.field('score')
  num score;

  @override
  String toString() {
    var timestampInMilliseconds = new DateTime.fromMillisecondsSinceEpoch(
        (double.parse(timestamp) * 1000).toInt());

    var parsedDateTime = timestampInMilliseconds;

    return '$parsedDateTime:$userId:$text';
  }

  Map toJson() => new MessageEncoder().convert(this);
}
