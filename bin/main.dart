// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:slack_history_keeper/slack_history_keeper.dart'
    as slack_history_keeper;

final Logger log = new Logger('Application');

String checkSlackApiToken() {
  var slackApitoken = Platform.environment['SLACK_TOKEN'];

  if (slackApitoken == null) {
    log.severe("SLACK_TOKEN is not a defined environment variable");
    throw new Exception("SLACK_TOKEN is not defined.");
  }

  return slackApitoken;
}

String checkDatabaseUri() {
  var dbUri = Platform.environment['SLACK_DB_URI'];
  if (dbUri == null) {
    log.severe("SLACK_DB_URI is not a defined environment variable.");
    throw new Exception("SLACK_DB_URI is not set.");
  }

  return dbUri;
}

void setupLogger() {
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

Future main(List<String> arguments) async {
  setupLogger();

  var slackApitoken = checkSlackApiToken();
  slack_history_keeper.slackApiToken = slackApitoken;

  slack_history_keeper.databaseUri = checkDatabaseUri();
  slack_history_keeper.poolSize = 3;

  slack_history_keeper.startApiServer();

  slack_history_keeper.PollingDaemon pollingDaemon =
      slack_history_keeper.pollingDaemon;

  pollingDaemon.poll();
  new Timer.periodic(new Duration(minutes: 10), (Timer t) {
    pollingDaemon.poll();
  });
}
