import 'dart:async';

import 'package:connection_pool/connection_pool.dart';
import 'package:di/di.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:slack_history_keeper_backend/src/mongo_db_pool.dart';
import 'package:slack_history_keeper_shared/models.dart';

@Injectable()
class ChannelRepository {
  final MongoDbPool connectionPool;

  ManagedConnection connection;

  Future<Db> getConnection() async => connection.conn;

  ChannelRepository(this.connectionPool) {
    bootstrapMapper();
  }

  Future<List<Channel>> fetchChannels() {
    return executeWrappedCommand((Db db) async {
      List<Channel> channels = await db
          .collection("channels")
          .find()
          .map((Map m) => decode(m, Channel))
          .toList();

      return channels;
    });
  }

  Future insertChannels(List<Channel> channels) {
    channels.forEach((Channel c) => print("$c \n"));

    if (channels.isEmpty) return new Future.value();

    return executeWrappedCommand((Db db) async {
      return db.collection("channels").insertAll(
          channels.map((Channel c) => encode(c)).toList(),
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
