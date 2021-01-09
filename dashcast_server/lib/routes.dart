import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'routes.g.dart';

class MyService {
  Router get router => _$MyServiceRouter(this);

  @Route.get('/')
  Future<Response> index(Request request) async {
    return Response(200, body: 'Home page', headers: {});
  }

  @Route.get('/users/<userId>')
  Future<Response> user(Request request, String userId) async {
    return Response(200, body: 'User $userId', headers: {});
  }
}
