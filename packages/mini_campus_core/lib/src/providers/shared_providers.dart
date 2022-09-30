import 'package:deta_data_source/deta_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_components/mini_campus_components.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_services/mini_campus_services.dart';

/// shared pref providers
final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

/// timer provider
final clockProvider =
    StateNotifierProvider.autoDispose<Clock, int?>((_) => Clock());

/// app [ThemeMode] provider
final themeNotifierProvider = StateProvider<ValueNotifier<ThemeMode>>((ref) {
  final pref = ref.watch(sharedPreferencesServiceProvider);

  final isLightMode = pref.getCurrentUserTheme();

  if (isLightMode == null) {
    return ValueNotifier(ThemeMode.system);
  }

  return isLightMode
      ? ValueNotifier(ThemeMode.light)
      : ValueNotifier(ThemeMode.dark);
});

/// [AppDialog] instance provider using riverpod
final dialogProvider = Provider((_) => AppDialog());

/// configurations provided based on flavor
final flavorConfigProvider = StateProvider<Map<String, dynamic>>((_) => {});

/// [FacultyRepository] provider
final facultyRepositoryProvider = Provider((_) {
  final configs = _.watch(flavorConfigProvider);
  return FacultyRepository(configs);
});

/// [FirebaseAuthService] provider DI
final firebaseAuthServiceProvider = Provider((_) => FirebaseAuthService());

/// [GoogleSignInService] provider DI
final googleAuthProvider = Provider((_) => GoogleSignInService());

/// general app user
final fbAppUserProvider = StateProvider<AppFbUser?>((ref) => null);

/// currently logged in student
final studentProvider = StateProvider<Student?>((ref) => null);

/// currently logged in student Uni
final studentUniProvider = StateProvider<Uni>((ref) => Uni.nust);

/// [DetaStorageRepository] provider, DI
final detaStorageProvider =
    ProviderFamily<DetaStorageRepository, DetaDriveInit>((ref, detaDriveInit) {
  final configs = ref.watch(flavorConfigProvider);
  return DetaStorageRepository(configs, detaDriveInit);
});

/// deta file downloader provider
final detaStorageFileDownloaderProvider =
    FutureProviderFamily<dynamic, DetaDriveInit>((ref, detaDriveInit) {
  final configs = ref.watch(flavorConfigProvider);
  return DetaStorageRepository(configs, detaDriveInit)
      .download(detaDriveInit.filename!);
});
