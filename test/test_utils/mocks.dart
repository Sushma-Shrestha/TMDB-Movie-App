import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/movies/movies.dart';

class MockStorageService extends Mock implements StorageService {}

class MockHttpService extends Mock implements HttpService {}

class MockMoviesRepository extends Mock implements MoviesRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T value);
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoute extends Mock implements Route<dynamic> {}
