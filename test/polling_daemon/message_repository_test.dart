// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

library slack_history_keeper.test;

import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';
import 'package:slack_history_keeper/src/message_repository.dart';

void main() {
  MessageRepository messageRepository = new MessageRepository();

  setUp(() async {
    await messageRepository.db.open();
    messageRepository.db.collection('messages').insert({'name': "hello"});
    await messageRepository.db.close();
  });

  tearDown(() async {
    await messageRepository.db.open();
    messageRepository.db.collection('messages').remove();
    await messageRepository.db.close();
  });

  test('repository can fetch messages', () async {
    List<Message> messages = await messageRepository.fetchMessages();
    expect(messages[0].name, 'hello');
  });
}
