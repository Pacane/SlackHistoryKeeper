import 'package:slack_history_keeper_backend/src/mongo_db_pool.dart';
import 'package:connection_pool/connection_pool.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'dart:async';

abstract class HasConnectionPool {
  final MongoDbPool connectionPool;

  ManagedConnection connection;
  Future<Db> getConnection() async => connection.conn;

  HasConnectionPool(this.connectionPool);

  Future executeWrappedCommand(CommandToExecute command) async {
    try {
      var connection = await connectionPool.getConnection();

      return await command(connection.conn);
    } catch (e) {
      print("Error with database connection: $e}");
    } finally {
      connectionPool.releaseConnection(connection);
    }
  }
}

typedef Future CommandToExecute(Db db);
