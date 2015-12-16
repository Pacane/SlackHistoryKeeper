import 'dart:async';
import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_backend/slack_history_keeper.dart';

class UsersService {
  final SlackConnector slackConnector;

  UsersService(this.slackConnector);

  Future<List<User>> fetchUsersFromSlackApi() => slackConnector.fetchUsers();
}
