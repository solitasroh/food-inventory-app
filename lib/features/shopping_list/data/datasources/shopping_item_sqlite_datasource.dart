import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../inventory/domain/entities/enums.dart';
import '../../domain/entities/shopping_enums.dart';
import '../../domain/entities/shopping_item.dart';

/// 쇼핑리스트 SQLite DataSource
class ShoppingItemSqliteDataSource {
  final DatabaseHelper _dbHelper;
  final _streamController = StreamController<List<ShoppingItem>>.broadcast();

  ShoppingItemSqliteDataSource({required DatabaseHelper dbHelper})
      : _dbHelper = dbHelper;

  /// 실시간 스트림
  Stream<List<ShoppingItem>> get itemsStream => _streamController.stream;

  /// 스트림 업데이트 알림
  Future<void> _notifyListeners() async {
    final items = await getAllItems();
    _streamController.add(items);
  }

  /// 모든 쇼핑 아이템 조회
  Future<List<ShoppingItem>> getAllItems() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableShoppingItems,
      orderBy: '${DatabaseHelper.columnIsCompleted} ASC, '
          '${DatabaseHelper.columnCategory} ASC, '
          '${DatabaseHelper.columnCreatedAt} DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  /// 미완료 아이템만 조회
  Future<List<ShoppingItem>> getPendingItems() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableShoppingItems,
      where: '${DatabaseHelper.columnIsCompleted} = ?',
      whereArgs: [0],
      orderBy: '${DatabaseHelper.columnCategory} ASC, '
          '${DatabaseHelper.columnCreatedAt} DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  /// 완료된 아이템만 조회
  Future<List<ShoppingItem>> getCompletedItems() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableShoppingItems,
      where: '${DatabaseHelper.columnIsCompleted} = ?',
      whereArgs: [1],
      orderBy: '${DatabaseHelper.columnCompletedAt} DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  /// 카테고리별 아이템 조회
  Future<List<ShoppingItem>> getItemsByCategory(FoodCategory category) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableShoppingItems,
      where: '${DatabaseHelper.columnCategory} = ?',
      whereArgs: [category.name],
      orderBy: '${DatabaseHelper.columnIsCompleted} ASC, '
          '${DatabaseHelper.columnCreatedAt} DESC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  /// ID로 아이템 조회
  Future<ShoppingItem?> getItemById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableShoppingItems,
      where: '${DatabaseHelper.columnUid} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  /// 아이템 추가
  Future<void> addItem(ShoppingItem item) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableShoppingItems,
      _toMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _notifyListeners();
  }

  /// 아이템 수정
  Future<void> updateItem(ShoppingItem item) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableShoppingItems,
      _toMap(item),
      where: '${DatabaseHelper.columnUid} = ?',
      whereArgs: [item.id],
    );
    await _notifyListeners();
  }

  /// 아이템 삭제
  Future<void> deleteItem(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableShoppingItems,
      where: '${DatabaseHelper.columnUid} = ?',
      whereArgs: [id],
    );
    await _notifyListeners();
  }

  /// 아이템 완료 토글
  Future<void> toggleComplete(String id) async {
    final item = await getItemById(id);
    if (item == null) return;

    final updatedItem = item.copyWith(
      isCompleted: !item.isCompleted,
      completedAt: !item.isCompleted ? DateTime.now() : null,
    );

    await updateItem(updatedItem);

    // 완료 시 구매 이력 추가
    if (updatedItem.isCompleted) {
      await _addToPurchaseHistory(updatedItem);
    }
  }

  /// 완료된 아이템 모두 삭제
  Future<void> clearCompleted() async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableShoppingItems,
      where: '${DatabaseHelper.columnIsCompleted} = ?',
      whereArgs: [1],
    );
    await _notifyListeners();
  }

  /// 이름으로 검색
  Future<List<ShoppingItem>> searchItems(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableShoppingItems,
      where: '${DatabaseHelper.columnName} LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '${DatabaseHelper.columnIsCompleted} ASC, '
          '${DatabaseHelper.columnName} ASC',
    );
    return maps.map((map) => _fromMap(map)).toList();
  }

  /// 구매 이력에 추가
  Future<void> _addToPurchaseHistory(ShoppingItem item) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();

    // UPSERT: 있으면 업데이트, 없으면 삽입
    await db.rawInsert('''
      INSERT INTO ${DatabaseHelper.tablePurchaseHistory}
        (${DatabaseHelper.columnItemName}, ${DatabaseHelper.columnCategory},
         ${DatabaseHelper.columnPurchaseCount}, ${DatabaseHelper.columnLastPurchasedAt})
      VALUES (?, ?, 1, ?)
      ON CONFLICT(${DatabaseHelper.columnItemName}) DO UPDATE SET
        ${DatabaseHelper.columnPurchaseCount} = ${DatabaseHelper.columnPurchaseCount} + 1,
        ${DatabaseHelper.columnLastPurchasedAt} = ?
    ''', [item.name, item.category.name, now, now]);
  }

  /// 자주 구매한 아이템 조회
  Future<List<Map<String, dynamic>>> getFrequentItems({int limit = 10}) async {
    final db = await _dbHelper.database;
    return await db.query(
      DatabaseHelper.tablePurchaseHistory,
      orderBy: '${DatabaseHelper.columnPurchaseCount} DESC',
      limit: limit,
    );
  }

  /// 최근 구매한 아이템 조회
  Future<List<Map<String, dynamic>>> getRecentItems({int limit = 10}) async {
    final db = await _dbHelper.database;
    return await db.query(
      DatabaseHelper.tablePurchaseHistory,
      orderBy: '${DatabaseHelper.columnLastPurchasedAt} DESC',
      limit: limit,
    );
  }

  /// Map을 ShoppingItem으로 변환
  ShoppingItem _fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map[DatabaseHelper.columnUid] as String,
      name: map[DatabaseHelper.columnName] as String,
      category: FoodCategory.values.firstWhere(
        (c) => c.name == map[DatabaseHelper.columnCategory],
        orElse: () => FoodCategory.other,
      ),
      quantity: (map[DatabaseHelper.columnQuantity] as num).toDouble(),
      unit: map[DatabaseHelper.columnUnit] as String,
      priority: ShoppingPriority.values.firstWhere(
        (p) => p.name == map[DatabaseHelper.columnPriority],
        orElse: () => ShoppingPriority.medium,
      ),
      isCompleted: (map[DatabaseHelper.columnIsCompleted] as int) == 1,
      notes: map[DatabaseHelper.columnNotes] as String?,
      linkedFoodItemId: map[DatabaseHelper.columnLinkedFoodItemId] as String?,
      suggestedBy: SuggestionSource.values.firstWhere(
        (s) => s.name == map[DatabaseHelper.columnSuggestedBy],
        orElse: () => SuggestionSource.manual,
      ),
      createdAt: DateTime.parse(map[DatabaseHelper.columnCreatedAt] as String),
      completedAt: map[DatabaseHelper.columnCompletedAt] != null
          ? DateTime.parse(map[DatabaseHelper.columnCompletedAt] as String)
          : null,
    );
  }

  /// ShoppingItem을 Map으로 변환
  Map<String, dynamic> _toMap(ShoppingItem item) {
    return {
      DatabaseHelper.columnUid: item.id,
      DatabaseHelper.columnName: item.name,
      DatabaseHelper.columnCategory: item.category.name,
      DatabaseHelper.columnQuantity: item.quantity,
      DatabaseHelper.columnUnit: item.unit,
      DatabaseHelper.columnPriority: item.priority.name,
      DatabaseHelper.columnIsCompleted: item.isCompleted ? 1 : 0,
      DatabaseHelper.columnNotes: item.notes,
      DatabaseHelper.columnLinkedFoodItemId: item.linkedFoodItemId,
      DatabaseHelper.columnSuggestedBy: item.suggestedBy.name,
      DatabaseHelper.columnCreatedAt: item.createdAt.toIso8601String(),
      DatabaseHelper.columnCompletedAt: item.completedAt?.toIso8601String(),
    };
  }

  /// 리소스 정리
  void dispose() {
    _streamController.close();
  }
}
