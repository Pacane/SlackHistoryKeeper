import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_shared/slack_cache.dart';

class UsersService {
  final SlackCache slackCache;

  UsersService(this.slackCache);

  List<User> getUsers() => slackCache.getUsers();
}
