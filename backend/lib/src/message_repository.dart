import 'dart:async';

import 'package:connection_pool/connection_pool.dart';
import 'package:di/di.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:slack_history_keeper_backend/src/mongo_db_pool.dart';
import 'package:slack_history_keeper_shared/models.dart';

@Injectable()
class MessageRepository {
  final MongoDbPool connectionPool;

  ManagedConnection connection;

  Future<Db> getConnection() async => connection.conn;

  MessageRepository(this.connectionPool) {
    bootstrapMapper();
  }

  Future<List<Message>> fetchMessages(
      {List<String> channelIds: const [], List<String> userIds: const []}) {
    return executeWrappedCommand((Db db) async {
      List<Message> messages = await db
          .collection("messages")
          .find(where..sortBy("timestamp", descending: true))
          .map((Map m) => decode(m, Message))
          .toList();

      return messages;
    });
  }

  Future<List<Message>> queryMessages(String queryString,
      {List<String> channelIds: const [], List<String> userIds: const []}) {
    return executeWrappedCommand((Db db) async {
      var query = where.sortBy("timestamp", descending: true);

      if (queryString.isNotEmpty)
        query = query.eq("\$text", {"\$search": queryString});
      if (channelIds.isNotEmpty) query = query.oneFrom("channelId", channelIds);
      if (userIds.isNotEmpty) query = query.oneFrom("userId", userIds);

      List<Map> messages = await db
          .collection("messages")
          .find(query)
          .map((Map m) => decode(m, Message))
          .toList();

      return messages;
    });
  }

  Future<Message> getLatestMessage(String channelId) async {
    return executeWrappedCommand((Db db) async {
      Map fetched = await db.collection("messages").findOne(where
          .sortBy('timestamp', descending: true)
          .eq("channelId", channelId));
      return decode(fetched, Message);
    });
  }

  Future insertMessages(List<Message> messages) {
    messages.forEach((Message m) => print("$m \n"));

    if (messages.isEmpty) return new Future.value();

    return executeWrappedCommand((Db db) async {
      Db db = await getConnection();
      return db.collection("messages").insertAll(
          messages.map((Message m) => encode(m)).toList(),
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

  Future clearMessages() async {
    return executeWrappedCommand((Db db) async {
      Db db = await getConnection();
      return db.collection("messages").drop();
    });
  }
}

typedef Future CommandToExecute(Db db);
