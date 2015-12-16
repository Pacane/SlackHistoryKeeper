import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';
import 'dart:async';
import 'package:angular2/angular2.dart';

@Injectable()
class QueryParser {
  final NameToId nameToIdConverter;

  QueryParser(this.nameToIdConverter);

  Future<Query> parse(String queryString) async {
    var expressions = queryString.split(new RegExp(r"\s+"));
    var channelExpressions =
        await expressions.where((String exp) => exp.startsWith('in:'));

    var channelIds = channelExpressions
        .map((String exp) => exp.substring(3))
        .map((String exp) => nameToIdConverter.channelNameToId(exp))
        .toList();

    var keywords = await expressions
        .where((String exp) => !channelExpressions.contains(exp))
        .join(' ');

    var query = new Query();
    query.keywords = keywords;

    for (var channelId in channelIds) {
      query.channelIds.add(await channelId);
    }

    return query;
  }
}

class Query {
  List<String> channelIds = [];
  List<String> userIds = [];
  String keywords;
}
