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

  Future<List<Channel>> getChannels() async {
    bootstrapMapper();
    var result = await client.get('$apiUrl/channels');

    List<Map> json = JSON.decode(result.body);

    return json.map((Map m) => decode(m, Channel)).toList();
  }

  Future<String> channelNameToId(String channelName) async {
    var channels = await getChannels();
    return channels
        .firstWhere((Channel c) => c.name == channelName, orElse: () => null)
        ?.id;
  }

  Future<List<Message>> search(qp.Query searchQuery) async {
    bootstrapMapper();

    List<String> params = [];
    for (var param in searchQuery.channelIds) {
      params.add('c=$param');
    }

    if (searchQuery.keywords != null) {
      params.add('q=${searchQuery.keywords}');
    }

    var result = await client.get('$apiUrl/messages?${params.join('&')}');

    List<Map> json = JSON.decode(result.body);

    return json.map((Map m) => decode(m, Message)).toList();
  }
}
