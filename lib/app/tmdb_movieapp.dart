import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';

/// Main App Widget
class MovieApp extends ConsumerWidget {
  /// Creates new instance of [MovieApp]
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeData = ref.watch(themeProvider);
    return MaterialApp.router(
      title: 'TMDB Movies App',
      debugShowCheckedModeBanner: false,
      themeMode: themeData.getCurrentThemeMode,
      theme: themeData.getLightThemeData,
      darkTheme: themeData.getDarkThemeData,
      routeInformationParser: goRouter.routeInformationParser,
      routeInformationProvider: goRouter.routeInformationProvider,
      routerDelegate: goRouter.routerDelegate,
    );
  }
}
