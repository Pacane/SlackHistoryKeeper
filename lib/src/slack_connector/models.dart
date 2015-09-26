import 'package:quiver/core.dart';

class Channel {
  String id;
  String name;

  Channel();

  Channel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
  }

  bool operator ==(o) => o is Channel && o.name == name && o.id == id;
  int get hashCode => hash2(id.hashCode, name.hashCode);

  String toString() => "$id : $name";
}

class User {
  String id;
  String name;

  User();

  User.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
  }

  bool operator ==(o) => o is User && o.name == name && o.id == id;
  int get hashCode => hash2(id.hashCode, name.hashCode);

  String toString() => "$id : $name";
}

class Attachment {
  int id;
  String from_url;
  String image_url;

  Attachment.fromJson(Map json) {
    id = json['id'];
    from_url = json['from_url'];
    image_url = json['image_url'];
  }
}

class Message {
  static const String TYPE = 'message';

  String id;
  String userId;
  String subtype;
  String timestamp;
  String text;
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
      attachments.forEach((Attachment a) => sb.write(" << ${a.from_url} >>"));
    }

    return '$parsedDateTime:$userId:$text$sb';
  }
}
