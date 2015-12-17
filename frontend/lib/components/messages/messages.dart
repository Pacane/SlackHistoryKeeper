library frontend.components.messages;

import 'package:angular2/angular2.dart';
import 'package:event_bus/event_bus.dart';
import 'package:slack_history_keeper_shared/models.dart' as models;
import 'package:slack_history_keeper_frontend/components/message/message.dart';

@Component(selector: 'messages')
@View(templateUrl: 'messages.html', directives: const [NgFor, NgIf, Message])
class Messages {
  final EventBus eventBus;
  List<models.Message> data;

  Messages(this.eventBus) {
    eventBus.on(models.SuperEvent).listen((models.SuperEvent event) {
      data = event.data;
    });
  }
}
