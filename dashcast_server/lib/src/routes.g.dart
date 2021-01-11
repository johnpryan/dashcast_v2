// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$DashcastServiceRouter(DashcastService service) {
  final router = Router();
  router.add('GET', r'/', service.index);
  router.add('GET', r'/all', service.all);
  router.add('GET', r'/podcast/<id>', service.getPodcastDetails);
  router.add('GET', r'/podcast/<id>/image', service.getPodcastImage);
  router.add('GET', r'/podcast/<id>/episode/<episodeId>/audio',
      service.getPodcastAudio);
  return router;
}
