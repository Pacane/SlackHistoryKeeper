library frontend.components.message;

import 'package:angular2/angular2.dart';
import 'package:intl/intl.dart';
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
  Channel channel;
  String formattedDate;

  final SlackService slackService;

  MessageComponent(this.slackService);

  @override
  void ngOnInit() {
    user = slackService.getUserFromId(message.user);
    channel = slackService.getChannelfromId(message.channel);
    var formatter = new DateFormat('yyyy-MM-dd H:mm');
    formattedDate = formatter.format(new DateTime.fromMillisecondsSinceEpoch(
        num.parse(message.ts.split(".")[0]) * 1000));
  }
}
