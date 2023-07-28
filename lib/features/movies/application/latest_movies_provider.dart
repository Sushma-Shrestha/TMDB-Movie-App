import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/infrastructure/infrastructure.dart';

final latestMoviesProvider =
    StateProvider<PaginatedResponse<MovieModel>>((ref) {
  return const PaginatedResponse(page: 0, results: <MovieModel>[]);
});
