import 'package:slack_history_keeper/src/message_repository.dart';

class PollingDaemon {
  List<String> channelsToPoll = ['general'];

  MessageRepository messageRepository;

  PollingDaemon(this.messageRepository);

  poll() {
  }
}
