library slack_history_keeper_shared.src.models.message;

import 'package:dogma_convert/serialize.dart';
import 'package:slack_history_keeper_shared/convert.dart';

class Message {
  @Serialize.field('user')
  String user;

  @Serialize.field('subtype')
  String type;

  @Serialize.field('ts')
  String ts;

  @Serialize.field('text')
  String text;

  @Serialize.field('channelId')
  String channel;

  @Serialize.field('score')
  num score;

  @override
  String toString() {
    var timestampInMilliseconds = new DateTime.fromMillisecondsSinceEpoch(
        (double.parse(ts) * 1000).toInt());

    var parsedDateTime = timestampInMilliseconds;

    return '$parsedDateTime:$user:$text';
  }

  Map toJson() => new MessageEncoder().convert(this);
}
