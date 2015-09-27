// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

/// The slack_history_keeper library.
library slack_history_keeper;

export 'src/slack_connector/models.dart';
export 'src/slack_connector/slack_connector.dart';
export 'src/rest_api.dart';
export 'src/polling_daemon.dart';

import 'package:di/di.dart';
import 'package:slack_history_keeper/src/polling_daemon.dart';
import 'package:slack_history_keeper/src/message_repository.dart';
import 'package:slack_history_keeper/src/mongo_db_pool.dart';
import 'package:slack_history_keeper/src/slack_connector/slack_connector.dart';

String slackApiToken;
String databaseUri;
int poolSize;

var pollingDaemonModule = new Module()
  ..bind(PollingDaemon)
  ..bind(MessageRepository)
  ..bind(SlackConnector)
  ..bind(MongoDbPool, toValue: new MongoDbPool(databaseUri, poolSize));

var injector = new ModuleInjector([pollingDaemonModule]);

var pollingDaemon = injector.get(PollingDaemon);
