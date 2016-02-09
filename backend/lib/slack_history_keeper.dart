// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

/// The slack_history_keeper library.
library slack_history_keeper;

import 'package:di/di.dart';

import 'package:slack_history_keeper_shared/slack_cache.dart';
export 'package:slack_history_keeper_shared/models.dart';

import 'slack_connector.dart';

import 'src/message_repository.dart';
import 'src/channel_repository.dart';
import 'src/mongo_db_pool.dart';
import 'src/polling_daemon.dart';

export 'src/polling_daemon.dart';
export 'src/services/channels_service.dart';
export 'src/services/messages_service.dart';
export 'src/services/emoticons_service.dart';
export 'src/services/users_service.dart';


String slackApiToken;
String databaseUri;
int poolSize;

Module repositoryModule = new Module()
  ..bind(MessageRepository)
  ..bind(ChannelRepository);

Module databaseModule = new Module()
  ..bind(MongoDbPool, toValue: new MongoDbPool(databaseUri, poolSize));

Module pollingDaemonModule = new Module()
  ..bind(PollingDaemon)
  ..bind(SlackConnector)
  ..bind(SlackCache);

ModuleInjector injector =
    new ModuleInjector([pollingDaemonModule, repositoryModule, databaseModule]);

PollingDaemon pollingDaemon = injector.get(PollingDaemon);
