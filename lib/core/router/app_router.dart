import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/inventory/presentation/pages/add_food_item_page.dart';
import '../../features/inventory/presentation/pages/barcode_scanner_page.dart';
import '../../features/inventory/presentation/pages/edit_food_item_page.dart';
import '../../features/inventory/presentation/pages/food_item_detail_page.dart';
import '../../features/inventory/presentation/pages/inventory_list_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/shopping_list/presentation/pages/shopping_list_page.dart';

part 'app_routes.dart';
part 'scaffold_with_nav_bar.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'inventory',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: InventoryListPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addItem',
                builder: (context, state) => const AddFoodItemPage(),
              ),
              GoRoute(
                path: 'scan',
                name: 'scan',
                builder: (context, state) => const BarcodeScannerPage(),
              ),
              GoRoute(
                path: 'item/:id',
                name: 'itemDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return FoodItemDetailPage(itemId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'editItem',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EditFoodItemPage(itemId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.shopping,
            name: 'shopping',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ShoppingListPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
});
