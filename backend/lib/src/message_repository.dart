import 'dart:async';

import 'package:connection_pool/connection_pool.dart';
import 'package:di/di.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:slack_history_keeper_backend/src/mongo_db_pool.dart';
import 'package:slack_history_keeper_shared/models.dart';
import 'package:quiver/strings.dart';
import 'package:slack_history_keeper_shared/convert.dart';

@Injectable()
class MessageRepository {
  final MongoDbPool connectionPool;
  final MessageDecoder messageDecoder;
  final MessageEncoder messageEncoder;

  ManagedConnection connection;

  Future<Db> getConnection() async => connection.conn;

  MessageRepository(this.connectionPool)
      : this.messageDecoder = new MessageDecoder(),
        this.messageEncoder = new MessageEncoder();

  Future<List<Message>> fetchMessages(
      {List<String> channelIds: const [], List<String> userIds: const []}) {
    return executeWrappedCommand((Db db) async {
      var maps =
          db.collection("messages").find(where..sortBy("ts", descending: true));

      var messages = <Message>[];
      await for (var map in maps) {
        messages.add(messageDecoder.convert(map));
      }

      return messages;
    }) as Future<List<Message>>;
  }

  Future<List<Message>> queryMessages(String queryString,
      {List<String> channelIds: const [], List<String> userIds: const []}) {
    return executeWrappedCommand((Db db) async {
      var query = where.sortBy("ts", descending: true);

      if (!isEmpty(queryString))
        query = query
          ..eq("\$text", {"\$search": queryString})
          ..metaTextScore("score")
          ..sortByMetaTextScore("score");
      if (channelIds.isNotEmpty) query = query.oneFrom("channelId", channelIds);
      if (userIds.isNotEmpty) query = query.oneFrom("userId", userIds);

      var documents = await db.collection("messages").find(query);
      var messages = <Message>[];
      await for (var d in documents) {
        messages.add(messageDecoder.convert(d));
      }

      return messages;
    }) as Future<List<Message>>;
  }

  Future<Message> getLatestMessage(String channelId) async {
    return executeWrappedCommand((Db db) async {
      Map fetched = await db.collection("messages").findOne(
          where.sortBy('ts', descending: true).eq("channelId", channelId));
      return fetched == null ? null : messageDecoder.convert(fetched);
    }) as Future<Message>;
  }

  Future insertMessages(List<Message> messages) {
    messages.forEach((Message m) => print("$m \n"));

    if (messages.isEmpty) return new Future.value();

    return executeWrappedCommand((Db db) async {
      return db.collection("messages").insertAll(
          messages.map((Message m) => messageEncoder.convert(m)).toList(),
          writeConcern: new WriteConcern(fsync: true));
    });
  }

  Future executeWrappedCommand(CommandToExecute command) async {
    try {
      var connection = await connectionPool.getConnection();

      return await command(connection.conn);
    } catch (e) {
      print("Error with database connection: $e}");
      rethrow;
    } finally {
      connectionPool.releaseConnection(connection);
    }
  }

  Future clearMessages() async {
    return executeWrappedCommand((Db db) async {
      return db.collection("messages").drop();
    });
  }

  Future createIndexOnText() {
    return executeWrappedCommand((Db db) async {
      return db.createIndex("messages", keys: {'text': 'text'});
    });
  }
}

typedef Future CommandToExecute(Db db);
