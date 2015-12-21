library slack_history_keeper_shared.src.models.channel;

import 'package:quiver/core.dart';
import 'package:dogma_convert/serialize.dart';
import 'package:slack_history_keeper_shared/convert.dart';

class Channel {
  @Serialize.field('id')
  String id;

  @Serialize.field('name')
  String name;

  bool operator ==(Channel o) => o is Channel && o.name == name && o.id == id;
  int get hashCode => hash2(id.hashCode, name.hashCode);

  String toString() => "$id : $name";

  Map toJson() => new ChannelEncoder().convert(this);
}
