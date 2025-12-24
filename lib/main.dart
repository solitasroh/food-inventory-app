import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/database/database_helper.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/inventory/data/datasources/food_item_local_datasource.dart';
import 'features/inventory/data/datasources/food_item_sqlite_datasource.dart';
import 'features/inventory/data/repositories/food_item_repository_impl.dart';
import 'features/inventory/domain/repositories/food_item_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 데이터베이스 초기화
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // 데이터베이스 초기화 대기

  // SQLite 기반 DataSource 사용
  final localDataSource = FoodItemSqliteDataSource(dbHelper: dbHelper);
  final repository = FoodItemRepositoryImpl(localDataSource);

  runApp(
    ProviderScope(
      overrides: [
        foodItemRepositoryProvider.overrideWithValue(repository),
        foodItemDataSourceProvider.overrideWithValue(localDataSource),
      ],
      child: const MainApp(),
    ),
  );
}

// Providers
final foodItemRepositoryProvider = Provider<FoodItemRepository>((ref) {
  throw UnimplementedError('Repository must be initialized before use');
});

final foodItemDataSourceProvider = Provider<FoodItemLocalDataSource>((ref) {
  throw UnimplementedError('DataSource must be initialized before use');
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
