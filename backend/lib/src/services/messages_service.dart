import 'dart:async';

import 'package:slack_history_keeper_backend/src/message_repository.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'package:di/di.dart';

@Injectable()
class MessagesService {
  final MessageRepository messageRepository;

  MessagesService(this.messageRepository);

  Future<List<Message>> fetchMessages(
          String query, List<String> channelIds, List<String> userId) =>
      messageRepository.queryMessages(query,
          channelIds: channelIds, userIds: userId);
}
