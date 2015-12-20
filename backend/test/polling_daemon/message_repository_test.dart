// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

library slack_history_keeper.test;

import 'package:test/test.dart';
import 'package:di/di.dart';

import 'package:slack_history_keeper_shared/models.dart';
import 'package:slack_history_keeper_backend/src/message_repository.dart';

import '../database_module.dart';
import 'repository_module.dart';

ModuleInjector injector =
    new ModuleInjector([repositoryModule, databaseModule]);

void main() {
  final userId = '4329830';
  final timestamp = '234578767';
  final text = 'hello!';

  MessageRepository messageRepository = injector.get(MessageRepository);

  setUp(() async {
    await messageRepository.insertMessages([
      new Message()
        ..userId = userId
        ..timestamp = timestamp
        ..attachments = []
        ..text = text
    ]);
  });

  tearDown(() async {
    await messageRepository.clearMessages();
  });

  test('repository can fetch messages', () async {
    List<Message> messages = await messageRepository.fetchMessages();
    expect(messages[0].userId, userId);
    expect(messages[0].timestamp, timestamp);
    expect(messages[0].text, text);
    expect(messages[0].attachments, []);
  });
}
