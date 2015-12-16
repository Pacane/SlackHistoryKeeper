import 'dart:async';

abstract class NameToId {
  Future<String> channelNameToId(String channelName);
}
