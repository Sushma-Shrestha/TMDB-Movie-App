import 'package:dartz/dartz.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/movies.dart';

/// Http implementation of [MoviesRepositoryImpl]
class MoviesRepositoryImpl implements MoviesRepository {
  /// Creates a new instance of [MoviesRepositoryImpl]
  MoviesRepositoryImpl(this.httpService);

  /// Http service used to access an Http client and make calls
  final HttpService httpService;

  @override
  Future<Either<PaginatedResponse<MovieModel>, Failure>> fetchLatestMovies({
    required int page,
    required bool forceRefresh,
    required String api_key,
  }) async {
    final responseData = await httpService.get(
      Endpoints.latestMoviesEndpoint,
      forceRefresh: forceRefresh,
      queryParameters: <String, dynamic>{
        'page': page,
        // 'limit': limit,
        'api_key': AppConfigs.apiKey,
      },
    );
    return responseData.fold(
      (success) {
        try {
          final parsedResponse = PaginatedResponse.fromJson(
            success,
            results: List<MovieModel>.from(
              (success['results'] as List<dynamic>)
                  .map((e) => MovieModel.fromJson(e as Map<String, dynamic>)),
            ),
          );

          return Left(parsedResponse);
        } catch (e) {
          return Right(Failure.fromException(e));
        }
      },
      Right.new,
    );
  }

  @override
  Future<Either<MovieModel, Failure>> fetchMovieDetails(
    int movieId, {
    bool forceRefresh = false,
    String api_key = AppConfigs.apiKey,
  }) async {
    final responseData = await httpService.get(
      '${Endpoints.movieDetailsEndpoint}$movieId',
      forceRefresh: forceRefresh,
      queryParameters: <String, dynamic>{
        'api_key': AppConfigs.apiKey,
      },
    );

    return responseData.fold(
      (success) {
        try {
          final parsedData = MovieModel.fromJson(
            success,
          );
          return Left(parsedData);
        } catch (e) {
          return Right(Failure.fromException(e));
        }
      },
      Right.new,
    );
  }

  @override
  Future<Either<PaginatedResponse<MovieModel>, Failure>> fetchSuggestedMovies(
    int movieId, {
    bool forceRefresh = false,
    String api_key = AppConfigs.apiKey,
  }) async {
    final responseData = await httpService.get(
      '${Endpoints.suggestedMoviesEndpoint}$movieId/recommendations',
      forceRefresh: forceRefresh,
      queryParameters: <String, dynamic>{
        'id': movieId,
        'api_key': AppConfigs.apiKey,
      },
    );
    return responseData.fold(
      (success) {
        try {
          final additionalParams = <String, dynamic>{
            'page': 0,
            // 'limit': 20,
          };
          success.addAll(additionalParams);
          // );
          final parsedResponse = PaginatedResponse.fromJson(
            success,
            results: List<MovieModel>.from(
              (success['results'] as List<dynamic>)
                  .map((e) => MovieModel.fromJson(e as Map<String, dynamic>)),
            ),
          );

          return Left(parsedResponse);
        } catch (e) {
          return Right(Failure.fromException(e));
        }
      },
      Right.new,
    );
  }

  @override
  Future<Either<PaginatedResponse<MovieModel>, Failure>> fetchSearchMovies({
    required int page,
    required bool forceRefresh,
    required String api_key,
    required String query,
  }) async {
    final responseData = await httpService.get(
      query == ''
          ? Endpoints.latestMoviesEndpoint
          : Endpoints.searchMoviesEndpoint,
      forceRefresh: forceRefresh,
      queryParameters: <String, dynamic>{
        'page': page,
        // 'limit': limit,
        'api_key': AppConfigs.apiKey,
        'query': query,
      },
    );
    return responseData.fold(
      (success) {
        try {
          final parsedResponse = PaginatedResponse.fromJson(
            success,
            results: List<MovieModel>.from(
              (success['results'] as List<dynamic>)
                  .map((e) => MovieModel.fromJson(e as Map<String, dynamic>)),
            ),
          );

          return Left(parsedResponse);
        } catch (e) {
          return Right(Failure.fromException(e));
        }
      },
      Right.new,
    );
  }
}
