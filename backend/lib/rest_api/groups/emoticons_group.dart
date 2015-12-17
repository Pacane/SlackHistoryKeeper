part of rest_api;

@app.Group("$baseUrl/emoticons")
class EmoticonsGroup {
  final EmoticonsService emoticonsService;

  EmoticonsGroup(this.emoticonsService);

  @app.DefaultRoute(responseType: 'application/json')
  @Encode()
  List<Emoticon> getEmoticons() {
    return emoticonsService.fetchEmoticons();
  }
}