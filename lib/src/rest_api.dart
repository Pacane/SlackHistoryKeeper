import 'package:redstone/redstone.dart' as app;

@app.Route("/")
helloWorld() => "Hello, World!";

startApiServer() {
  app.start();
}