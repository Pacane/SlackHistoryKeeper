import 'package:di/di.dart';
import 'package:slack_history_keeper_backend/src/channel_repository.dart';
import 'package:slack_history_keeper_backend/src/message_repository.dart';

Module repositoryModule = new Module()
  ..bind(ChannelRepository)
  ..bind(MessageRepository);
