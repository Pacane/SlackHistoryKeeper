part of rest_api;

@app.Group("$baseUrl/channels")
class ChannelsGroup {
  final ChannelsService channelsService;

  ChannelsGroup(this.channelsService);

  @app.DefaultRoute(responseType: 'application/json')
  @Encode()
  Future<List<Channel>> getChannels() {
    return channelsService.fetchChannelsFromSlackApi();
  }
}