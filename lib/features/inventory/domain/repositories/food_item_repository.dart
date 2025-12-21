import '../entities/enums.dart';
import '../entities/food_item.dart';

abstract class FoodItemRepository {
  /// 모든 식재료 조회
  Future<List<FoodItem>> getAllItems();

  /// ID로 식재료 조회
  Future<FoodItem?> getItemById(String id);

  /// 바코드로 식재료 조회
  Future<FoodItem?> getItemByBarcode(String barcode);

  /// 저장 위치별 식재료 조회
  Future<List<FoodItem>> getItemsByLocation(StorageLocation location);

  /// 카테고리별 식재료 조회
  Future<List<FoodItem>> getItemsByCategory(FoodCategory category);

  /// 유통기한 임박 식재료 조회 (N일 이내)
  Future<List<FoodItem>> getExpiringItems({int days = 3});

  /// 유통기한 지난 식재료 조회
  Future<List<FoodItem>> getExpiredItems();

  /// 식재료 추가
  Future<void> addItem(FoodItem item);

  /// 식재료 수정
  Future<void> updateItem(FoodItem item);

  /// 식재료 삭제
  Future<void> deleteItem(String id);

  /// 모든 식재료 삭제
  Future<void> deleteAllItems();

  /// 식재료 목록 실시간 감시
  Stream<List<FoodItem>> watchAllItems();
}
