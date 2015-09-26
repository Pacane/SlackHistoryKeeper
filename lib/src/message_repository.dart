import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:redstone_mapper_mongo/metadata.dart';

class MessageRepository {
  Db db = new Db('mongodb://pacane:password1234!@ds059682.mongolab.com:59682/slack_history_staging2');

  MessageRepository() {
    bootstrapMapper();
  }

  Future fetchMessages() async {
    try {
      await db.open();

      var collection = db.collection('messages');
      List<Message> messages = await collection.find({}).map((Map m) => decode(m, Message)).toList();

      return messages;
    } catch (e) {
      print("ERROR HERE : $e");
    } finally {
      await db.close();
    }
  }
}

class Message {
  @Id()
  String id;

  @Field()
  String name;
}