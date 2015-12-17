library frontend.components.search;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:async';
import 'package:slack_history_keeper_frontend/services/query_parser.dart';
import 'package:slack_history_keeper_frontend/components/messages/messages.dart';
import 'package:event_bus/event_bus.dart';

@Component(
    selector: 'search',
    viewProviders: const [SlackService, QueryParser, Messages])
@View(
    templateUrl: 'search.html',
    directives: const [CORE_DIRECTIVES, FORM_DIRECTIVES, Messages])
class Search implements OnInit {
  final SlackService service;
  final QueryParser queryParser;
  final EventBus eventBus;
  List<Channel> channels = [];
  Channel channel;
  String queryText;

  Search(this.service, this.queryParser, this.eventBus);

  @override
  Future ngOnInit() async {
    channels = await service.getChannels();

    channel = channels.first;
  }

  Future onSubmit() async {
    var query = await queryParser.parse(queryText);

    List<Message> data = await service.search(query);

    eventBus.fire(new SuperEvent(data));
  }
}
