import 'package:slack_history_keeper_shared/models.dart';

class SlackCache {
  Map<String, User> _users = {};
  Map<String, Channel> _channels = {};
  Map<String, Emoticon> _emoticons = {};

  List<Channel> getChannels() {
    return _channels.values.toList();
  }

  List<Emoticon> getEmoticons() {
    return _emoticons.values.toList();
  }

  List<User> getUsers() {
    return _users.values.toList();
  }

  Channel getChannelfromId(String id) => _channels[id];

  User getUserFromId(String id) => _users[id];

  Emoticon getEmoticonFromName(String name) => _emoticons[name];

  void set users(Map<String, User> users) {
    _users = users;
  }

  void set channels(Map<String, Channel> channels) {
    _channels = channels;
  }

  void set emoticons(Map<String, Emoticon> emoticons) {
    _emoticons = emoticons;
  }
}
