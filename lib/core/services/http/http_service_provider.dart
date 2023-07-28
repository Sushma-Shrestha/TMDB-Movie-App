import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';

/// Provider that maps an [HttpService] interface to implementation
final httpServiceProvider = Provider<HttpService>((ref) {
  final storageService = ref.watch(storageServiceProvider);

  return DioHttpService(storageService);
});
