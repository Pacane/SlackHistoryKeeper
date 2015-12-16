part of rest_api;

@app.Group("$baseUrl/messages")
class MessagesGroup {
  final MessagesService messageService;

  MessagesGroup(this.messageService);

  @app.DefaultRoute()
  @Encode()
  Future<List<Message>> getMessages(@app.QueryParam("q") String query) {
    List<String> channelIds = app.request.queryParameters.get('c', []);
    List<String> userIds = app.request.queryParameters.get('u', []);

    return messageService.fetchMessages(query, channelIds, userIds);
  }
}
