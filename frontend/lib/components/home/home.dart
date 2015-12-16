library frontend.components.home;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:async';

@Component(
    selector: 'home',
    viewProviders: const [SlackService])
@View(
    templateUrl: 'home.html',
    directives: const [CORE_DIRECTIVES, FORM_DIRECTIVES])
class Home implements OnInit {
  SlackService service;
  List<Channel> channels = [];
  Channel channel;

  Home(this.service);

  @override
  Future ngOnInit() async {
    channels = await service.getChannels();

    channel = channels.first;
  }
}
