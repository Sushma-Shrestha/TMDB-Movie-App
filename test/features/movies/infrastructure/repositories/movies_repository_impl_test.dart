import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/features/movies/infrastructure/infrastructure.dart';

void main() {
  test(
    'moviesRepositoryProvider is a MoviesRepository ',
    () async {
      final provider = ProviderContainer();
      addTearDown(provider.dispose);
      expect(
        provider.read(moviesRepositoryProvider),
        isA<MoviesRepositoryImpl>(),
      );
    },
  );
}
