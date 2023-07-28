/// App level configuration variables
class AppConfigs {
  /// The max allowed age duration for the http cache
  static const Duration maxCacheAge = Duration(minutes: 30);

  /// Key used in dio options to indicate whether
  /// cache should be force refreshed
  static const String dioCacheForceRefreshKey = 'dio_cache_force_refresh_key';

  /// Base API URL of MovieApp API
  static const String apiBaseUrl = 'https://api.themoviedb.org/3';

  static const String apiKey = 'c22cb132c84b67275dbecc83ff5b5405';

  static const String apiImageUrl = 'https://image.tmdb.org/t/p/w500';
}
