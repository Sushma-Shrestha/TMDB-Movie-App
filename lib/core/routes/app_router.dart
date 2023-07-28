import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/auth/auth.dart';
import 'package:movie_app/features/movies/movies.dart';
import 'package:movie_app/features/movies/presentation/pages/favourite_page.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authStatusProvider);
    final key = GlobalKey<NavigatorState>();
    return GoRouter(
      initialLocation: RoutePaths.splashRoute.path,
      navigatorKey: key,
      routes: [
        GoRoute(
          path: RoutePaths.splashRoute.path,
          name: RoutePaths.splashRoute.routeName,
          pageBuilder: (context, state) => FadeTransitionPage(
            key: state.pageKey,
            child: const SplashScreen(),
          ),
          // redirect: (_, __) => RoutePaths.loginRoute.path,
        ),
        GoRoute(
          path: RoutePaths.loginRoute.path,
          name: RoutePaths.loginRoute.routeName,
          pageBuilder: (context, state) => FadeTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.signupRoute.path,
          name: RoutePaths.signupRoute.routeName,
          pageBuilder: (context, state) => FadeTransitionPage(
            key: state.pageKey,
            child: const SignupScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.favRoute.path,
          name: RoutePaths.favRoute.routeName,
          pageBuilder: (context, state) => FadeTransitionPage(
            key: state.pageKey,
            child: const FavouriteList(),
          ),
        ),
        GoRoute(
          path: RoutePaths.latestMovies.path,
          name: RoutePaths.latestMovies.routeName,
          pageBuilder: (context, state) => FadeTransitionPage(
            key: state.pageKey,
            child: const LatestMoviesPage(),
          ),
          routes: [
            GoRoute(
              path: RoutePaths.movieDetail.path,
              name: RoutePaths.movieDetail.routeName,
              pageBuilder: (context, state) => FadeTransitionPage(
                key: state.pageKey,
                child: ProviderScope(
                  overrides: [
                    currentMovieDetailItemProvider
                        .overrideWithValue(state.extra! as MovieModel)
                  ],
                  child: const MovieDetailPage(),
                ),
              ),
            ),
          ],
        ),
      ],
      refreshListenable: authState,
      redirect: (BuildContext context, GoRouterState state) {
        final authenticated = authState.loggedInStatus;

        final isSplash = state.location == RoutePaths.splashRoute.path;

        if (isSplash) {
          return authenticated
              ? RoutePaths.latestMovies.path
              : RoutePaths.loginRoute.path;
        }

        if (state.subloc == RoutePaths.signupRoute.path) {
          return RoutePaths.signupRoute.path;
        }

        final isLoggingIn = state.location == RoutePaths.loginRoute.path;
        if (isLoggingIn) {
          return authenticated ? RoutePaths.latestMovies.path : null;
        }
        return null;
      },
      debugLogDiagnostics: kDebugMode,
    );
  },
);

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required LocalKey super.key,
    required super.child,
  }) : super(
          transitionsBuilder: (c, animation, a2, child) => FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
            child: child,
          ),
        );
}
