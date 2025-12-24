import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../domain/entities/enums.dart';
import '../models/food_item_model.dart';
import 'food_item_local_datasource.dart';

/// SQLite 기반 영구 저장소 DataSource
class FoodItemSqliteDataSource implements FoodItemLocalDataSource {
  final DatabaseHelper _dbHelper;

  // 실시간 데이터 변경 스트림
  final _itemsStreamController = StreamController<List<FoodItemModel>>.broadcast();

  FoodItemSqliteDataSource({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper();

  /// Map을 FoodItemModel로 변환
  FoodItemModel _fromMap(Map<String, dynamic> map) {
    return FoodItemModel()
      ..id = map[DatabaseHelper.columnId] as int
      ..uid = map[DatabaseHelper.columnUid] as String
      ..name = map[DatabaseHelper.columnName] as String
      ..barcode = map[DatabaseHelper.columnBarcode] as String?
      ..category = FoodCategory.values.firstWhere(
        (e) => e.name == map[DatabaseHelper.columnCategory],
        orElse: () => FoodCategory.other,
      )
      ..location = StorageLocation.values.firstWhere(
        (e) => e.name == map[DatabaseHelper.columnLocation],
        orElse: () => StorageLocation.other,
      )
      ..quantity = (map[DatabaseHelper.columnQuantity] as num).toDouble()
      ..unit = map[DatabaseHelper.columnUnit] as String
      ..expirationDate = map[DatabaseHelper.columnExpirationDate] != null
          ? DateTime.parse(map[DatabaseHelper.columnExpirationDate] as String)
          : null
      ..purchaseDate = DateTime.parse(map[DatabaseHelper.columnPurchaseDate] as String)
      ..openedDate = map[DatabaseHelper.columnOpenedDate] != null
          ? DateTime.parse(map[DatabaseHelper.columnOpenedDate] as String)
          : null
      ..price = map[DatabaseHelper.columnPrice] != null
          ? (map[DatabaseHelper.columnPrice] as num).toDouble()
          : null
      ..imageUrl = map[DatabaseHelper.columnImageUrl] as String?
      ..notes = map[DatabaseHelper.columnNotes] as String?
      ..createdAt = DateTime.parse(map[DatabaseHelper.columnCreatedAt] as String)
      ..updatedAt = map[DatabaseHelper.columnUpdatedAt] != null
          ? DateTime.parse(map[DatabaseHelper.columnUpdatedAt] as String)
          : null;
  }

  /// FoodItemModel을 Map으로 변환
  Map<String, dynamic> _toMap(FoodItemModel item) {
    return {
      DatabaseHelper.columnUid: item.uid,
      DatabaseHelper.columnName: item.name,
      DatabaseHelper.columnBarcode: item.barcode,
      DatabaseHelper.columnCategory: item.category.name,
      DatabaseHelper.columnLocation: item.location.name,
      DatabaseHelper.columnQuantity: item.quantity,
      DatabaseHelper.columnUnit: item.unit,
      DatabaseHelper.columnExpirationDate: item.expirationDate?.toIso8601String(),
      DatabaseHelper.columnPurchaseDate: item.purchaseDate.toIso8601String(),
      DatabaseHelper.columnOpenedDate: item.openedDate?.toIso8601String(),
      DatabaseHelper.columnPrice: item.price,
      DatabaseHelper.columnImageUrl: item.imageUrl,
      DatabaseHelper.columnNotes: item.notes,
      DatabaseHelper.columnCreatedAt: item.createdAt.toIso8601String(),
      DatabaseHelper.columnUpdatedAt: item.updatedAt?.toIso8601String(),
    };
  }

  /// 스트림 업데이트
  Future<void> _notifyListeners() async {
    final items = await getAllItems();
    _itemsStreamController.add(items);
  }

  @override
  Future<List<FoodItemModel>> getAllItems() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableFoodItems,
      orderBy: '${DatabaseHelper.columnCreatedAt} DESC',
    );
    return maps.map(_fromMap).toList();
  }

