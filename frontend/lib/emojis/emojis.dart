import 'dart:async';
import 'dart:convert';
import 'dart:html';

class Emojis {
  static Map _emojis;

  static Future init() async {
    return HttpRequest
        .getString("/assets/emojis.json")
        .then((json) => _emojis = JSON.decode(json));
  }

  static String getChar(String emojiName) {
    var emoji = _emojis[emojiName] ??
        _emojis[emojiName.replaceAll(new RegExp('_face\$'), '')];

    if (emoji == null) {
      print(emojiName + " has no match");
      return null;
    }

    String utf16 = (emoji['char'] as String)
        ?.codeUnits
        ?.fold("", (prev, value) => '$prev ${value.toRadixString(16)}');

    return _utf16toCharacterCode(utf16.toUpperCase()).toLowerCase();
  }

  static String dec2hex(int value) {
    return value.toRadixString(16).toUpperCase();
  }

  static String _utf16toCharacterCode(String textString) {
    var outputString = "";
    var hi = 0;
    textString = textString.trim();
    if (textString.isEmpty) {
      return '';
    }

    var listArray = textString.split(' ');
    for (var i = 0; i < listArray.length; i++) {
      var b = int.parse(listArray[i], radix: 16);
      if (b < 0 || b > 0xFFFF) {
        return '';
      }
      if (hi != 0) {
        if (0xDC00 <= b && b <= 0xDFFF) {
          outputString +=
              dec2hex(0x10000 + ((hi - 0xD800) << 10) + (b - 0xDC00)) + ' ';
          hi = 0;
          continue;
        } else {
          return '';
        }
      }
      if (0xD800 <= b && b <= 0xDBFF) {
        hi = b;
      } else {
        outputString += dec2hex(b) + ' ';
      }
    }
    return outputString.trim();
  }
}
