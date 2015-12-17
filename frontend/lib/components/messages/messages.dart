library frontend.components.messages;

import 'package:angular2/angular2.dart';

@Component(selector: 'messages')
@View(templateUrl: 'messages.html', directives: const [NgFor, NgIf])
class Messages {
    static List<String> messages;
    get data => Messages.messages;
    Messages() {}

    static showMessages(data) {
        messages = data;
    }
}