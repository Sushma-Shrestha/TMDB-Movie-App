import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/infrastructure/models/favourite_model.dart';
import 'package:movie_app/features/movies/infrastructure/repositories/favourite_repository_impl.dart';

/// Provider to map [FavouriteRepository] implementation to
/// [FavouriteRepositoryImpl] interface
final FavouriteRepositoryProvider = Provider<FavouriteRepository>(
  (ref) {
    final httpService = ref.watch(httpServiceProvider);

    return FavouriteRepositoryImpl(httpService);
  },
);

/// People repository interface
abstract class FavouriteRepository {
  /// Request to get a person details endpoint
  Future<Either<Favourite, Failure>> fetchfavourites({
    required String uid,
    required bool forceRefresh,
  });
  Future<Either<void, Failure>> postfavourites({
    required String uid,
    required List<MovieInfo> movie,
  });
  Future<Either<void, Failure>> removefavourites({
    required String uid,
    required List<MovieInfo> movieId,
  });
}
