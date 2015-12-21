part of rest_api;

@app.Group("$baseUrl/users")
class UsersGroup {
  final UsersService usersService;

  UsersGroup(this.usersService);

  @app.DefaultRoute(responseType: 'application/json')
  List<User> getUsers() {
    return usersService
        .getUsers()
        .toList();
  }
}
