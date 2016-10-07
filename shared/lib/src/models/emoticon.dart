library slack_history_keeper_shared.src.models.emoticon;

import 'package:dogma_convert/serialize.dart';
import 'package:slack_history_keeper_shared/convert.dart';

class Emoticon {
  String name;
  String url;

  Emoticon();

  Emoticon.data(this.name, this.url);

  Map toJson() => new EmoticonEncoder().convert(this);
}
