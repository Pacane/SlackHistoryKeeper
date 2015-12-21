import 'dart:async';

import 'package:connection_pool/connection_pool.dart';
import 'package:di/di.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:slack_history_keeper_backend/src/mongo_db_pool.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_shared/convert.dart';

@Injectable()
class ChannelRepository {
  final MongoDbPool connectionPool;
  final ChannelDecoder channelDecoder = new ChannelDecoder();
  final ChannelEncoder channelEncoder = new ChannelEncoder();

  ManagedConnection connection;

  Future<Db> getConnection() async => connection.conn;

  ChannelRepository(this.connectionPool);

  Future<List<Channel>> fetchChannels() async {
    var channels = <Channel>[];

    return executeWrappedCommand((Db db) async {
      var maps = await db.collection("channels").find();

      await for (Map m in maps) {
        channels.add(channelDecoder.convert(m));
      }

      return channels;
    }) as List<Channel>;
  }

  Future insertChannels(List<Channel> channels) {
    channels.forEach((Channel c) => print("$c \n"));

    if (channels.isEmpty) return new Future.value();

    return executeWrappedCommand((Db db) async {
      return db.collection("channels").insertAll(
          channels.map((Channel c) => channelEncoder.convert(c)).toList(),
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
