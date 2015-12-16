import 'dart:async';

abstract class NameToId {
  Future<String> channelNameToId(String channelName);
  Future<String> userNameToId(String userName);
}
