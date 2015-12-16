library frontend.services.my_service;

import 'package:angular2/angular2.dart';
import 'dart:async';
import 'package:http/browser_client.dart' as http;
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:convert';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';
import 'package:slack_history_keeper_frontend/services/query_parser.dart' as qp;

@Injectable()
class SlackService extends Object with NameToId {
  String apiUrl = 'http://localhost:8084/api';
  http.BrowserClient client = new http.BrowserClient();

  SlackService() {
    bootstrapMapper();
  }

  Future<List<Channel>> getChannels() async {
    var result = await client.get('$apiUrl/channels');

    List<Map> json = JSON.decode(result.body);

    return json.map((Map m) => decode(m, Channel)).toList();
  }

  Future<List<User>> getUsers() async {
    var result = await client.get('$apiUrl/users');

    List<Map> json = JSON.decode(result.body);

    return json.map((Map m) => decode(m, User)).toList();
  }

  Future<String> channelNameToId(String channelName) async {
    var channels = await getChannels();
    var channel = channels.firstWhere((Channel c) => c.name == channelName,
        orElse: () => null);
    return channel == null ? null : channel.id;
  }

  Future<String> userNameToId(String userName) async {
    var users = await getUsers();
    var user =
        users.firstWhere((User u) => u.name == userName, orElse: () => null);
    return user == null ? null : user.id;
  }

  Future<List<Message>> search(qp.Query searchQuery) async {
    bootstrapMapper();

    List<String> params = [];
    appendParam(searchQuery.channelIds, params, "c");
    appendParam(searchQuery.userIds, params, "u");

    if (searchQuery.keywords != null) {
      params.add('q=${searchQuery.keywords}');
    }

    var result = await client.get('$apiUrl/messages?${params.join('&')}');

    List<Map> json = JSON.decode(result.body);

    return json.map((Map m) => decode(m, Message)).toList();
  }

  void appendParam(
      List<String> values, List<String> params, String parameterName) {
    values.forEach((value) => params.add("$parameterName=$value"));
  }
}
