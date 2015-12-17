library frontend.components.message;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_shared/models.dart';

@Component(selector: 'message')
@View(templateUrl: 'message.html')
class MessageComponent {
  @Input()
  Message message;
}
