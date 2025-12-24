import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// SQLite 데이터베이스 헬퍼
/// 싱글톤 패턴으로 구현
class DatabaseHelper {
  static const String _databaseName = 'food_inventory.db';
  static const int _databaseVersion = 1;

  // 테이블 이름
  static const String tableFoodItems = 'food_items';

  // 컬럼 이름
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
    await db.execute('''
      CREATE INDEX idx_food_items_uid ON $tableFoodItems ($columnUid)
    ''');
    await db.execute('''
      CREATE INDEX idx_food_items_barcode ON $tableFoodItems ($columnBarcode)
    ''');
    await db.execute('''
      CREATE INDEX idx_food_items_category ON $tableFoodItems ($columnCategory)
    ''');
    await db.execute('''
      CREATE INDEX idx_food_items_location ON $tableFoodItems ($columnLocation)
    ''');
    await db.execute('''
      CREATE INDEX idx_food_items_expiration ON $tableFoodItems ($columnExpirationDate)
    ''');
  }

  /// 데이터베이스 업그레이드
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 향후 마이그레이션 로직 추가
    // if (oldVersion < 2) { ... }
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
