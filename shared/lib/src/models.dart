import 'package:quiver/core.dart';
import 'dart:convert';

class Channel {
  String id;
  String name;

  Channel();

  Channel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
  }

  Map toJson() {
    Map json = {};
    json['id'] = id;
    json['name'] = name;

    return json;
  }

  bool operator ==(Channel o) => o is Channel && o.name == name && o.id == id;
  int get hashCode => hash2(id.hashCode, name.hashCode);

  String toString() => "$id : $name";
}

class User {
  String id;
  String name;
  String avatar;

  User();

  User.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  User.fromSlackJson(Map json) {
    id = json['id'];
    name = json['name'];
    avatar = json['profile']['image_32'];
  }

  Map toJson() {
    Map json = {};
    json['id'] = id;
    json['name'] = name;
    json['avatar'] = avatar;

    return json;
  }

  bool operator ==(User o) => o is User && o.name == name && o.id == id;
  int get hashCode => hash2(id.hashCode, name.hashCode);

  String toString() => "$id : $name";
}

class Attachment {
  int id;
  String fromUrl;
  String imageUrl;

  Attachment();

  Attachment.fromJson(Map json) {
    id = json['id'];
    fromUrl = json['from_url'];
    imageUrl = json['image_url'];
  }

  Map toJson() {
    Map json = {};
    json['id'] = id;
    json['fromUrl'] = fromUrl;
    json['imageUrl'] = imageUrl;

    return json;
  }
}

class Message {
  static const String type = 'message';

  String userId;
  String subtype;
  String timestamp;
  String text;
  String channelId;
  num score;

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

  Map toJson() {
    Map json = {};
    json['user'] = userId;
    json['text'] = text;
    json['subtype'] = subtype;

    json['attachments'] = JSON.encode(attachments);

    return json;
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
  String name;
  String url;

  Emoticon();
  Emoticon.data(this.name, this.url);

  Emoticon.fromJson(Map json) {
    name = json['name'];
    url = json['url'];
  }

  Map toJson() {
    Map json = {};
    json['name'] = name;
    json['url'] = url;

    return json;
  }
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
