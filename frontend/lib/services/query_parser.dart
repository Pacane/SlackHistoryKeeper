import 'dart:async';

import 'dart:collection';
import 'package:angular2/angular2.dart';
import 'package:quiver/strings.dart';
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';

@Injectable()
class QueryParser {
  static final String MENTION = 'mention:';
  static final String FROM = 'from:';
  static final String IN = 'in:';

  final NameToId nameToIdConverter;

  QueryParser(this.nameToIdConverter);

  Future<Query> parse(String queryString) async {
    var expressions =
        nullToEmpty(queryString).split(new RegExp(r"\s+")).toList();

    Set<String> channelIds = new HashSet();
    Set<String> userIds = new HashSet();

    var channelExpressions =
        expressions.where((String exp) => exp.startsWith(IN)).map((token) {
      channelIds
          .add(nameToIdConverter.channelNameToId(token.substring(IN.length)));
      return token;
    }).toSet();

    var mentionExpressions =
        expressions.where((String exp) => exp.startsWith(MENTION));
    for (var mention in mentionExpressions) {
      var index = expressions.indexOf(mention);
      var userId =
          nameToIdConverter.userNameToId(mention.substring(MENTION.length));
      expressions.remove(mention);
      expressions.insert(index, userId);
    }

    var userExpressions =
        expressions.where((String exp) => exp.startsWith(FROM)).map((token) {
      userIds.add(nameToIdConverter.userNameToId(token.substring(FROM.length)));
      return token;
    }).toSet();

    var keywords = expressions
        .toSet()
        .difference(channelExpressions)
        .difference(userExpressions)
        .join(' ');

    return createQuery(keywords, channelIds, userIds);
  }

  Query createQuery(
      String keywords, Set<String> channelIds, Set<String> userIds) {
    var query = new Query();

    query.keywords = emptyToNull(keywords);
    filterNotNullIds(channelIds, query.channelIds);
    filterNotNullIds(userIds, query.userIds);

    return query;
  }

  void filterNotNullIds(Set<String> ids, List collection) {
    for (var id in ids) {
      if (id != null) collection.add(id);
    }
  }
}

class Query {
  List<String> channelIds = [];
  List<String> userIds = [];
  String keywords;
}
