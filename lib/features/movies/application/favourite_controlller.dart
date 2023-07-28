import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/movies.dart';

final latestFavouriteController =
    StateNotifierProvider<FavouriteController<Favourite>, BaseState<dynamic>>(
  _favouriteController,
);

final addFavouriteController = StateNotifierProvider.autoDispose<
    FavouriteController<Favourite>, BaseState<dynamic>>(
  _favouriteController,
);

FavouriteController<T> _favouriteController<T>(Ref ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return FavouriteController<T>(ref);
}

class FavouriteController<T> extends StateNotifier<BaseState<dynamic>> {
  ///
  FavouriteController(this.ref, {this.cancelToken})
      : super(const BaseState<void>.initial());

  final CancelToken? cancelToken;

  final Ref ref;

  FavouriteRepository get _favouriteRepository =>
      ref.read(FavouriteRepositoryProvider);

  /// [postfavourites] add favourites
  Future<void> postfavourites(
    String uid,
    List<MovieInfo> movie,
    BuildContext context,
  ) async {
    Either<void, Failure> res;
    final favourite = ref.read(favouriteProvider);
    var isPresent = false;
    for (var i = 0; i < favourite.movieId.length; i++) {
      if (favourite.movieId[i].id == movie[0].id) {
        isPresent = true;
        break;
      }
    }
    if (isPresent) {
      res = await _favouriteRepository.removefavourites(
        uid: uid,
        movieId: movie,
      );
    } else {
      res = await _favouriteRepository.postfavourites(uid: uid, movie: movie);
    }
    res.fold((l) {
      if (isPresent) {
        context.showSnackbar('Favourite removed successfully!');
      } else {
        context.showSnackbar('Favourite added successfully!');
      }
      _favouriteRepository.fetchfavourites(uid: uid, forceRefresh: true);
      ref.read(favouriteProvider.notifier).state = favourite.copyWith(
        movieId: res.fold(
          (success) {
            if (isPresent) {
              final movieId = <MovieInfo>[];
              for (var i = 0; i < favourite.movieId.length; i++) {
                if (favourite.movieId[i].id != movie[0].id) {
                  movieId.add(favourite.movieId[i]);
                }
              }
              return movieId;
            } else {
              return [...favourite.movieId, ...movie];
            }
          },
          (_) =>
              favourite.movieId, // Return the original movieId list on failure
        ),
      );
    }, (r) {
      context.showSnackbar('Something went wrong!', isError: true);
    });
  }

  /// [fetchfavourites] fetch favourites
  Future<void> fetchfavourites(
    String uid,
    BuildContext context,
  ) async {
    final res = await _favouriteRepository.fetchfavourites(
      uid: uid,
      forceRefresh: true,
    );
    state = res.fold(
      (success) {
        ref.read(favouriteProvider.notifier).state = ref
            .read(favouriteProvider)
            .copyWith(uid: success.uid, movieId: success.movieId);
        return BaseState<Favourite>.success(data: success);
      },
      BaseState.error,
    );
  }
}
