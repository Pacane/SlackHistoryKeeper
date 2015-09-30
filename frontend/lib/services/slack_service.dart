library frontend.services.my_service;

import 'package:angular2/angular2.dart';
import 'dart:async';
import 'package:http/browser_client.dart' as http;

@Injectable()
class SlackService {
  String apiUrl = 'http://localhost:8084/api';
  http.BrowserClient client = new http.BrowserClient();

  Future getChannels() async {
    var result = await client.get('$apiUrl/channels');
    print(result.body);
  }
}
