library frontend.components.search;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:async';
import 'package:slack_history_keeper_frontend/services/query_parser.dart';
import 'package:slack_history_keeper_frontend/components/messages/messages.dart';

@Component(
    selector: 'search',
    viewProviders: const [SlackService, QueryParser, Messages])
@View(
    templateUrl: 'search.html',
    directives: const [CORE_DIRECTIVES, FORM_DIRECTIVES, Messages])
class Search implements OnInit {
  final SlackService service;
  final QueryParser queryParser;
  List<Channel> channels = [];
  Channel channel;
  String queryText;
  List<Message> messages;

  Search(this.service, this.queryParser);

  @override
  Future ngOnInit() async {
    channels = await service.getChannels();

    channel = channels.first;
  }

  Future onSubmit() async {
    var query = await queryParser.parse(queryText);

    messages = await service.search(query);

    for(var message in messages) {
      print(message);
    }
  }
}
