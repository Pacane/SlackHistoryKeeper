import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_backend/slack_history_keeper.dart';

class SlackConnector {
  Future<List<User>> fetchUsers() async {
    String url =
        'https://slack.com/api/users.list?token=$slackApiToken&pretty=1';

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
    List<Map> channelsJson = json['channels'];

    var channels =
        channelsJson.map((Map map) => new Channel.fromJson(map)).toList();

    return channels;
  }
}
