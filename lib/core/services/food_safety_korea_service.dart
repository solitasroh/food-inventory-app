import 'dart:convert';
import 'package:http/http.dart' as http;

/// 식품안전나라 유통바코드 API (I2570) 응답 모델
class FoodSafetyProduct {
  final String barcode;
  final String? name;           // PRDLST_NM - 제품명
  final String? manufacturer;   // BSSH_NM - 제조사명
  final String? category;       // PRDLST_DCNM - 품목유형
  final int? shelfLifeDays;     // POG_DAYCNT - 유통기한 일수

  const FoodSafetyProduct({
    required this.barcode,
    this.name,
    this.manufacturer,
    this.category,
    this.shelfLifeDays,
  });

  factory FoodSafetyProduct.fromJson(String barcode, Map<String, dynamic> json) {
    // POG_DAYCNT를 int로 파싱
    int? shelfLife;
    final pogDaycnt = json['POG_DAYCNT'];
    if (pogDaycnt != null) {
      if (pogDaycnt is int) {
        shelfLife = pogDaycnt;
      } else if (pogDaycnt is String && pogDaycnt.isNotEmpty) {
        shelfLife = int.tryParse(pogDaycnt);
      }
    }

    return FoodSafetyProduct(
      barcode: barcode,
      name: json['PRDLST_NM'] as String?,
      manufacturer: json['BSSH_NM'] as String?,
      category: json['PRDLST_DCNM'] as String?,
      shelfLifeDays: shelfLife,
    );
  }

  bool get hasData => name != null;
  bool get hasShelfLife => shelfLifeDays != null && shelfLifeDays! > 0;

  /// 구매일 기준 유통기한 계산
  DateTime? calculateExpirationDate([DateTime? purchaseDate]) {
    if (shelfLifeDays == null) return null;
    final baseDate = purchaseDate ?? DateTime.now();
    return baseDate.add(Duration(days: shelfLifeDays!));
  }
}

/// 식품안전나라 API 서비스
/// API 문서: https://www.foodsafetykorea.go.kr/api/openApiInfo.do?svc_no=I2570
class FoodSafetyKoreaService {
  static const String _baseUrl = 'http://openapi.foodsafetykorea.go.kr/api';
  static const String _serviceId = 'I2570';

  final String? _apiKey;

  FoodSafetyKoreaService({String? apiKey}) : _apiKey = apiKey;

  /// API 키가 설정되어 있는지 확인
  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  /// 바코드로 제품 정보 조회
  ///
  /// [barcode] - 13자리 또는 8자리 바코드
  ///
  /// 반환값:
  /// - 성공 시: FoodSafetyProduct 객체
  /// - API 키 없음 또는 오류: null
  Future<FoodSafetyProduct?> getProductByBarcode(String barcode) async {
    if (!isConfigured) {
      return null;
    }

    try {
      // API URL: /api/{API_KEY}/{SERVICE_ID}/json/{START}/{END}/BRCD_NO={BARCODE}
      final url = Uri.parse(
        '$_baseUrl/$_apiKey/$_serviceId/json/1/1/BRCD_NO=$barcode',
      );

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        // 응답 구조: { "I2570": { "row": [...], "RESULT": {...} } }
        final serviceData = json[_serviceId] as Map<String, dynamic>?;
        if (serviceData == null) return null;

        // 결과 코드 확인
        final result = serviceData['RESULT'] as Map<String, dynamic>?;
        if (result != null) {
          final code = result['CODE'] as String?;
          // INFO-000: 성공, INFO-200: 데이터 없음
          if (code != 'INFO-000') {
            return FoodSafetyProduct(barcode: barcode);
          }
        }

        // 데이터 파싱
        final rows = serviceData['row'] as List<dynamic>?;
        if (rows != null && rows.isNotEmpty) {
          final firstRow = rows.first as Map<String, dynamic>;
          return FoodSafetyProduct.fromJson(barcode, firstRow);
        }
      }

      return FoodSafetyProduct(barcode: barcode);
    } catch (e) {
      // 네트워크 오류 등
      return null;
    }
  }

  /// 제품명으로 검색 (여러 결과 반환 가능)
  Future<List<FoodSafetyProduct>> searchByName(String name, {int limit = 10}) async {
    if (!isConfigured || name.isEmpty) {
      return [];
    }

    try {
      // API URL: /api/{API_KEY}/{SERVICE_ID}/json/{START}/{END}/PRDLST_NM={NAME}
      final url = Uri.parse(
        '$_baseUrl/$_apiKey/$_serviceId/json/1/$limit/PRDLST_NM=$name',
      );

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final serviceData = json[_serviceId] as Map<String, dynamic>?;
        if (serviceData == null) return [];

        final rows = serviceData['row'] as List<dynamic>?;
        if (rows != null) {
          return rows.map((row) {
            final data = row as Map<String, dynamic>;
            final barcode = data['BRCD_NO'] as String? ?? '';
            return FoodSafetyProduct.fromJson(barcode, data);
          }).toList();
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
