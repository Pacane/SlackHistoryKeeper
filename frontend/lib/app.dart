library frontend.app;

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'package:slack_history_keeper_frontend/components/about/about.dart';
import 'package:slack_history_keeper_frontend/components/home/home.dart';
import 'package:slack_history_keeper_frontend/components/search/search.dart';

@Component(selector: 'app')
@View(
    template: '''
    <nav class="is-hidden">
      <a [routerLink]="['/Search']">Search</a>
      <a [routerLink]="['/Home']">Home</a>
      <a [routerLink]="['/About']">About</a>
    </nav>
    <router-outlet></router-outlet>
    ''',
    directives: const [ROUTER_DIRECTIVES, Search, Home, About])
@RouteConfig(const [
    const Route(path: '/home', component: Home, name: 'Home'),
    const Route(path: '/about', component: About, name: 'About'),
    const Route(path: '/', component: Search, name: 'Search')
])
class App {}
