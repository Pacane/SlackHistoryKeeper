part of rest_api;

@app.Group("$baseUrl/channels")
class ChannelsGroup {
  final ChannelsService channelsService;

  ChannelsGroup(this.channelsService);

  @app.DefaultRoute(responseType: 'application/json')
  List<Map> getChannels() {
    return channelsService
        .getChannels()
        .map((Channel c) => JSON.encode(c))
        .toList();
  }
}
