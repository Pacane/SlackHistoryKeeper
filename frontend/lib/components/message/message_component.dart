library frontend.components.message;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_frontend/services/message_parser.dart';

@Component(selector: 'message')
@View(
    templateUrl: 'message_component.html',
    directives: const [COMMON_DIRECTIVES],
    pipes: const [MessageParser])
class MessageComponent implements OnInit {
  @Input()
  Message message;
  User user;

  final SlackService slackService;

  MessageComponent(this.slackService);

  @override
  void ngOnInit() {
    user = slackService.getUserFromId(message.userId);
  }
}
