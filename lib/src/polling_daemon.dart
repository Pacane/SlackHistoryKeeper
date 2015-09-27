import 'package:slack_history_keeper/src/message_repository.dart';
import 'package:di/di.dart';
import 'package:slack_history_keeper/src/mongo_db_pool.dart';
import 'package:slack_history_keeper/src/slack_connector/slack_connector.dart';
import 'package:slack_history_keeper/src/slack_connector/models.dart';
import 'dart:async';
import 'package:logging/logging.dart';

@Injectable()
class PollingDaemon {
  static final NUMBER_OF_SECONDS_TO_WAIT_BETWEEN_CHANNEL_POLLS = 2;

  /*
  If this is empty the daemon will poll all channels
   */
  final List<String> channelsToPoll = [];
  final MessageRepository messageRepository;
  final MongoDbPool mongoDbPool;
  final SlackConnector slackConnector;

  List<User> users = [];
  List<Channel> channels = [];

  PollingDaemon(this.messageRepository, this.mongoDbPool, this.slackConnector);

  filterChannelsToPoll() {
    if (channelsToPoll.isNotEmpty) {
      channels.retainWhere((Channel c) => channelsToPoll.contains(c.name));
    }
  }

  saveNewMessages(Channel c) async {
    Logger.root.log(Level.INFO, "polling for channel ${c.name}");
    Message lastMessage = await messageRepository.getLatestMessage(c.id);
    List<Message> messages = [];
    if (lastMessage == null) {
      messages = await slackConnector.fetchChannelHistory(c.id);
    } else {
      String lastTimeStampToFetch = lastMessage.timestamp;
      messages = await slackConnector.fetchChannelHistory(c.id,
          lastTimestamp: lastTimeStampToFetch);
    }

    messageRepository.insertMessages(messages);
  }

  /*
  This polls all specified channels for new messages via [channelsToPoll].
  This doesn't catch edit to messages (yet)
   */
  Future poll() async {
    users = await slackConnector.fetchUsers();
    channels = await slackConnector.fetchChannels();
    filterChannelsToPoll();

    int secondsToDelay = 1;
    channels.forEach((Channel c) async {
      new Future.delayed(new Duration(seconds: secondsToDelay),
          () async => await saveNewMessages(c));
      secondsToDelay += NUMBER_OF_SECONDS_TO_WAIT_BETWEEN_CHANNEL_POLLS;
    });
  }
}
