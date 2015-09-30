// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

/// The slack_history_keeper library.
library slack_history_keeper;

export 'src/slack_connector/slack_connector.dart';
export 'src/polling_daemon.dart';
export 'src/services/channels_service.dart';

import 'package:di/di.dart';
import 'package:slack_history_keeper_backend/src/message_repository.dart';
import 'package:slack_history_keeper_backend/src/channel_repository.dart';
import 'package:slack_history_keeper_backend/src/mongo_db_pool.dart';
import 'package:slack_history_keeper_backend/src/polling_daemon.dart';
import 'package:slack_history_keeper_backend/src/slack_connector/slack_connector.dart';

String slackApiToken;
String databaseUri;
int poolSize;

var repositoryModule = new Module()
  ..bind(MessageRepository)
  ..bind(ChannelRepository);

var databaseModule = new Module()
  ..bind(MongoDbPool, toValue: new MongoDbPool(databaseUri, poolSize));

var pollingDaemonModule = new Module()
  ..bind(PollingDaemon)
  ..bind(SlackConnector);

var injector =
    new ModuleInjector([pollingDaemonModule, repositoryModule, databaseModule]);

var pollingDaemon = injector.get(PollingDaemon);
