import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/movies.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  const MovieDetailPage({
    super.key,
  });

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final movieId = ref.read(currentMovieDetailItemProvider).id;
      ref.read(movieDetailsController.notifier).fetchMovieDetails(movieId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movieItem = ref.watch(currentMovieDetailItemProvider);
    final movieDetailState = ref.watch(movieDetailsController);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            leading: const AdaptiveBackBtn(),
            pinned: true,
            flexibleSpace: Hero(
              tag: 'movie_${movieItem.id}_cover_image',
              transitionOnUserGestures: true,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppCachedNetworkImage(
                    imageUrl: AppConfigs.apiImageUrl + movieItem.posterPath,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                movieDetailState.maybeMap(
                  initial: (_) => CustomShimmer(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                  success: (value) {
                    final movie = value.data as MovieModel;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            movie.releaseDate,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_outline_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                movie.popularity.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.star_border_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 28,
                              ),
                              Text(
                                '${movie.voteAverage} / 10',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Summary :'.hardcoded,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                          ),
                          Text(
                            movie.overview,
                            maxLines: 50,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                  error: (_) => const ErrorView(),
                  loading: (_) => CustomShimmer(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                  orElse: () => CustomShimmer(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension GetGenresString on List<String> {
  String get getGenresString => join(' / ');
}
