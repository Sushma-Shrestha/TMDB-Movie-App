import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/auth/auth.dart';
import 'package:movie_app/features/movies/application/favourite_controlller.dart';
import 'package:movie_app/features/movies/application/favourite_provider.dart';
import 'package:movie_app/features/movies/movies.dart';

class GridMovieItem extends ConsumerStatefulWidget {
  const GridMovieItem({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GridMovieItemState();
}

class _GridMovieItemState extends ConsumerState<GridMovieItem> {
  @override
  void initState() {
    final uid = ref.read(authStatusProvider).user?.uid;
    uid != null
        ? WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            ref.read(latestFavouriteController.notifier).fetchfavourites(
                  uid,
                  context,
                );
          })
        : null;
    super.initState();
  }

  void addfavourite(String? uid, String id, String title, String image) async {
    final movieInfo = MovieInfo(
      id: id,
      title: title,
      image: image,
    );
    uid != null
        ? await ref.read(addFavouriteController.notifier).postfavourites(
              uid,
              [movieInfo],
              context,
            )
        : null;
  }

  bool isPresent(int movieInfo) {
    final favitems = ref.watch(favouriteProvider);
    for (var i = 0; i < favitems.movieId.length; i++) {
      if (favitems.movieId[i].id == movieInfo.toString()) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final movie = ref.watch(currentMovieItemProvider);
    final favitems = ref.watch(favouriteProvider);
    final size = MediaQuery.of(context).size;
    final uid = ref.read(authStatusProvider).user?.uid;
    return Container(
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
            extra: movie,
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
                    width: size.width / 2,
                    imageUrl: AppConfigs.apiImageUrl + movie.posterPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: size.width / 4 + 20,
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            children: [
                              TextSpan(
                                text:
                                    '[${movie.originalLanguage.toUpperCase()}] ',
                              ),
                              TextSpan(
                                text: movie.originalTitle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      uid != null
                          ? addfavourite(
                              uid,
                              movie.id.toString(),
                              movie.title,
                              movie.posterPath,
                            )
                          : context.pushNamed(RoutePaths.loginRoute.routeName);
                      // addfavourite(
                      //   uid,
                      //   movie.id.toString(),
                      // );
                    },
                    icon: (isPresent(movie.id))
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border),
                  )
                ],
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
