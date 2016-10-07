library slack_history_keeper_shared.src.models.attachment;

import 'package:dogma_convert/serialize.dart';

class Attachment {
  @Serialize.field('id')
  int id;
  @Serialize.field('from_url')
  String from_url;
  @Serialize.field('image_url')
  String image_url;
}
