library frontend.components.message;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'dart:async';

@Component(selector: 'message')
@View(templateUrl: 'message.html')
class MessageComponent implements OnInit {
  final SlackService slackService;

  @Input()
  Message message;
  User user;

  MessageComponent(this.slackService);

  Future ngOnInit() async {
    var users = await slackService.getUsers();
    user = users.firstWhere((u) => u.id == message.userId);
  }
}
