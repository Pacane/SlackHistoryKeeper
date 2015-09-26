import 'package:slack_history_keeper/src/message_repository.dart';
import 'package:di/di.dart';

@Injectable()
class PollingDaemon {
  List<String> channelsToPoll = ['general'];

  MessageRepository messageRepository;

  PollingDaemon(this.messageRepository);

  poll() {
    print("polling!");
  }
}
