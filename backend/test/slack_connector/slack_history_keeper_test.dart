// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

library slack_history_keeper.test;

import 'package:slack_history_keeper_backend/slack_history_keeper.dart';
import 'package:test/test.dart';
import 'package:slack_history_keeper_shared/models.dart';

void main() {
  slackApiToken = 'xoxp-10922254176-10918404932-10925301090-9127fdfa6d';

  var connector = new SlackConnector();

  test('slack api token is specified', () {
    expect(slackApiToken, isNotNull);
  });

  test('fetch users should get a list of users containing user joel', () async {
    User joel = new User()
      ..id = 'U0AT0BWTE'
      ..name = 'joel';

    List<User> users = await connector.fetchUsers();

    expect(users.singleWhere((User u) => u.name == 'joel'), equals(joel));
  });

  test('fetch channels should serialize correctly', () async {
    Channel general = new Channel()
      ..id = 'C0AT47NAU'
      ..name = 'general';
    Channel random = new Channel()
      ..id = 'C0AT2UJ6B'
      ..name = 'random';
    Channel test1 = new Channel()
      ..id = 'C0BCZT62Z'
      ..name = 'test1';
    Channel blogReviews = new Channel()
      ..id = 'C0EKKUQCW'
      ..name = 'blog-reviews';

    List<Channel> channels = await connector.fetchChannels();

    expect(channels, hasLength(4));
    expect(channels[0], equals(blogReviews));
    expect(channels[1], equals(general));
    expect(channels[2], equals(random));
    expect(channels[3], equals(test1));
  });
}
