library frontend.app;

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'package:slack_history_keeper_frontend/components/search/search_component.dart';

@Component(selector: 'app')
@View(
    template: '<router-outlet></router-outlet>',
    directives: const [ROUTER_DIRECTIVES, SearchComponent])
@RouteConfig(
    const [const Route(path: '/', component: SearchComponent, name: 'Search')])
class App {
  App();
}
