part of rest_api;

@app.Group("/")
class CORSInterceptor {
  @app.Interceptor(r'/.*')
  handleCORS() async {
    if (app.request.method != "OPTIONS") {
      await app.chain.next();
    }
    return app.response.change(headers: _createCorsHeader());
  }

  _createCorsHeader() => {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'PUT, GET, POST, OPTIONS, DELETE',
    'Access-Control-Allow-Headers':
    'Origin, X-Requested-With, Content-Type, Accept'
  };
}

