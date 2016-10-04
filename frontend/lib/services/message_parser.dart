import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart' show Pipe;
import 'package:angular2/src/security/dom_sanitization_service.dart';
import 'package:markdown/markdown.dart';
import 'package:slack_history_keeper_frontend/emojis/emojis.dart';
import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:slack_history_keeper_shared/models.dart';

const List parserBindings = const [
  MessageParser,
  MentionSyntax,
  EmoticonSyntax
];

@Pipe(name: 'messageParser', pure: true)
@Injectable()
class MessageParser implements PipeTransform {
  List<InlineSyntax> inlineSyntaxes = <InlineSyntax>[];
  DomSanitizationService sanitizationService;

  MessageParser(this.sanitizationService, MentionSyntax mentionSyntax,
      EmoticonSyntax emoticonSyntax) {
    inlineSyntaxes = <InlineSyntax>[
      new TagSyntax(r'\*\*', tag: 'strong'),
      new TagSyntax(r'\*', tag: 'strong'),
      new TagSyntax(r'\~', tag: 'strike'),
      new TagSyntax(r'\b__', tag: 'em', end: r'__\b'),
      mentionSyntax,
      emoticonSyntax
    ];
  }

  SafeHtml transform(String message) {
    return sanitizationService.bypassSecurityTrustHtml(markdownToHtml(message,
        inlineSyntaxes: inlineSyntaxes,
        blockSyntaxes: [new FencedCodeBlockSyntax()]));
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
    var mention = new Element.text('strong', '@${user.name}');

    parser.addNode(mention);
    return true;
  }
}

@Injectable()
class EmoticonSyntax extends InlineSyntax {
  static const String emojisUrl = 'http://unicodey.com/emoji-data/img-apple-64';
  final SlackService slackService;

  EmoticonSyntax(this.slackService)
      : super(r':([a-zA-Z0-9_\+\-]+):(:([a-zA-Z0-9_\+\-]+):)?');

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
      img.attributes['src'] = "$emojisUrl/${Emojis.getChar(name)}.png";
    }

    img.attributes['alt'] = name;
    img.attributes['class'] = "emoji";
    img.attributes['onerror'] =
        "javascript:{var element = document.createElement('i'); element.innerText=':$name:';this.parentNode.replaceChild(element, this);}";
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
