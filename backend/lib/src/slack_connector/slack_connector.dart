library slack_history_keeper.slack_connector;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_shared/slack_cache.dart';
import 'package:slack_history_keeper_shared/convert.dart';
import '../../slack_history_keeper.dart';

class SlackConnector {
  final SlackCache cache;
  final UserDecoder userDecoder = new UserDecoder();
  final MessageDecoder messageDecoder = new MessageDecoder();
  final ChannelDecoder channelDecoder = new ChannelDecoder();

  SlackConnector(this.cache);

  Future<List<User>> fetchUsers() async {
    String url =
        'https://slack.com/api/users.list?token=$slackApiToken&pretty=1';

    var response = await http.get(url);
    Map json = JSON.decode(response.body);
    List<Map> membersJson = json['members'] as List<Map>;
    var members = membersJson.map((Map map) {
      var user = userDecoder.convert(map);
      user.avatar = map['profile']['image_32'];
      return user;
    }).toList();

    Map<String, User> usersCache = {};
    members.forEach((User u) => usersCache[u.id] = u);
    cache.users = usersCache;

    return members;
  }

  Future<Map> _fetchChannelHistory(String channelId,
      {String lastMessageTimestamp: '0'}) async {
    String oldestMessageParameter =
        lastMessageTimestamp != '0' ? "&oldest=$lastMessageTimestamp" : "";

    String url =
        'https://slack.com/api/channels.history?token=$slackApiToken&channel=$channelId&pretty=1$oldestMessageParameter';

    var response = await http.get(url);
    Map json = JSON.decode(response.body);
    return json;
  }

  List<Message> _extractMessages(Map json) {
    List<Map> jsonMessages = json['messages'] as List<Map>;
    List<Message> messages = [];

    if (jsonMessages != null) {
      messages =
          jsonMessages.map((Map map) => messageDecoder.convert(map)).toList();
    }

    return messages;
  }

  Future<List<Message>> fetchChannelHistory(String channelId,
      {String lastTimestamp: '0'}) async {
    var json = await _fetchChannelHistory(channelId,
        lastMessageTimestamp: lastTimestamp);
    List<Message> messages = _extractMessages(json);

    bool isOk = json['ok'];

    checkIfMessageIsOk(isOk, json);

    while (json['has_more']) {
      String lastMessageTimestamp = messages.first.timestamp;
      json = await _fetchChannelHistory(channelId,
          lastMessageTimestamp: lastMessageTimestamp);

      checkIfMessageIsOk(isOk, json);

      List<Message> remainingMessages = _extractMessages(json);
      messages.addAll(remainingMessages);
    }

    messages.forEach((Message m) => m.channelId = channelId);

    return messages;
  }

  void checkIfMessageIsOk(bool isOk, Map json) {
    if (!isOk) {
      throw new Exception("Couldn't fetch messages. ${json['error']}");
    }
  }

  Future<List<Channel>> fetchChannels({bool excludeArchived: false}) async {
    String excludeArchivedParameter = "";
    if (excludeArchived) {
      excludeArchivedParameter = "&exclude_archived=1";
    }

    var url =
        'https://slack.com/api/channels.list?token=$slackApiToken&pretty=1$excludeArchivedParameter';

    var response = await http.get(url);

    Map json = JSON.decode(response.body);
    List<Map> channelsJson = json['channels'] as List<Map>;

    var channels =
        channelsJson.map((Map map) => channelDecoder.convert(map)).toList();

    Map<String, Channel> channelsCache = {};
    channels.forEach((Channel c) => channelsCache[c.id] = c);
    cache.channels = channelsCache;

    return channels;
  }

  Future<Map<String, Emoticon>> fetchEmoticons() async {
    var url = 'https://slack.com/api/emoji.list?token=$slackApiToken&pretty=1';
    var response = await http.get(url);

    Map json = JSON.decode(response.body);
    Map<String, Emoticon> emoticons = {};
    json['emoji'].forEach(
        (String k, String v) => emoticons[k] = new Emoticon.data(k, v));

    cache.emoticons = emoticons;

    return emoticons;
  }
}
