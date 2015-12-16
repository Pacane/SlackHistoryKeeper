import 'package:mongo_dart/mongo_dart.dart';
import 'package:connection_pool/connection_pool.dart';
import 'dart:async';

class MongoDbPool extends ConnectionPool<Db> {
  String uri;

  MongoDbPool(this.uri, int poolSize) : super(poolSize);

  @override
  void closeConnection(Db conn) {
    conn.close();
  }

  @override
  Future<Db> openNewConnection() async {
    var conn = new Db(uri);

    await conn.open();

    return conn;
  }
}
