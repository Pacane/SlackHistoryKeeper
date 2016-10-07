library slack_history_keeper_shared.src.models.channel;

import 'package:quiver/core.dart';
import 'package:dogma_convert/serialize.dart';
import 'package:slack_history_keeper_shared/convert.dart';

class Channel {
  String id;
  String name;

  @override
  bool operator ==(Object o) => o is Channel && o.name == name && o.id == id;

  @override
  int get hashCode => hash2(id.hashCode, name.hashCode);

  @override
  String toString() => "$id : $name";

  Map toJson() => new ChannelEncoder().convert(this);
}
