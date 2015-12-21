library frontend.services.my_service;

import 'package:angular2/angular2.dart';
import 'dart:async';
import 'package:http/browser_client.dart' as http;
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:convert';
import 'package:slack_history_keeper_frontend/services/query_parser.dart' as qp;
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';
import 'package:event_bus/event_bus.dart';
import 'package:slack_history_keeper_frontend/events/slack_data_loaded_event.dart';
import 'package:slack_history_keeper_shared/slack_cache.dart';
import 'package:slack_history_keeper_shared/convert.dart';

const String apiUrl = 'http://localhost:8084/api';

@Injectable()
class SlackService extends Object with NameToId {
  final http.BrowserClient client = new http.BrowserClient();
  final SlackCache cache = new SlackCache();
  final EventBus eventBus;
  final UserDecoder userDecoder;
  final ChannelDecoder channelDecoder;
  final EmoticonDecoder emoticonDecoder;

  Timer cacheTimer;

  SlackService(this.eventBus)
      : userDecoder = new UserDecoder(),
        emoticonDecoder = new EmoticonDecoder(),
        channelDecoder = new ChannelDecoder() {
    refreshCache(true);
    cacheTimer = new Timer.periodic(
        new Duration(minutes: 5), (t) => refreshCache(false));
  }

  @override
  String channelNameToId(String channelName) {
    var channels = cache.getChannels();
    var channel = channels.firstWhere((Channel c) => c.name == channelName,
        orElse: () => null);
    return channel?.id;
  }

  @override
  String userNameToId(String userName) {
    var users = cache.getUsers();
    var user =
        users.firstWhere((User u) => u.name == userName, orElse: () => null);
    return user?.id;
  }

  Channel getChannelfromId(String id) => cache.getChannelfromId(id);

  User getUserFromId(String id) => cache.getUserFromId(id);

  Emoticon getEmoticonFromName(String name) => cache.getEmoticonFromName(name);

  Future<List<Message>> search(qp.Query searchQuery) async {
    List<String> params = [];
    appendParam(searchQuery.channelIds, params, "c");
    appendParam(searchQuery.userIds, params, "u");

    if (searchQuery.keywords != null) {
      params.add('q=${searchQuery.keywords}');
    }

    var result = await client.get('$apiUrl/messages?${params.join('&')}');

    var json = JSON.decode(result.body) as List<Map>;

    var messageDecoder = new MessageDecoder();
    var messages = json.map((s) => messageDecoder.convert(s)).toList();

    return messages;
  }

  void appendParam(
      List<String> values, List<String> params, String parameterName) {
    values.forEach((value) => params.add("$parameterName=$value"));
  }

  Future refreshCache(bool firstLoad) async {
    cache.users = await fetchUsers();
    cache.channels = await fetchChannels();
    cache.emoticons = await fetchEmoticons();

    if (firstLoad) {
      eventBus.fire(new SlackDataLoadedEvent());
    }
  }

  Future<Map<String, User>> fetchUsers() async {
    var result = await client.get('$apiUrl/users');

    var json = JSON.decode(result.body) as List<Map>;;

    var association = <String, User>{};

    json
        .map((Map m) => userDecoder.convert(m))
        .forEach((User u) => association[u.id] = u);

    return association;
  }

  Future<Map<String, Channel>> fetchChannels() async {
    var result = await client.get('$apiUrl/channels');

    var json = JSON.decode(result.body) as List<Map>;

    var association = <String, Channel> {};

    json
        .map((Map m) => channelDecoder.convert(m))
        .forEach((Channel c) => association[c.id] = c);

    return association;
  }

  Future<Map<String, Emoticon>> fetchEmoticons() async {
    var result = await client.get('$apiUrl/emoticons');

    var json = JSON.decode(result.body) as List<Map>;

    var association = <String, Emoticon>{};

    json
        .map((Map m) => emoticonDecoder.convert(m))
        .forEach((Emoticon e) => association[e.name] = e);

    return association;
  }
}
