import 'package:angular2/bootstrap.dart';
import 'package:angular2/router.dart';
import 'package:slack_history_keeper_frontend/app.dart';

main() => bootstrap(App, [
  ROUTER_BINDINGS,
  bind(APP_BASE_HREF).toValue('/'),
  bind(LocationStrategy).toClass(HashLocationStrategy)
]);
