library slack_history_keeper_shared.src.models.user;

import 'package:dogma_convert/serialize.dart';
import 'package:quiver/core.dart';

class User {
  @Serialize.field('id')
  String id;
  @Serialize.field('name')
  String name;
  @Serialize.function('profile', encode: 'encodeUserAvatar', decode: 'decodeUserAvatar')
  String avatar;

  bool operator ==(User o) => o is User && o.name == name && o.id == id;
  int get hashCode => hash2(id.hashCode, name.hashCode);

  String toString() => "$id : $name";
}
