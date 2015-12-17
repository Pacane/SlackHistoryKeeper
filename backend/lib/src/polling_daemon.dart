import 'package:di/di.dart';
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:quiver/strings.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_backend/src/message_repository.dart';
import 'package:slack_history_keeper_backend/src/mongo_db_pool.dart';
import 'package:slack_history_keeper_backend/slack_history_keeper.dart';

@Injectable()
class PollingDaemon {
  static const int numberOfSecondsBetweenChannelPolls = 2;

  /*
  If this is empty the daemon will poll all channels
   */
  final List<String> channelsToPoll = [];
  final MessageRepository messageRepository;
  final MongoDbPool mongoDbPool;
  final SlackConnector slackConnector;

  List<Channel> channels = [];

  PollingDaemon(this.messageRepository, this.mongoDbPool, this.slackConnector);

  void filterChannelsToPoll() {
    if (channelsToPoll.isNotEmpty) {
      channels.retainWhere((Channel c) => channelsToPoll.contains(c.name));
    }
  }

  Future saveNewMessages(Channel c) async {
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

    messages
      ..removeWhere((Message m) => isBlank(m.text))
      ..removeWhere((Message m) => m.userId == 'USLACKBOT')
      ..removeWhere((Message m) => hasUnwantedSubtype(m));

    await messageRepository.insertMessages(messages);
  }

  bool hasUnwantedSubtype(Message m) {
    if (isBlank(m.subtype)) {
      return false;
    }

    return !['me_message', 'message_changed', 'message_deleted']
        .contains(m.subtype);
  }

  /*
  This polls all specified channels for new messages via [channelsToPoll].
  This doesn't catch edit to messages (yet)
   */
  Future poll() async {
    channels = await slackConnector.fetchChannels();
    filterChannelsToPoll();

    int secondsToDelay = 1;
    channels.forEach((Channel c) async {
      new Future.delayed(new Duration(seconds: secondsToDelay),
          () async => await saveNewMessages(c));
      secondsToDelay += numberOfSecondsBetweenChannelPolls;
    });
  }
}
