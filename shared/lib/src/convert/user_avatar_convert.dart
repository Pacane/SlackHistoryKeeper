library slack_history_keeper_shared.src.convert.user_avatar_convert;

String decodeUserAvatar(Map value) => value['image_32'];
Map encodeUserAvatar(String value) => { 'image_32': value };
