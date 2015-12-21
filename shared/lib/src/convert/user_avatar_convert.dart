library slack_history_keeper_shared.src.convert.user_avatar_convert;

String decodeUserAvatar(Map value) {
  var val = value['image_32'];
  return val;
}
Map encodeUserAvatar(String value) => { 'image_32': value };
