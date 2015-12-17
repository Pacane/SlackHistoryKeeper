library frontend.services.my_service;

import 'package:angular2/angular2.dart';
import 'dart:async';
import 'package:http/browser_client.dart' as http;
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:convert';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:slack_history_keeper_frontend/services/query_parser.dart' as qp;
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';

const String apiUrl = 'http://localhost:8084/api';

@Injectable()
class SlackService extends Object with NameToId {
  final http.BrowserClient client = new http.BrowserClient();

  Map<String, User> _users = {};
  Map<String, Channel> _channels = {};

  SlackService() {
    bootstrapMapper();
  }

  List<Channel> getChannels() {
    return _channels.values;
  }

  List<User> getUsers() {
    return _users.values;
  }

  Channel getChannelfromId(String id) => _channels[id];

  User getUserFromId(String id) => _users[id];

  @override
  String channelNameToId(String channelName) {
    var channels = getChannels();
    var channel = channels.firstWhere((Channel c) => c.name == channelName,
        orElse: () => null);
    return channel?.id;
  }

  @override
  String userNameToId(String userName) {
    var users = getUsers();
    var user =
        users.firstWhere((User u) => u.name == userName, orElse: () => null);
    return user?.id;
  }

  Future<List<Message>> search(qp.Query searchQuery) async {
    List<String> params = [];
    appendParam(searchQuery.channelIds, params, "c");
    appendParam(searchQuery.userIds, params, "u");

    if (searchQuery.keywords != null) {
      params.add('q=${searchQuery.keywords}');
    }

    var result = await client.get('$apiUrl/messages?${params.join('&')}');

    List<Map> json = JSON.decode(result.body);

    var list = json.map((Map m) => decode(m, Message)).toList();
    return list;
  }

  void appendParam(
      List<String> values, List<String> params, String parameterName) {
    values.forEach((value) => params.add("$parameterName=$value"));
  }

  Future cacheData() async {
    _users = await fetchUsers();
    _channels = await fetchChannels();
  }

  Future<Map> fetchUsers() async {
    var result = await client.get('$apiUrl/users');

    List<Map> json = JSON.decode(result.body);

    Map association = {};

    json
        .map((Map m) => decode(m, User))
        .forEach((User u) => association[u.id] = u);

    return association;
  }

  Future<Map> fetchChannels() async {
    var result = await client.get('$apiUrl/channels');

    List<Map> json = JSON.decode(result.body);

    Map association = {};

    json
        .map((Map m) => decode(m, Channel))
        .forEach((Channel c) => association[c.id] = c);

    return association;
  }
}
