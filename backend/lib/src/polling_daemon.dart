import 'dart:async';

import 'package:di/di.dart';
import 'package:logging/logging.dart';
import 'package:quiver/strings.dart';

import 'package:slack_history_keeper_shared/models.dart';

import '../slack_connector.dart';

import 'message_repository.dart';
import 'mongo_db_pool.dart';

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
      String lastTimeStampToFetch = lastMessage.ts;
      messages = await slackConnector.fetchChannelHistory(c.id,
          lastTimestamp: lastTimeStampToFetch);
    }

    messages
      ..removeWhere((Message m) => isBlank(m.text))
      ..removeWhere((Message m) => m.user == 'USLACKBOT')
      ..removeWhere((Message m) => hasUnwantedSubtype(m));

    await messageRepository.insertMessages(messages);
  }

  bool hasUnwantedSubtype(Message m) {
    if (isBlank(m.type)) {
      return false;
    }

    var isUnwantedType =
        ['me_message', 'message_changed', 'message_deleted'].contains(m.type);
    return isUnwantedType;
  }

  /*
  This polls all specified channels for new messages via [channelsToPoll].
  This doesn't catch edit to messages (yet)
   */
  Future poll() async {
    await slackConnector.fetchUsers();
    await slackConnector.fetchEmoticons();
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
