import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/infrastructure/infrastructure.dart';

final favouriteProvider = StateProvider<Favourite>((ref) {
  return const Favourite(movieId: <MovieInfo>[], uid: '');
});
