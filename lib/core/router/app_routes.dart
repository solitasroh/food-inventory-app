part of 'app_router.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String add = '/add';
  static const String scan = '/scan';
  static const String itemDetail = '/item/:id';
  static const String editItem = '/item/:id/edit';
  static const String shopping = '/shopping';
  static const String settings = '/settings';

  static String itemDetailPath(String id) => '/item/$id';
  static String editItemPath(String id) => '/item/$id/edit';
}
