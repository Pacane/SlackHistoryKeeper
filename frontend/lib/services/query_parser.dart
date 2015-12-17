import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:quiver/strings.dart';
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';

@Injectable()
class QueryParser {
  final NameToId nameToIdConverter;

  QueryParser(this.nameToIdConverter);

  Future<Query> parse(String queryString) async {
    var expressions =
        nullToEmpty(queryString).split(new RegExp(r"\s+")).toSet();
    var channelExpressions =
        expressions.where((String exp) => exp.startsWith('in:'));

    var channelIds = channelExpressions
        .map((String exp) => exp.substring(3))
        .map((String exp) => nameToIdConverter.channelNameToId(exp))
        .toSet();

    var userExpressions =
        expressions.where((String exp) => exp.startsWith('from:'));

    var userIds = userExpressions
        .map((String exp) => exp.substring(5))
        .map((String exp) => nameToIdConverter.userNameToId(exp))
        .toSet();

    var keywords = expressions
        .difference(channelExpressions.toSet())
        .difference(userExpressions.toSet())
        .join(' ');

    return createQuery(keywords, channelIds, userIds);
  }

  Query createQuery(
      String keywords, Set channelIds, Set userIds) {
    var query = new Query();

    query.keywords = emptyToNull(keywords);
    awaitFutureParams(channelIds, query.channelIds);
    awaitFutureParams(userIds, query.userIds);

    return query;
  }

  void awaitFutureParams(Set<String> futures, List collection) {
    for (var future in futures) {
      if (future != null) collection.add(future);
    }
  }
}

class Query {
  List<String> channelIds = [];
  List<String> userIds = [];
  String keywords;
}
