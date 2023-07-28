import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/movies.dart';

class SearchMoviesGridView extends ConsumerStatefulWidget {
  final String? query;
  const SearchMoviesGridView({super.key, this.query = ""});

  @override
  ConsumerState<SearchMoviesGridView> createState() =>
      _SearchMoviesGridViewState();
}

class _SearchMoviesGridViewState extends ConsumerState<SearchMoviesGridView> {
  late final RefreshController _refreshController;
  @override
  void initState() {
    _refreshController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(latestMoviesController.notifier).fetchSearchMovies(
            page: 1,
            query: widget.query ?? '',
          );
    });
    super.initState();
  }

  void onRefresh() {
    _refreshController.requestRefresh();
    ref.read(latestMoviesController.notifier).fetchSearchMovies(
          forceRefresh: true,
          page: 1,
          query: widget.query ?? '',
        );
    _refreshController.refreshCompleted();
  }

  Future<void> onLoading() async {
    await _refreshController.requestLoading();
    final page = ref.read(latestMoviesProvider).page + 1;
    await ref.read(latestMoviesController.notifier).fetchSearchMovies(
          page: page,
          forceRefresh: true,
          query: widget.query ?? '',
        );
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final latestMoviesState = ref.watch(latestMoviesController);
    final scrollController = ref.watch(moviesScrollControllerProvider);
    return latestMoviesState.map(
      initial: (_) => const ListItemShimmer(),
      loading: (_) => const ListItemShimmer(),
      success: (success) {
        final movieList = ref.watch(latestMoviesProvider);
        return SmartRefresher(
          controller: _refreshController,
          onRefresh: onRefresh,
          // onLoading: onLoading,
          // enablePullUp: !movieList.isEnd,
          child: GridView.builder(
            itemCount: movieList.results.length,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 8,
              childAspectRatio: 6 / 9,
            ),
            itemBuilder: (context, index) {
              final currentItemData = movieList.results[index];
              return ProviderScope(
                overrides: [
                  currentMovieItemProvider.overrideWithValue(currentItemData)
                ],
                child: const GridMovieItem(),
              );
            },
          ),
        );
      },
      error: (_) => const ErrorView(),
    );
  }
}
