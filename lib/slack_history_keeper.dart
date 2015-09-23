// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

/// The slack_history_keeper library.
library slack_history_keeper;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quiver/core.dart';

String slackApiToken;

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

Future<List<User>> fetchUsers() async {
  String url = 'https://slack.com/api/users.list?token=$slackApiToken&pretty=1';

  var response = await http.get(url);
  Map json = JSON.decode(response.body);
  List<Map> membersJson = json['members'];
  var members = membersJson.map((Map map) => new User.fromJson(map)).toList();

  return members;
}

Future<Map> _fetchChannelHistory(String channelId,
    {String lastMessageTimestamp: '0'}) async {
  String oldestMessageParameter =
      lastMessageTimestamp != 0 ? "&oldest=$lastMessageTimestamp" : "";

  String url =
      'https://slack.com/api/channels.history?token=$slackApiToken&channel=$channelId&pretty=1$oldestMessageParameter';

  var response = await http.get(url);
  Map json = JSON.decode(response.body);
  return json;
}

List<Message> _extractMessages(Map json) {
  List<Map> jsonMessages = json['messages'];

  List<Message> messages = [];

  if (jsonMessages != null) {
    messages =
        jsonMessages.map((Map map) => new Message.fromJson(map)).toList();
  }

  return messages;
}

Future<List<Message>> fetchChannelHistory(String channelId,
    {String lastTimestamp: '0'}) async {
  var json = await _fetchChannelHistory(channelId,
      lastMessageTimestamp: lastTimestamp);
  List<Message> messages = _extractMessages(json);

  while (json['has_more']) {
    String lastMessageTimestamp = messages.first.timestamp;
    json = await _fetchChannelHistory(channelId,
        lastMessageTimestamp: lastMessageTimestamp);
    List<Message> remainingMessages = _extractMessages(json);
    messages.addAll(remainingMessages);
  }

  return messages;
}

Future<List<Channel>> fetchChannels() async {
  var url = 'https://slack.com/api/channels.list?token=$slackApiToken&pretty=1';
  var response = await http.get(url);

  Map json = JSON.decode(response.body);
  List<Map> channelsJson = json['channels'];

  var channels =
      channelsJson.map((Map map) => new Channel.fromJson(map)).toList();

  return channels;
}
