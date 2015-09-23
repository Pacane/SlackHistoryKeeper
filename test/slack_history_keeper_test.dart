// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

library slack_history_keeper.test;

import 'package:slack_history_keeper/slack_history_keeper.dart';
import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  slackApiToken = Platform.environment["SLACK_TOKEN"];
  String channelId = 'C0AT47NAU'; // general channel

  test('slack api token is specified', () {
    expect(slackApiToken, isNotNull);
  });

  test('fetch users should get a list of users containing user joel', () async {
    User joel = new User()
      ..id = 'U0AT0BWTE'
      ..name = 'joel';

    List<User> users = await fetchUsers();

    expect(users[0], equals(joel));
  });

  test('fetch channels should serialize correctly', () async {
    Channel general = new Channel()
      ..id = 'C0AT47NAU'
      ..name = 'general';
    Channel random = new Channel()
      ..id = 'C0AT2UJ6B'
      ..name = 'random';

    List<Channel> channels = await fetchChannels();

    expect(channels, hasLength(2));
    expect(channels[0], equals(general));
    expect(channels[1], equals(random));
  });

  test('fetch channel history', () async {
    var history = await fetchChannelHistory(channelId);
    print(history);
  });
}
