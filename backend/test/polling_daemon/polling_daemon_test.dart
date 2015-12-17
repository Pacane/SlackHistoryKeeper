import 'package:test/test.dart';
import 'package:slack_history_keeper_backend/slack_history_keeper.dart';
import 'package:slack_history_keeper_shared/models.dart';

void main() {
  group("Subtypes", () {
    PollingDaemon sut = new PollingDaemon(null, null, null);

    List<String> wantedSubtypes = [
      'me_message',
      'message_changed',
      'message_deleted',
      null,
      ''
    ];

    List<String> unwantedSubtypes = [
      'bot_message',
      'channel_join',
      'channel_leave',
      'channel_topic',
      'channel_purpose',
      'channel_name',
      'channel_archive',
      'channel_unarchive',
      'group_join',
      'group_leave',
      'group_topic',
      'group_purpose',
      'group_name',
      'group_archive',
      'group_unarchive',
      'file_share',
      'file_comment',
      'file_mention',
      'pinned_item',
      'unpinned_item',
    ];

    for (var subtype in wantedSubtypes) {
      test('wanted: $subtype', () {
        var message = new Message()..subtype = subtype;

        var result = sut.hasUnwantedSubtype(message);

        expect(result, false);
      });
    }

    for (var subtype in unwantedSubtypes) {
      test('unwanted: $subtype', () {
        var message = new Message()..subtype = subtype;

        var result = sut.hasUnwantedSubtype(message);

        expect(result, true);
      });
    }
  });
}
