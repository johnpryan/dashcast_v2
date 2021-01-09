import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models.dart';

part 'routes.g.dart';

class DashcastService {
  List<Podcast> podcasts = [
    // Podcast(id: 0, title: 'The Daily', imageUrl: ),
  ];

  Router get router => _$DashcastServiceRouter(this);

  @Route.get('/')
  Future<Response> index(Request request) async {
    return Response(200, body: 'DashCast', headers: {});
  }

  @Route.get('/all')
  Future<Response> all(Request request) async {
    return Response(200, body: 'all', headers: {});
  }
}
