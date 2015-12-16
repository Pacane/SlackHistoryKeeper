import 'package:quiver/core.dart';
import 'package:redstone_mapper_mongo/metadata.dart';
import 'package:redstone_mapper/mapper.dart';

class Channel {
  @Id()
  String internalId;

  @Field()
  String id;
  @Field()
  String name;

  Channel();

  Channel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
  }

  bool operator ==(Channel o) => o is Channel && o.name == name && o.id == id;
  int get hashCode => hash2(id.hashCode, name.hashCode);

  String toString() => "$id : $name";
}

class User {
  @Id()
  String internalId;

  @Field()
  String id;
  @Field()
  String name;

  User();

  User.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
  }

  bool operator ==(User o) => o is User && o.name == name && o.id == id;
  int get hashCode => hash2(id.hashCode, name.hashCode);

  String toString() => "$id : $name";
}

class Attachment {
  @Id()
  String internalId;

  @Field()
  int id;
  @Field()
  String fromUrl;
  @Field()
  String imageUrl;

  Attachment();

  Attachment.fromJson(Map json) {
    id = json['id'];
    fromUrl = json['from_url'];
    imageUrl = json['image_url'];
  }
}

class Message {
  static const String type = 'message';

  @Id()
  String internalId;

  @Field()
  String id;
  @Field()
  String userId;
  @Field()
  String subtype;
  @Field()
  String timestamp;
  @Field()
  String text;
  @Field()
  String channelId;
  @Field()
  num score;

  @Field()
  List<Attachment> attachments;

  Message();

  Message.fromJson(Map json) {
    timestamp = json['ts'];
    userId = json['user'];
    text = json['text'];
    subtype = json['subtype'];

    if (json['attachments'] != null) {
      List<Map> jsonAttachments = json['attachments'];
      attachments =
          jsonAttachments.map((Map m) => new Attachment.fromJson(m)).toList();
    } else {
      attachments = [];
    }
  }

  String toString() {
    var timestampInMilliseconds = new DateTime.fromMillisecondsSinceEpoch(
        (double.parse(timestamp) * 1000).toInt());

    var parsedDateTime = timestampInMilliseconds;

    StringBuffer sb = new StringBuffer();

    if (attachments.isNotEmpty) {
      sb.write(":");
      attachments.forEach((Attachment a) => sb.write(" << ${a.fromUrl} >>"));
    }

    return '$parsedDateTime:$userId:$text$sb';
  }
}
