import 'package:test/test.dart';
import 'package:slack_history_keeper_frontend/services/query_parser.dart';
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

class MockNameToId extends Mock implements NameToId {
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  var nameToIdConverter = new MockNameToId();
  QueryParser parser = new QueryParser(nameToIdConverter);

  test('single in channel', () async {
    var channelName = 'general';
    var query = 'in:$channelName';
    var generalId = '1234';

    when(nameToIdConverter.channelNameToId(channelName))
        .thenReturn(new Future.value(generalId));

    var result = await parser.parse(query);

    expect(result.channelIds, contains(generalId));
    expect(result.userIds, isEmpty);
    expect(result.keywords, isNull);
  });

  test('multiple in channel', () async {
    var channel1Name = 'general';
    var channel1Id = '1234';
    var channel2Name = 'random';
    var channel2Id = '4567';
    var query = 'in:$channel1Name in:$channel2Name';

    when(nameToIdConverter.channelNameToId(channel1Name))
        .thenReturn(new Future.value(channel1Id));
    when(nameToIdConverter.channelNameToId(channel2Name))
        .thenReturn(new Future.value(channel2Id));

    var result = await parser.parse(query);

    expect(result.channelIds, [channel1Id, channel2Id]);
    expect(result.userIds, isEmpty);
    expect(result.keywords, isNull);
  });
}
