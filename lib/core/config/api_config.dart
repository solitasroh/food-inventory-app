/// API 설정 관리
///
/// 사용법:
/// 1. 공공데이터포털에서 API 키 발급: https://www.data.go.kr/data/15064775/openapi.do
/// 2. 푸드QR 개발자 포털에서 API 키 발급: https://portal.foodqr.kr/dvlpr/mainView.do
/// 3. 아래 상수에 API 키 입력 또는 환경 변수로 관리
class ApiConfig {
  // 식품안전나라 유통바코드 API (I2570)
  // 발급: https://www.data.go.kr/data/15064775/openapi.do
  static const String? foodSafetyKoreaApiKey = String.fromEnvironment(
    'FOOD_SAFETY_KOREA_API_KEY',
    defaultValue: '',
  );

  // 푸드QR API
  // 발급: https://portal.foodqr.kr/dvlpr/mainView.do
  static const String? foodQRApiKey = String.fromEnvironment(
    'FOOD_QR_API_KEY',
    defaultValue: '',
  );

  /// 식품안전나라 API 사용 가능 여부
  static bool get isFoodSafetyKoreaEnabled =>
      foodSafetyKoreaApiKey != null && foodSafetyKoreaApiKey!.isNotEmpty;

  /// 푸드QR API 사용 가능 여부
  static bool get isFoodQREnabled =>
      foodQRApiKey != null && foodQRApiKey!.isNotEmpty;

  /// API 키 직접 설정 (런타임 설정용)
  static String? _runtimeFoodSafetyKey;
  static String? _runtimeFoodQRKey;

  static void setFoodSafetyKoreaApiKey(String key) {
    _runtimeFoodSafetyKey = key;
  }

  static void setFoodQRApiKey(String key) {
    _runtimeFoodQRKey = key;
  }

  static String? get effectiveFoodSafetyKoreaApiKey =>
      _runtimeFoodSafetyKey ??
      (foodSafetyKoreaApiKey?.isNotEmpty == true ? foodSafetyKoreaApiKey : null);

  static String? get effectiveFoodQRApiKey =>
      _runtimeFoodQRKey ??
      (foodQRApiKey?.isNotEmpty == true ? foodQRApiKey : null);
}
