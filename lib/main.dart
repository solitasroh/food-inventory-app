import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/inventory/data/datasources/food_item_local_datasource.dart';
import 'features/inventory/data/repositories/food_item_repository_impl.dart';
import 'features/inventory/domain/repositories/food_item_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 메모리 기반 DataSource 사용 (Isar 대신)
  final localDataSource = FoodItemMemoryDataSource();
  final repository = FoodItemRepositoryImpl(localDataSource);

  runApp(
    ProviderScope(
      overrides: [
        foodItemRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MainApp(),
    ),
  );
}

// Provider
final foodItemRepositoryProvider = Provider<FoodItemRepository>((ref) {
  throw UnimplementedError('Repository must be initialized before use');
});

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: '식재료 관리',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: router,
        );
      },
    );
  }
}
