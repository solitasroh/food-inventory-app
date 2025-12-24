import '../../../inventory/domain/entities/enums.dart';
import '../entities/shopping_item.dart';

/// 쇼핑리스트 Repository 인터페이스
abstract class ShoppingListRepository {
  /// 모든 쇼핑 아이템 조회
  Future<List<ShoppingItem>> getAllItems();

  /// 쇼핑 아이템 스트림 (실시간 업데이트)
  Stream<List<ShoppingItem>> watchAllItems();

  /// 미완료 아이템만 조회
  Future<List<ShoppingItem>> getPendingItems();

  /// 완료된 아이템만 조회
  Future<List<ShoppingItem>> getCompletedItems();

  /// 카테고리별 아이템 조회
  Future<List<ShoppingItem>> getItemsByCategory(FoodCategory category);

  /// ID로 아이템 조회
  Future<ShoppingItem?> getItemById(String id);

  /// 아이템 추가
  Future<void> addItem(ShoppingItem item);

  /// 아이템 수정
  Future<void> updateItem(ShoppingItem item);

  /// 아이템 삭제
  Future<void> deleteItem(String id);

  /// 아이템 완료 처리
  Future<void> toggleComplete(String id);

  /// 완료된 아이템 모두 삭제
  Future<void> clearCompleted();

  /// 이름으로 검색
  Future<List<ShoppingItem>> searchItems(String query);

  /// 자주 구매한 아이템 조회 (구매 이력 기반)
  Future<List<String>> getFrequentItems({int limit = 10});

  /// 최근 구매한 아이템 조회
  Future<List<String>> getRecentItems({int limit = 10});
}
