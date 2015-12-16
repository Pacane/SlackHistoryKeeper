import 'package:di/di.dart';
import 'dart:io';
import 'package:slack_history_keeper_backend/src/mongo_db_pool.dart';

String slackApiToken = Platform.environment['SLACK_TOKEN'];
String databaseUri = Platform.environment['SLACK_DB_URI'];
int poolSize = 3;

Module databaseModule = new Module()
  ..bind(MongoDbPool, toValue: new MongoDbPool(databaseUri, poolSize));
