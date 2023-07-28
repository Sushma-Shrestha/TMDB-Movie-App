import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/core/core.dart';

/// Provider that locates an [StorageService] interface to implementation
final storageServiceProvider = Provider<StorageService>(
  (_) => HiveStorageService(),
);
