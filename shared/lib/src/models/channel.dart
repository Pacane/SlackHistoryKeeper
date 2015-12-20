library slack_history_keeper_shared.src.models.channel;

import 'package:quiver/core.dart';

class Channel {
  String id;
  String name;

  bool operator ==(Channel o) => o is Channel && o.name == name && o.id == id;
  int get hashCode => hash2(id.hashCode, name.hashCode);

  String toString() => "$id : $name";
}
