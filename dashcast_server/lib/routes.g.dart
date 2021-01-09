// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$MyServiceRouter(MyService service) {
  final router = Router();
  router.add('GET', r'/', service.index);
  router.add('GET', r'/users/<userId>', service.user);
  return router;
}
