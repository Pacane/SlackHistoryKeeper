library frontend.components.home;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';

@Component(selector: 'home', viewBindings: const [SlackService])
@View(
    templateUrl: 'home.html',
    directives: const [CORE_DIRECTIVES, FORM_DIRECTIVES])
class Home implements OnInit {
  SlackService service;

  onInit() async {
    await service.getChannels();
  }

  Home(this.service);
}