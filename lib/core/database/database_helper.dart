import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// SQLite 데이터베이스 헬퍼
/// 싱글톤 패턴으로 구현
class DatabaseHelper {
  static const String _databaseName = 'food_inventory.db';
  static const int _databaseVersion = 2; // 버전 업그레이드

  // 테이블 이름
  static const String tableFoodItems = 'food_items';
  static const String tableShoppingItems = 'shopping_items';
  static const String tablePurchaseHistory = 'purchase_history';

  // food_items 컬럼 이름
  static const String columnId = 'id';
  static const String columnUid = 'uid';
  static const String columnName = 'name';
  static const String columnBarcode = 'barcode';
  static const String columnCategory = 'category';
  static const String columnLocation = 'location';
  static const String columnQuantity = 'quantity';
  static const String columnUnit = 'unit';
  static const String columnExpirationDate = 'expiration_date';
  static const String columnPurchaseDate = 'purchase_date';
  static const String columnOpenedDate = 'opened_date';
  static const String columnPrice = 'price';
  static const String columnImageUrl = 'image_url';
  static const String columnNotes = 'notes';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // shopping_items 컬럼 이름
  static const String columnPriority = 'priority';
  static const String columnIsCompleted = 'is_completed';
  static const String columnLinkedFoodItemId = 'linked_food_item_id';
  static const String columnSuggestedBy = 'suggested_by';
  static const String columnCompletedAt = 'completed_at';

  // purchase_history 컬럼 이름
  static const String columnItemName = 'item_name';
  static const String columnPurchaseCount = 'purchase_count';
  static const String columnLastPurchasedAt = 'last_purchased_at';

  // 싱글톤 인스턴스
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  /// 데이터베이스 인스턴스 반환
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 데이터베이스 초기화
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 테이블 생성
  Future<void> _onCreate(Database db, int version) async {
    // food_items 테이블 생성
    await _createFoodItemsTable(db);

    // shopping_items 테이블 생성
    await _createShoppingItemsTable(db);

    // purchase_history 테이블 생성
    await _createPurchaseHistoryTable(db);
  }

  /// food_items 테이블 생성
  Future<void> _createFoodItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableFoodItems (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUid TEXT NOT NULL UNIQUE,
        $columnName TEXT NOT NULL,
        $columnBarcode TEXT,
        $columnCategory TEXT NOT NULL,
        $columnLocation TEXT NOT NULL,
        $columnQuantity REAL NOT NULL,
        $columnUnit TEXT NOT NULL,
        $columnExpirationDate TEXT,
        $columnPurchaseDate TEXT NOT NULL,
        $columnOpenedDate TEXT,
        $columnPrice REAL,
        $columnImageUrl TEXT,
        $columnNotes TEXT,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT
      )
    ''');

    // 인덱스 생성 (검색 성능 향상)
    await db.execute(
        'CREATE INDEX idx_food_items_uid ON $tableFoodItems ($columnUid)');
    await db.execute(
        'CREATE INDEX idx_food_items_barcode ON $tableFoodItems ($columnBarcode)');
    await db.execute(
        'CREATE INDEX idx_food_items_category ON $tableFoodItems ($columnCategory)');
    await db.execute(
        'CREATE INDEX idx_food_items_location ON $tableFoodItems ($columnLocation)');
    await db.execute(
        'CREATE INDEX idx_food_items_expiration ON $tableFoodItems ($columnExpirationDate)');
  }

  /// shopping_items 테이블 생성
  Future<void> _createShoppingItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableShoppingItems (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUid TEXT NOT NULL UNIQUE,
        $columnName TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnQuantity REAL NOT NULL,
        $columnUnit TEXT NOT NULL,
        $columnPriority TEXT NOT NULL DEFAULT 'medium',
        $columnIsCompleted INTEGER NOT NULL DEFAULT 0,
        $columnNotes TEXT,
        $columnLinkedFoodItemId TEXT,
        $columnSuggestedBy TEXT NOT NULL DEFAULT 'manual',
        $columnCreatedAt TEXT NOT NULL,
        $columnCompletedAt TEXT
      )
    ''');

    // 인덱스 생성
    await db.execute(
        'CREATE INDEX idx_shopping_items_uid ON $tableShoppingItems ($columnUid)');
    await db.execute(
        'CREATE INDEX idx_shopping_items_category ON $tableShoppingItems ($columnCategory)');
    await db.execute(
        'CREATE INDEX idx_shopping_items_completed ON $tableShoppingItems ($columnIsCompleted)');
  }

  /// purchase_history 테이블 생성 (자주 구매 품목 추적)
  Future<void> _createPurchaseHistoryTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tablePurchaseHistory (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnItemName TEXT NOT NULL UNIQUE,
        $columnCategory TEXT NOT NULL,
        $columnPurchaseCount INTEGER NOT NULL DEFAULT 1,
        $columnLastPurchasedAt TEXT NOT NULL
      )
    ''');

    // 인덱스 생성
    await db.execute(
        'CREATE INDEX idx_purchase_history_name ON $tablePurchaseHistory ($columnItemName)');
    await db.execute(
        'CREATE INDEX idx_purchase_history_count ON $tablePurchaseHistory ($columnPurchaseCount DESC)');
  }

  /// 데이터베이스 업그레이드
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 버전 1 → 2: shopping_items, purchase_history 테이블 추가
      await _createShoppingItemsTable(db);
      await _createPurchaseHistoryTable(db);
    }
  }

  /// 데이터베이스 닫기
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// 데이터베이스 삭제 (테스트용)
  Future<void> deleteDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
