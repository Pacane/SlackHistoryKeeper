library frontend.services.my_service;

import 'package:angular2/angular2.dart';
import 'dart:async';
import 'package:http/browser_client.dart' as http;
import 'package:http/http.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:convert';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';
import 'package:slack_history_keeper_frontend/services/query_parser.dart' as qp;

const String apiUrl = 'http://localhost:8084/api';

@Injectable()
class SlackService extends Object with NameToId {
  final http.BrowserClient client = new http.BrowserClient();

  CachedCollection<User> _users;
  CachedCollection<Channel> _channels;

  SlackService() {
    bootstrapMapper();
    _users = new CachedCollection(client, 'users');
    _channels = new CachedCollection(client, 'channels');
  }

  Future<List<Channel>> getChannels() async {
    return _channels.data;
  }

  Future<List<User>> getUsers() async {
    return _users.data;
  }

  Future<String> channelNameToId(String channelName) async {
    var channels = await getChannels();
    var channel = channels.firstWhere((Channel c) => c.name == channelName,
        orElse: () => null);
    return channel?.id;
  }

  Future<String> userNameToId(String userName) async {
    var users = await getUsers();
    var user =
        users.firstWhere((User u) => u.name == userName, orElse: () => null);
    return user?.id;
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

class CachedCollection<E> {
  static const Duration expirationDuration = const Duration(minutes: 10);

  final String endPoint;
  final BaseClient client;

  List<E> _data;
  DateTime _fetchDate = new DateTime.fromMillisecondsSinceEpoch(0);
  Future _currentFuture;

  CachedCollection(this.client, this.endPoint);

  Future<List<E>> get data async {
    if (isExpired()) {
      if (_currentFuture != null)
        await _currentFuture;
      else {
        _currentFuture = forceFetch();
        await _currentFuture;
        _currentFuture = null;
      }
    }

    return _data;
  }

  bool isExpired() {
    var now = new DateTime.now();
    return _fetchDate.isBefore(now.subtract(expirationDuration));
  }

  Future forceFetch() async {
    var result = await client.get('$apiUrl/$endPoint');

    List<Map> json = JSON.decode(result.body);

    _data = json.map((Map m) => decode(m, User)).toList();
    _fetchDate = new DateTime.now();
  }
}
