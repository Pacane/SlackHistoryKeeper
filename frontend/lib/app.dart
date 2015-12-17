library frontend.app;

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'package:slack_history_keeper_frontend/components/search/search_component.dart';
import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:konami_code/konami_code.dart';
import 'package:slack_history_keeper_frontend/events/slack_data_loaded_event.dart';

import 'dart:html';

@Component(selector: 'app')
@View(
    template: '<router-outlet></router-outlet>',
    directives: const [ROUTER_DIRECTIVES, SearchComponent])
@RouteConfig(
    const [const Route(path: '/', component: SearchComponent, name: 'Search')])
class App implements OnInit, OnDestroy {
  final EventBus eventBus;

  StreamSubscription subscription;

  bool _loaded;
  Timer _loadTimer;

  App(this.eventBus) {
    subscription = eventBus.on(SlackDataLoadedEvent).listen(_onSlackDataLoaded);
    _loadTimer = new Timer(new Duration(seconds: 4), () {
      if (_loaded) {
        _setVisible();
      }
    });
  }

  void _setVisible() {
    var pageHeader = querySelector(".page-header");
    pageHeader
      ..classes.remove("is-loading")
      ..on["webkitAnimationIteration"].listen((e) => _removeAnimate(pageHeader))
      ..on["animationiteration"].listen((e) => _removeAnimate(pageHeader));

    querySelector(".page-holder").classes.add("is-visible");
  }

  void _removeAnimate(dynamic pageHeader) {
    pageHeader.classes.remove("animate");
  }

  void _onSlackDataLoaded(SlackDataLoadedEvent event) {
    _loaded = true;
    if (_loadTimer.isActive) {
      _loadTimer.cancel();
      _setVisible();
    }
  }

  @override
  ngOnInit() {
    var konami = new KonamiCode();
    konami.onPerformed.listen((_) {
      window.location.replace('http://meatspin.com');
    });
  }

  @override
  void ngOnDestroy() {
    subscription.cancel();
  }
}
