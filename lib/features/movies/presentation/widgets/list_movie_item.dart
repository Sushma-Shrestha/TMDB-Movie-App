import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/movies.dart';

class ListMovieItem extends ConsumerWidget {
  const ListMovieItem({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = ref.watch(currentMovieItemProvider);
    // final qualityList = movie.torrents.map((e) => e.quality).toList();
    final size = MediaQuery.of(context).size;
    return Container(
      // width: size.width / 1.5,
      // height: size.width / 1.5,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            RoutePaths.movieDetail.routeName,
            params: {
              'id': '${movie.id}',
            },
            extra: movie.posterPath,
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Hero(
                  tag: 'movie_${movie.id}_cover_image',
                  child: AppCachedNetworkImage(
                    width: size.width / 1.5,
                    height: size.width / 1.5,
                    imageUrl: AppConfigs.apiImageUrl + movie.posterPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                  children: [
                    TextSpan(
                      text: '[${movie.originalLanguage.toUpperCase()}] ',
                    ),
                    TextSpan(
                      text: movie.originalTitle,
                    ),
                  ],
                ),
              ),
              Text(
                movie.releaseDate,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
