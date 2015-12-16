library frontend.components.search;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:async';

@Component(
    selector: 'search',
    viewProviders: const [SlackService])
@View(
    templateUrl: 'search.html',
    directives: const [CORE_DIRECTIVES, FORM_DIRECTIVES])
class Search implements OnInit {
  SlackService service;
  List<Channel> channels = [];
  Channel channel;

  Search(this.service);

  @override
  Future ngOnInit() async {
    channels = await service.getChannels();

    channel = channels.first;
  }
}
