library frontend.components.message;

import 'package:angular2/angular2.dart';

@Component(selector: 'message')
@View(templateUrl: 'message.html', directives: const [NgFor, NgIf])
class Message {
    Message() {
        
    }
}