library frontend.components.about;

import 'package:angular2/angular2.dart';

@Component(selector: 'about')
@View(
    template: '''
    <p>
      See <a href="https://github.com/ng2-dart-samples/">ng2-dart-samples</a>
      for more Angular 2 samples!
    </p>
    ''')
class About {}