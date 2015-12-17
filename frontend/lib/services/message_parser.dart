import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart' show Pipe;
import 'package:markdown/markdown.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/src/models.dart';

const parserBindings = const [MessageParser, MentionSyntax, EmoticonSyntax];

@Pipe(name: 'messageParser', pure: true)
@Injectable()
class MessageParser implements PipeTransform {
  List<TextSyntax> inlineSyntaxes = [];

  MessageParser(MentionSyntax mentionSyntax, EmoticonSyntax emoticonSyntax) {
    inlineSyntaxes = [mentionSyntax, emoticonSyntax];
  }

  @override
  String transform(String message, List args) {
    return markdownToHtml(message, inlineSyntaxes: inlineSyntaxes);
  }
}

@Injectable()
class MentionSyntax extends InlineSyntax {
  final SlackService slackService;

  MentionSyntax(this.slackService) : super(r'<@([A-Z0-9]{9})(?:\|[a-z]+)?>');

  @override
  bool onMatch(InlineParser parser, Match match) {
    var userId = match.group(1);
    var user = slackService.getUserFromId(userId);
    var anchor = new Element.text('a', '@' + user.name);
    anchor.attributes['href'] = "http://google.ca";

    parser.addNode(anchor);
    return true;
  }
}

@Injectable()
class EmoticonSyntax extends InlineSyntax {
  static const emojisUrl =
      'https://raw.githubusercontent.com/arvida/emoji-cheat-sheet.com/master/public/graphics/emojis';
  final SlackService slackService;

  EmoticonSyntax(this.slackService) : super(r':([a-zA-Z0-9_]+):');

  @override
  bool onMatch(InlineParser parser, Match match) {
    var name = match.group(1);
    var emoticon = slackService.getEmoticonFromName(name);

    while (emoticon != null && emoticon.url.startsWith('alias:')) {
      name = emoticon.url.substring(6);
      emoticon = slackService.getEmoticonFromName(name);
    }

    var img = createEmoticonImage(emoticon, name);
    parser.addNode(img);

    return true;
  }

  createEmoticonImage(Emoticon emoticon, String name) {
    var img = new Element.withTag('img');
    if (emoticon != null) {
      img.attributes['src'] = emoticon.url;
    } else {
      img.attributes['src'] = "$emojisUrl/$name.png";
    }

    img.attributes['alt'] = name;
    img.attributes['onerror'] = "javascript: this.src = '$emojisUrl/x.png';";
    return img;
  }
}
