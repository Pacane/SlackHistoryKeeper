part of rest_api;

@app.Group("$baseUrl/messages")
class MessagesGroup {
  final MessagesService messageService;

  MessagesGroup(this.messageService);

  @app.DefaultRoute(responseType: "application/json")
  Future<List<Map>> getMessages(@app.QueryParam("q") String query) async {
    List<String> channelIds = app.request.queryParameters.get('c', []);
    List<String> userIds = app.request.queryParameters.get('u', []);
    var messages =
        await messageService.fetchMessages(query, channelIds, userIds);

    return messages.map((Message m) => JSON.encode(m)).toList();
  }
}
