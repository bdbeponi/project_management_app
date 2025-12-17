import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_management/app/router/config/navigation_service.dart';
import 'package:project_management/shared/networks/dio/interceptor/log.dart';

import '../../utils/logger.dart';

final locator = GetIt.instance;

final hiveBox = locator<Box>();
CustomLogger get logger => locator<CustomLogger>();

Future<void> diSetup() async {
  await Hive.initFlutter();

  locator
    // ..registerLazySingleton(() => FirebaseMessaging.instance)
    // ..registerSingleton<GetStorage>(GetStorage())
    ..registerSingleton<CustomLogger>(CustomLogger())
    ..registerSingleton<NavigationService>(NavigationService())
    ..registerSingleton<Box>(await Hive.openBox("hive_app"))
    // NEW: Dio configured with our interceptor
    ..registerSingleton<Dio>(() {
      final dio = Dio();
      dio.interceptors.add(DioLogger());
      // dio.interceptors.add(DioLogger(level: LogLevel.verbose));
      return dio;
    }());

  logger.info("✅ DI Setup Completed");
}
