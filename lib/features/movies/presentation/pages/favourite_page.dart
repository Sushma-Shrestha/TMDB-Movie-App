import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/auth/application/application.dart';
import 'package:movie_app/features/movies/application/favourite_controlller.dart';
import 'package:movie_app/features/movies/movies.dart';

class FavouriteList extends ConsumerStatefulWidget {
  const FavouriteList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavouriteListState();
}

class _FavouriteListState extends ConsumerState<FavouriteList> {
  @override
  Widget build(BuildContext context) {
    final favItems = ref.watch(favouriteProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite'),
      ),
      body: favItems.movieId.length > 0
          ? ListView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              itemBuilder: (context, index) => FavItemTile(
                favItems.movieId[index].id,
                favItems.movieId[index].title,
                favItems.movieId[index].image,
              ),
              itemCount: favItems.movieId.length,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border_outlined, size: 50),
                  const Text('No Favourite Items'),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(RoutePaths.latestMovies.routeName);
                    },
                    child: const Text('Explore Movies'),
                  )
                ],
              ),
            ),
    );
  }
}

class FavItemTile extends ConsumerStatefulWidget {
  const FavItemTile(this.id, this.title, this.image, {super.key});
  final String id;
  final String title;
  final String image;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavItemTileState();
}

class _FavItemTileState extends ConsumerState<FavItemTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movie = MovieModel(
      id: int.parse(widget.id),
      title: widget.title,
      posterPath: widget.image,
    );
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.pushNamed(
                RoutePaths.movieDetail.routeName,
                params: {
                  'id': widget.id,
                },
                extra: movie,
              );
            },
            child: Row(
              children: [
                AppCachedNetworkImage(
                  imageUrl: AppConfigs.apiImageUrl + widget.image,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await ref.read(latestFavouriteController.notifier).postfavourites(
                    ref.read(authStatusProvider).user?.uid ?? '',
                    [
                      MovieInfo(
                        id: widget.id,
                        title: widget.title,
                        image: widget.image,
                      )
                    ],
                    context,
                  );
            },
          ),
        ],
      ),
    );
  }
}
