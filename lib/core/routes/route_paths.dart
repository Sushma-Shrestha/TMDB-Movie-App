import 'package:movie_app/core/core.dart';

/// [RoutePaths] list of all routes
class RoutePaths {
  static final AppRouteModel splashRoute =
      AppRouteModel(routeName: 'splashPage', path: '/splashPage');
  static final AppRouteModel loginRoute =
      AppRouteModel(routeName: 'loginPage', path: '/loginPage');
  static final AppRouteModel signupRoute =
      AppRouteModel(routeName: 'signupPage', path: '/signupPage');
  static final AppRouteModel latestMovies =
      AppRouteModel(routeName: 'latest', path: '/latest');
  static final AppRouteModel movieDetail =
      AppRouteModel(routeName: 'details', path: ':id');
  static final AppRouteModel errorRoute =
      AppRouteModel(routeName: 'error', path: '/error');
  static final AppRouteModel favRoute =
      AppRouteModel(routeName: 'favourite', path: '/favourite');
}
