import 'dart:async';

import 'package:connection_pool/connection_pool.dart';
import 'package:di/di.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:slack_history_keeper_backend/src/mongo_db_pool.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'dart:convert';

@Injectable()
class ChannelRepository {
  final MongoDbPool connectionPool;

  ManagedConnection connection;

  Future<Db> getConnection() async => connection.conn;

  ChannelRepository(this.connectionPool);

  Future<List<Channel>> fetchChannels() async {
    return executeWrappedCommand((Db db) async {
      var maps = await db.collection("channels").find().toList();
      return maps.map((Map m) => new Channel.fromJson(m)).toList();
    });
  }

  Future insertChannels(List<Channel> channels) {
    channels.forEach((Channel c) => print("$c \n"));

    if (channels.isEmpty) return new Future.value();

    return executeWrappedCommand((Db db) async {
      return db.collection("channels").insertAll(
          channels.map((Channel c) => JSON.encode(c)).toList(),
          writeConcern: new WriteConcern(fsync: true));
    });
  }

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
