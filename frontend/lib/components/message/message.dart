library frontend.components.message;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:async';

@Component(selector: 'message')
@View(templateUrl: 'message.html', directives: const [CORE_DIRECTIVES])
class MessageComponent implements OnInit {
  @Input()
  Message message;
  User user;

  StreamSubscription subscription;

  final SlackService slackService;

  MessageComponent(this.slackService);

  void ngOnInit() {
    user = slackService.getUserFromId(message.userId);
    print("The corresponding user is $user");
  }
}
