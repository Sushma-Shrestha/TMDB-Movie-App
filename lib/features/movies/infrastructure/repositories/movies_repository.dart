import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/movies.dart';

/// Provider to map [MoviesRepository] implementation to
/// [MoviesRepositoryImpl] interface
final moviesRepositoryProvider = Provider<MoviesRepository>(
  (ref) {
    final httpService = ref.watch(httpServiceProvider);

    return MoviesRepositoryImpl(httpService);
  },
);

/// People repository interface
abstract class MoviesRepository {
  /// Request to get a person details endpoint
  Future<Either<PaginatedResponse<MovieModel>, Failure>> fetchLatestMovies({
    required int page,
    required bool forceRefresh,
    required String api_key,
  });

  Future<Either<MovieModel, Failure>> fetchMovieDetails(
    int movieId, {
    bool forceRefresh,
    required String api_key,
  });

  Future<Either<PaginatedResponse<MovieModel>, Failure>> fetchSuggestedMovies(
    int movieId, {
    bool forceRefresh = false,
    required String api_key,
  });

  Future<Either<PaginatedResponse<MovieModel>, Failure>> fetchSearchMovies({
    required int page,
    required bool forceRefresh,
    required String api_key,
    required String query,
  });
}
