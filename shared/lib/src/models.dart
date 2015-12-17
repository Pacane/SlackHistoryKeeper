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
  @Field()
  String avatar;

  User();

  User.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    avatar = json['profile']['image_32'];
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

class Emoticon {
  @Field()
  String name;
  @Field()
  String url;

  Emoticon();
  Emoticon.data(this.name, this.url);
}

class SlackCache {
  Map<String, User> _users = {};
  Map<String, Channel> _channels = {};
  Map<String, Emoticon> _emoticons = {};

  List<Channel> getChannels() {
    return _channels.values.toList();
  }

  List<Emoticon> getEmoticons() {
    return _emoticons.values.toList();
  }

  List<User> getUsers() {
    return _users.values.toList();
  }

  Channel getChannelfromId(String id) => _channels[id];

  User getUserFromId(String id) => _users[id];

  Emoticon getEmoticonFromName(String name) => _emoticons[name];

  void set users(Map<String, User> users) {
    _users = users;
  }

  void set channels(Map<String, Channel> channels) {
    _channels = channels;
  }

  void set emoticons(Map<String, Emoticon> emoticons) {
    _emoticons = emoticons;
  }
}