  @override
  Future<FoodItemModel?> getItemById(String uid) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableFoodItems,
      where: '${DatabaseHelper.columnUid} = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  @override
  Future<FoodItemModel?> getItemByBarcode(String barcode) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableFoodItems,
      where: '${DatabaseHelper.columnBarcode} = ?',
      whereArgs: [barcode],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  @override
  Future<List<FoodItemModel>> getItemsByLocation(StorageLocation location) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableFoodItems,
      where: '${DatabaseHelper.columnLocation} = ?',
      whereArgs: [location.name],
      orderBy: '${DatabaseHelper.columnExpirationDate} ASC',
    );
    return maps.map(_fromMap).toList();
  }

  @override
  Future<List<FoodItemModel>> getItemsByCategory(FoodCategory category) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableFoodItems,
      where: '${DatabaseHelper.columnCategory} = ?',
      whereArgs: [category.name],
      orderBy: '${DatabaseHelper.columnExpirationDate} ASC',
    );
    return maps.map(_fromMap).toList();
  }

  @override
  Future<List<FoodItemModel>> getExpiringItems(DateTime before) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final beforeStr = before.toIso8601String();

    final maps = await db.query(
      DatabaseHelper.tableFoodItems,
      where: '${DatabaseHelper.columnExpirationDate} IS NOT NULL '
          'AND ${DatabaseHelper.columnExpirationDate} > ? '
          'AND ${DatabaseHelper.columnExpirationDate} < ?',
      whereArgs: [now, beforeStr],
      orderBy: '${DatabaseHelper.columnExpirationDate} ASC',
    );
    return maps.map(_fromMap).toList();
  }

  @override
  Future<List<FoodItemModel>> getExpiredItems() async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();

    final maps = await db.query(
      DatabaseHelper.tableFoodItems,
      where: '${DatabaseHelper.columnExpirationDate} IS NOT NULL '
          'AND ${DatabaseHelper.columnExpirationDate} < ?',
      whereArgs: [now],
      orderBy: '${DatabaseHelper.columnExpirationDate} ASC',
    );
    return maps.map(_fromMap).toList();
  }

  @override
  Future<void> insertItem(FoodItemModel item) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableFoodItems,
      _toMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _notifyListeners();
  }

  @override
  Future<void> updateItem(FoodItemModel item) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableFoodItems,
      _toMap(item),
      where: '${DatabaseHelper.columnUid} = ?',
      whereArgs: [item.uid],
    );
    await _notifyListeners();
  }

  @override
  Future<void> deleteItem(String uid) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableFoodItems,
      where: '${DatabaseHelper.columnUid} = ?',
      whereArgs: [uid],
    );
    await _notifyListeners();
  }

  @override
  Future<void> deleteAllItems() async {
    final db = await _dbHelper.database;
    await db.delete(DatabaseHelper.tableFoodItems);
    await _notifyListeners();
  }

  @override
  Stream<List<FoodItemModel>> watchAllItems() {
    // 초기 데이터 로드
    getAllItems().then((items) {
      _itemsStreamController.add(items);
    });
    return _itemsStreamController.stream;
  }

  /// 리소스 정리
  void dispose() {
    _itemsStreamController.close();
  }

  /// 검색 기능 (추가)
  Future<List<FoodItemModel>> searchItems(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableFoodItems,
      where: '${DatabaseHelper.columnName} LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '${DatabaseHelper.columnName} ASC',
    );
    return maps.map(_fromMap).toList();
  }

  /// 통계 조회 (추가)
  Future<Map<String, int>> getItemCountByCategory() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT ${DatabaseHelper.columnCategory}, COUNT(*) as count
      FROM ${DatabaseHelper.tableFoodItems}
      GROUP BY ${DatabaseHelper.columnCategory}
    ''');

    return {
      for (final row in result)
        row[DatabaseHelper.columnCategory] as String: row['count'] as int
    };
  }

  Future<Map<String, int>> getItemCountByLocation() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT ${DatabaseHelper.columnLocation}, COUNT(*) as count
      FROM ${DatabaseHelper.tableFoodItems}
      GROUP BY ${DatabaseHelper.columnLocation}
    ''');

    return {
      for (final row in result)
        row[DatabaseHelper.columnLocation] as String: row['count'] as int
    };
  }
}
