import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart' show Pipe;
import 'package:markdown/markdown.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/models.dart';

const List parserBindings = const [MessageParser, MentionSyntax, EmoticonSyntax];

@Pipe(name: 'messageParser', pure: true)
@Injectable()
class MessageParser implements PipeTransform {
  List<InlineSyntax> inlineSyntaxes = [];

  MessageParser(MentionSyntax mentionSyntax, EmoticonSyntax emoticonSyntax) {
    inlineSyntaxes = [
      new TagSyntax(r'\*\*', tag: 'strong'),
      new TagSyntax(r'\*', tag: 'strong'),
      new TagSyntax(r'\~', tag: 'strike'),
      new TagSyntax(r'\b__', tag: 'em', end: r'__\b'),
      mentionSyntax,
      emoticonSyntax
    ];
  }

  @override
  String transform(String message, List args) {
    return markdownToHtml(message,
        inlineSyntaxes: inlineSyntaxes,
        blockSyntaxes: [new FencedCodeBlockSyntax()]);
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
    var anchor = new Element.text('strong', '@' + user.name);

    parser.addNode(anchor);
    return true;
  }
}

@Injectable()
class EmoticonSyntax extends InlineSyntax {
  static const String emojisUrl =
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

  Element createEmoticonImage(Emoticon emoticon, String name) {
    var img = new Element.withTag('img');
    if (emoticon != null) {
      img.attributes['src'] = emoticon.url;
    } else {
      img.attributes['src'] = "$emojisUrl/$name.png";
    }

    img.attributes['alt'] = name;
    img.attributes['class'] = "emoji";
    img.attributes['onerror'] = "javascript: this.src = '$emojisUrl/x.png';";
    return img;
  }
}

class FencedCodeBlockSyntax extends BlockSyntax {
  RegExp get pattern => new RegExp(r'^[ ]{0,3}(`{3,}|~{3,})(.*)$');

  const FencedCodeBlockSyntax();

  List<String> parseChildLines(BlockParser parser, [String endBlock]) {
    if (endBlock == null) endBlock = '';

    var childLines = <String>[];
    parser.advance();

    while (!parser.isDone) {
      var match = pattern.firstMatch(parser.current);
      if (match == null || !match[1].startsWith(endBlock)) {
        childLines.add(parser.current);
        parser.advance();
      } else {
        parser.advance();
        break;
      }
    }

    return childLines;
  }

  Node parse(BlockParser parser) {
    // Get the syntax identifier, if there is one.
    var match = pattern.firstMatch(parser.current);
    var endBlock = match.group(1);
    var syntax = match.group(2);

    var childLines = parseChildLines(parser, endBlock);

    // The Markdown tests expect a trailing newline.
    childLines.add('');

    // Escape the code.
    var escaped = childLines.join('\n');

    var element = new Element('pre', [new Element.text('code', escaped)]);
    if (syntax != '') element.attributes['class'] = syntax;

    return element;
  }
}
