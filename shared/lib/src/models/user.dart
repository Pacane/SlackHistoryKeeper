library slack_history_keeper_shared.src.models.user;

import 'package:quiver/core.dart';
import 'package:slack_history_keeper_shared/convert.dart';

class User {
  String id;
  String name;
  String avatar;

  @override
  bool operator ==(Object o) => o is User && o.name == name && o.id == id;
  @override
  int get hashCode => hash2(id.hashCode, name.hashCode);

  @override
  String toString() => "$id : $name";

  Map toJson() => new UserEncoder().convert(this);
}
