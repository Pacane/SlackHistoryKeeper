library frontend.components.message;

import 'package:angular2/angular2.dart';
import 'package:slack_history_keeper_shared/models.dart' as models;

@Component(selector: 'message')
@View(templateUrl: 'message.html')
class Message {
  @Input()
  models.Message message;

  Message();
}
