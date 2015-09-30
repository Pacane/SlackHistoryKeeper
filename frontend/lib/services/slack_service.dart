library frontend.services.my_service;

import 'package:angular2/angular2.dart';
import 'dart:async';
import 'package:http/browser_client.dart' as http;
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:convert';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';

@Injectable()
class SlackService {
  String apiUrl = 'http://localhost:8084/api';
  http.BrowserClient client = new http.BrowserClient();

  Future<List<Channel>> getChannels() async {
    bootstrapMapper();
    var result = await client.get('$apiUrl/channels');
    List<Map> json = JSON.decode(result.body);
    print(json);
    return json.map((Map m) => decode(m, Channel)).toList();
  }
}
