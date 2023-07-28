import 'package:equatable/equatable.dart';

/// Model representing a paginated TMDB http response
class PaginatedResponse<T> extends Equatable {
  /// Creates new instance of [PaginatedResponse]
  const PaginatedResponse({
    required this.page,
    this.nextPage,
    this.results = const [],
    this.totalResults = 1,
    this.totalPages = 1,
    // this.limit = 20,
    this.isEnd = false,
  });

  /// Creates new instance of [PaginatedResponse] parsed from raw dara
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json, {
    List<T>? results,
  }) {
    return PaginatedResponse<T>(
      page: json['page'] as int,
      results: results ?? <T>[],
      totalResults: json['total_results'] as int,
      totalPages: json['total_pages'] as int,
      // ignore: avoid_dynamic_calls
      // nextPage: json['page'] + 1 as int,
      // limit: json['limit'] as int,
    );
  }

  /// Page number
  final int page;

  /// Next page number
  final int? nextPage;

  /// List of results of the current page
  final List<T> results;

  /// Total number of results in all pages
  final int totalResults;
  final int totalPages;

  /// Item limit per page
  // final int limit;

  final bool isEnd;

  @override
  List<Object?> get props =>
      [page, results, totalResults, totalPages, nextPage, isEnd];

  @override
  bool get stringify => true;

  PaginatedResponse<T> copyWith({
    int? page,
    int? nextPage,
    List<T>? results,
    int? totalResults,
    int? totalPages,
    // int? limit,
    bool? isEnd,
  }) {
    return PaginatedResponse<T>(
      page: page ?? this.page,
      nextPage: page ?? this.nextPage,
      results: results ?? this.results,
      totalResults: totalResults ?? this.totalResults,
      totalPages: totalPages ?? this.totalResults,
      // limit: limit ?? this.limit,
      isEnd: isEnd ?? this.isEnd,
    );
  }
}
