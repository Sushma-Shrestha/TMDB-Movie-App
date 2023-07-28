import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/movies.dart';

/// The provider that provides the movie data for each grid item
///
/// Initially it throws an UnimplementedError because we won't use it
/// before overriding it
///

final currentMovieItemProvider = Provider<MovieModel>(
  (ref) => throw UnimplementedError(),
);

final currentMovieDetailItemProvider = Provider<MovieModel>(
  (ref) => throw UnimplementedError(),
);

final movieDetailsControllerProvider =
    FutureProvider.family<MovieModel, String>((ref, movieId) async {
  final movieDetails = ref
      .read(movieDetailsController.notifier)
      .fetchMovieDetails(int.parse(movieId));

  return movieDetails as MovieModel;
});
