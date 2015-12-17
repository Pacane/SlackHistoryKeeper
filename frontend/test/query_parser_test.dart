import 'package:test/test.dart';
import 'package:slack_history_keeper_frontend/services/query_parser.dart';
import 'package:mockito/mockito.dart';
import 'package:slack_history_keeper_frontend/services/name_to_id_mixin.dart';

class MockNameToId extends Mock implements NameToId {}

void main() {
  var nameToIdConverter = new MockNameToId();
  QueryParser parser = new QueryParser(nameToIdConverter);

  test('single in channel', () async {
    var channelName = 'general';
    var query = 'in:$channelName';
    var generalId = '1234';

    when(nameToIdConverter.channelNameToId(channelName)).thenReturn(generalId);

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
        .thenReturn(channel1Id);
    when(nameToIdConverter.channelNameToId(channel2Name))
        .thenReturn(channel2Id);

    var result = await parser.parse(query);

    expect(result.channelIds, [channel1Id, channel2Id]);
    expect(result.userIds, isEmpty);
    expect(result.keywords, isNull);
  });

  test('single from user', () async {
    var userName = 'general';
    var query = 'from:$userName';
    var generalId = '1234';

    when(nameToIdConverter.userNameToId(userName)).thenReturn(generalId);

    var result = await parser.parse(query);

    expect(result.channelIds, isEmpty);
    expect(result.userIds, contains(generalId));
    expect(result.keywords, isNull);
  });

  test('multiple from user', () async {
    var user1Name = 'general';
    var user1Id = '1234';
    var user2Name = 'random';
    var user2Id = '4567';
    var query = 'from:$user1Name from:$user2Name';

    when(nameToIdConverter.userNameToId(user1Name)).thenReturn(user1Id);
    when(nameToIdConverter.userNameToId(user2Name)).thenReturn(user2Id);

    var result = await parser.parse(query);

    expect(result.channelIds, isEmpty);
    expect(result.userIds, [user1Id, user2Id]);
    expect(result.keywords, isNull);
  });
}
