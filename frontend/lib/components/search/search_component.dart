library frontend.components.search;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:async';
import 'package:slack_history_keeper_frontend/services/query_parser.dart';
import 'package:slack_history_keeper_frontend/components/messages/messages_component.dart';

@Component(
    selector: 'search')
@View(
    templateUrl: 'search_component.html',
    directives: const [CORE_DIRECTIVES, FORM_DIRECTIVES, MessagesComponent])
class SearchComponent {
  final SlackService service;
  final QueryParser queryParser;

  List<Channel> channels = [];
  List<Message> messages = [];
  String queryText;

  SearchComponent(this.service, this.queryParser);

  Future onSubmit() async {
    var query = await queryParser.parse(queryText);
    messages = await service.search(query);
    messages = messages.reversed;
  }
}
