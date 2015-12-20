part of rest_api;

@app.Group("$baseUrl/users")
class UsersGroup {
  final UsersService usersService;

  UsersGroup(this.usersService);

  @app.DefaultRoute()
  List<User> getUsers() {
    return usersService.getUsers().map((User u) => JSON.encode(u)).toList();
  }
}
