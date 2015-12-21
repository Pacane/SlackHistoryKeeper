library frontend.components.messages;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_frontend/components/message/message_component.dart';
import 'package:slack_history_keeper_shared/models.dart';

@Component(selector: 'messages')
@View(
    templateUrl: 'messages_component.html',
    directives: const [NgFor, NgIf, MessageComponent])
class MessagesComponent {
  @Input()
  List<Message> messages;
}
