import 'package:slack_history_keeper_frontend/services/slack_service.dart';
import 'package:angular2/core.dart' show Pipe;
import 'package:angular2/angular2.dart';
import 'package:markdown/markdown.dart';

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
  final SlackService slackService;

  EmoticonSyntax(this.slackService) : super(r':([a-z_0-9]+):');

  @override
  bool onMatch(InlineParser parser, Match match) {
    var name = match.group(1);
    var emoticon = slackService.getEmoticonFromName(name);
    if(emoticon != null) {
      var img = new Element.withTag('img');
      img.attributes['src'] = emoticon.url;
      img.attributes['alt'] = emoticon.name;

      parser.addNode(img);
      return true;
    }

    return false;
  }
}
