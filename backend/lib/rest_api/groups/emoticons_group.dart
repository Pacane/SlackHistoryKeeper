part of rest_api;

@app.Group("$baseUrl/emoticons")
class EmoticonsGroup {
  final EmoticonsService emoticonsService;

  EmoticonsGroup(this.emoticonsService);

  @app.DefaultRoute(responseType: 'application/json')
  List<Map> getEmoticons() {
    return emoticonsService
        .fetchEmoticons()
        .map((Emoticon e) => JSON.encode(e))
        .toList();
  }
}
