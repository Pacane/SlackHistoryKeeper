// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:slack_history_keeper/slack_history_keeper.dart'
    as slack_history_keeper;
import 'dart:io';
import 'package:logging/logging.dart';
import 'dart:async';
import 'package:slack_history_keeper/src/polling_daemon.dart';

final Logger log = new Logger('Application');

Future fetchMessages(
    slack_history_keeper.Channel generalChannel,
    slack_history_keeper.Message lastMessage,
    List<slack_history_keeper.Message> messages) {
  return slack_history_keeper
      .fetchChannelHistory(generalChannel.id,
          lastTimestamp: lastMessage != null ? lastMessage.timestamp : '0')
      .then((List<slack_history_keeper.Message> newMessages) {
    newMessages.reversed.forEach((slack_history_keeper.Message m) => print(m));
    messages
      ..clear()
      ..addAll(newMessages);
  });
}

String checkSlackApiToken() {
  var slackApitoken = Platform.environment['SLACK_TOKEN'];

  if (slackApitoken == null) {
    log.severe("SLACK_TOKEN is not a defined environment variable");
    throw new Exception("SLACK_TOKEN is not defined.");
  }

  return slackApitoken;
}

setupLogger() {
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

main(List<String> arguments) async {
  setupLogger();

  var slackApitoken = checkSlackApiToken();
  slack_history_keeper.slackApiToken = slackApitoken;

//  var users = await slack_history_keeper.fetchUsers();
//  var channels = await slack_history_keeper.fetchChannels();
//  var generalChannel = channels
//      .firstWhere((slack_history_keeper.Channel c) => c.name == 'general');
//
//  var messages =
//      await slack_history_keeper.fetchChannelHistory(generalChannel.id);
//
//  messages.reversed.forEach((slack_history_keeper.Message m) => print(m));
//
//  new Timer.periodic(new Duration(seconds: 5), (Timer t) {
//    if (messages.isEmpty) {
//      fetchMessages(generalChannel, null, messages);
//    } else {
//      slack_history_keeper.Message lastMessage = messages.first;
//
//      fetchMessages(generalChannel, lastMessage, messages);
//    }
//  });

  slack_history_keeper.startApiServer();

  slack_history_keeper.PollingDaemon pollingDaemon = slack_history_keeper.pollingDaemon;
  pollingDaemon.poll();
}
