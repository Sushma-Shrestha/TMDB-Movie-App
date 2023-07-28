import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/movies.dart';

final latestMoviesController = StateNotifierProvider.autoDispose<
    MoviesController<PaginatedResponse<MovieModel>>, BaseState<dynamic>>(
  _moviesController,
);

final movieDetailsController = StateNotifierProvider.autoDispose<
    MoviesController<PaginatedResponse<MovieModel>>, BaseState<dynamic>>(
  _moviesController,
);
final suggestedMoviesController = StateNotifierProvider.autoDispose<
    MoviesController<PaginatedResponse<MovieModel>>, BaseState<dynamic>>(
  _moviesController,
);

MoviesController<T> _moviesController<T>(Ref ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return MoviesController<T>(ref);
}

class MoviesController<T> extends StateNotifier<BaseState<dynamic>> {
  ///
  MoviesController(this.ref, {this.cancelToken})
      : super(const BaseState<void>.initial());

  final CancelToken? cancelToken;

  final Ref ref;

  MoviesRepository get _moviesRepository => ref.read(moviesRepositoryProvider);

  /// [fetchLatestMovies] fetch latest movies based on filter query params
  Future<void> fetchLatestMovies({
    required int page,
    bool forceRefresh = true,
  }) async {
    if (page == 1) {
      state = const BaseState<void>.loading();
    }
    final response = await _moviesRepository.fetchLatestMovies(
      forceRefresh: forceRefresh,
      page: page,
      api_key: AppConfigs.apiKey,
    );

    state = response.fold(
      (success) {
        final previousData = ref.read(latestMoviesProvider);

        ref.read(latestMoviesProvider.notifier).state =
            ref.read(latestMoviesProvider).copyWith(
                  // limit: success.limit,
                  page: success.page,
                  nextPage: success.page + 1,
                  totalResults: success.totalResults,
                  results: [...previousData.results, ...success.results]
                      .unique((element) => element.id),
                  isEnd: success.totalPages == success.page,
                );
        return BaseState<PaginatedResponse<MovieModel>>.success(data: success);
      },
      BaseState.error,
    );
  }

  /// [fetchMovieDetails] fetch movie details based on [movieId]
  Future<void> fetchMovieDetails(
    int movieId, {
    bool forceRefresh = false,
  }) async {
    state = const BaseState<void>.loading();
    final response = await _moviesRepository.fetchMovieDetails(
      movieId,
      forceRefresh: forceRefresh,
      api_key: AppConfigs.apiKey,
    );
    state = response.fold(
      (success) {
        return BaseState<MovieModel>.success(data: success);
      },
      BaseState.error,
    );
  }

  /// [fetchSearchMovies] fetch movies based on [query]
  Future<void> fetchSearchMovies({
    required int page,
    bool forceRefresh = true,
    String query = '',
  }) async {
    if (page == 1) {
      state = const BaseState<void>.loading();
    }
    final response = await _moviesRepository.fetchSearchMovies(
      forceRefresh: forceRefresh,
      page: page,
      api_key: AppConfigs.apiKey,
      query: query,
    );

    state = response.fold(
      (success) {
        // final previousData = ref.read(latestMoviesProvider);
        ref.read(latestMoviesProvider.notifier).state =
            ref.read(latestMoviesProvider).copyWith(
                  // limit: success.limit,
                  page: success.page,
                  nextPage: success.page + 1,
                  totalResults: success.totalResults,
                  results: [...success.results].unique((element) => element.id),
                  isEnd: success.totalPages == success.page,
                );
        return BaseState<PaginatedResponse<MovieModel>>.success(data: success);
      },
      BaseState.error,
    );
  }
}
