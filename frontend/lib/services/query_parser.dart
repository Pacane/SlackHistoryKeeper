import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';
import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:quiver/strings.dart';

@Injectable()
class QueryParser {
  final NameToId nameToIdConverter;

  QueryParser(this.nameToIdConverter);

  Future<Query> parse(String queryString) async {
    var expressions = queryString.split(new RegExp(r"\s+")).toSet();
    var channelExpressions =
        await expressions.where((String exp) => exp.startsWith('in:'));

    var channelIds = channelExpressions
        .map((String exp) => exp.substring(3))
        .map((String exp) => nameToIdConverter.channelNameToId(exp))
        .toSet();

    var userExpressions =
        await expressions.where((String exp) => exp.startsWith('from:'));

    var userIds = userExpressions
        .map((String exp) => exp.substring(5))
        .map((String exp) => nameToIdConverter.userNameToId(exp))
        .toSet();

    var keywords = await expressions
        .difference(channelExpressions.toSet())
        .difference(userExpressions.toSet())
        .join(' ');

    return await createQuery(keywords, channelIds, userIds);
  }

  Future<Query> createQuery(
      String keywords, Set channelIds, Set userIds) async {
    var query = new Query();

    query.keywords = emptyToNull(keywords);
    await awaitFutureParams(channelIds, query.channelIds);
    await awaitFutureParams(userIds, query.userIds);

    return query;
  }

  Future awaitFutureParams(Set<Future> futures, List collection) async {
    for (var future in futures) {
      var id = await future;
      if (id != null) collection.add(id);
    }
  }
}

class Query {
  List<String> channelIds = [];
  List<String> userIds = [];
  String keywords;
}
