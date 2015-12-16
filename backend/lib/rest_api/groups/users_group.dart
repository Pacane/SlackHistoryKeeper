part of rest_api;

@app.Group("$baseUrl/users")
class UsersGroup {
  final UsersService usersService;

  UsersGroup(this.usersService);

  @app.DefaultRoute()
  @Encode()
  Future<List<User>> getUsers() {
    return usersService.fetchUsersFromSlackApi();
  }
}
