import 'package:slack_history_keeper_shared/models.dart';

class UsersService {
  final SlackCache slackCache;

  UsersService(this.slackCache);

  List<User> getUsers() => slackCache.getUsers();
}
