# Food Inventory App - 개발 현황

## 완료된 작업 (2024-12-21)

### 프로젝트 설정
- [x] Flutter 프로젝트 생성
- [x] Clean Architecture 폴더 구조 설정 (data/domain/presentation)
- [x] 의존성 패키지 추가 (Riverpod, go_router, freezed, etc.)

### 핵심 기능 구현
- [x] Domain 엔티티 생성 (FoodItem, StorageLocation, FoodCategory)
- [x] Freezed를 사용한 불변 데이터 클래스 구현
- [x] Material 3 테마 설정 (라이트/다크 모드)
- [x] go_router 라우팅 설정 (하단 네비게이션 바 포함)

### 재고 관리 기능
- [x] 식재료 목록 페이지 (InventoryListPage)
  - 필터링 (저장 위치, 카테고리)
  - 검색 기능
  - 정렬 (이름순, 유통기한순, 최근 추가순)
  - Pull-to-refresh
- [x] 식재료 추가 페이지 (AddFoodItemPage)
- [x] 식재료 상세 페이지 (FoodItemDetailPage)
  - 수량 조절
  - 개봉일 표시
  - 삭제 기능
- [x] 식재료 수정 페이지 (EditFoodItemPage)
  - 변경 감지 및 확인 다이얼로그

### 바코드 스캔 기능
- [x] mobile_scanner 패키지 통합
- [x] 바코드 스캐너 페이지 (BarcodeScannerPage)
- [x] Open Food Facts API 연동
- [x] 스캔 결과로 제품 정보 자동 입력

### 데이터 레이어
- [x] Repository 패턴 구현
- [x] DataSource 추상화
- [x] 메모리 기반 임시 저장소 (FoodItemMemoryDataSource)

### 상태 관리
- [x] Riverpod Provider 설정
- [x] AsyncNotifier를 사용한 비동기 상태 관리
- [x] 필터/검색 Provider 분리

### 플랫폼 설정
- [x] Android 카메라 권한 설정
- [x] iOS 카메라 권한 설정 (Info.plist)
- [x] iOS 최소 배포 버전 15.5로 업데이트

### 테스트
- [x] Android 에뮬레이터 테스트
- [x] iOS 시뮬레이터 테스트

### 기타
- [x] GitHub 레포지토리 생성 및 푸시

---

## 완료된 작업 (2024-12-24)

### 유통기한 자동 추천 시스템
- [x] **다중 API 폴백 전략 설계** - I2570 → 푸드QR → OpenFoodFacts 순차 조회
- [x] **신선식품 보관기간 데이터베이스 구축** (70+ 식품 카테고리)
  - 육류, 해산물, 채소, 과일, 유제품, 곡류, 조미료, 가공식품, 음료
  - 저장 위치별 보관일수 (냉장/냉동/실온)
- [x] **서브카테고리 모델 및 서비스 구현**
  - `FoodSubCategory` - 세분화된 식품 분류
  - `ShelfLifeService` - 보관기간 추천 로직
  - `ShelfLifeRecommendation` - 추천 결과 (일수, 신뢰도, 출처)
- [x] **한국 식품 API 서비스 구현**
  - `FoodSafetyKoreaService` - 식품안전나라 I2570 API
  - `FoodQRService` - 푸드QR API
- [x] **통합 제품 조회 서비스** (`ProductLookupService`)
  - 다중 API 폴백 로직
  - 결과 병합 및 신뢰도 계산
- [x] **식품 추가 페이지 UI 개선**
  - 이름 입력 시 자동완성 (키워드 기반)
  - 저장 위치 변경 시 보관기간 자동 추천
  - 유통기한 자동 설정 (신뢰도 50% 이상)
  - 추천 정보 카드 (출처, 신뢰도 표시)

### 영구 저장소 구현
- [x] **SQLite 데이터베이스 구현**
  - sqflite 패키지 적용
  - `DatabaseHelper` - 싱글톤 DB 관리, 스키마 정의
  - `FoodItemSqliteDataSource` - SQLite 기반 DataSource
  - 인덱스 최적화 (uid, barcode, category, location, expiration_date)
  - 실시간 스트림 지원 (`watchAllItems`)
  - 검색 기능 (`searchItems`)
  - 통계 기능 (`getItemCountByCategory`, `getItemCountByLocation`)

---

## 남은 작업 (TODO)

### 우선순위 높음
- [x] ~~**영구 저장소 구현** - sqflite로 메모리 저장소 교체~~ ✅ 완료
- [ ] **쇼핑 리스트 기능** - 부족한 식재료 자동 추가, 수동 추가
- [ ] **유통기한 알림** - 로컬 푸시 알림 (flutter_local_notifications)
- [ ] **API 키 설정** - 공공데이터포털/푸드QR API 키 발급 및 설정

### 우선순위 중간
- [ ] **설정 페이지 구현**
  - 알림 설정 (D-day 기준일 설정)
  - 테마 설정 (시스템/라이트/다크)
  - API 키 설정
  - 데이터 백업/복원
  - 앱 정보
- [ ] **식재료 이미지 촬영** - 카메라/갤러리에서 이미지 추가
- [ ] **카테고리 관리** - 사용자 정의 카테고리 추가/수정
- [ ] **통계 대시보드** - 유통기한 임박 현황, 카테고리별 분포
- [ ] **사용자 히스토리 학습** - 반복 구매 제품 유통기한 패턴 학습

### 우선순위 낮음
- [ ] **다국어 지원** (i18n) - 영어, 한국어
- [ ] **앱 아이콘 및 스플래시 스크린** 디자인
- [ ] **위젯** - iOS/Android 홈 화면 위젯
- [ ] **데이터 동기화** - 클라우드 백업 (Firebase/iCloud)
- [ ] **OCR 기능** - 유통기한 라벨 자동 인식 (google_mlkit_text_recognition)

### 코드 품질
- [ ] **단위 테스트** 작성 (UseCase, Repository)
- [ ] **위젯 테스트** 작성
- [ ] **통합 테스트** 작성
- [ ] **코드 리팩토링** - 중복 코드 제거, 상수 분리

### 배포 준비
- [ ] **앱 서명 설정** (Android keystore, iOS certificates)
- [ ] **Play Store 등록** 준비
- [ ] **App Store 등록** 준비
- [ ] **개인정보 처리방침** 작성

---

## 기술 스택

| 분류 | 기술 |
|------|------|
| Framework | Flutter 3.x |
| 상태관리 | Riverpod + riverpod_generator |
| 라우팅 | go_router |
| 데이터 클래스 | freezed + json_serializable |
| 로컬 DB | sqflite |
| 바코드 스캔 | mobile_scanner |
| HTTP | http |
| UI | flutter_screenutil, Material 3 |

---

## 새로 추가된 파일 (2024-12-24)

### 데이터베이스
- `lib/core/database/database_helper.dart` - SQLite 데이터베이스 헬퍼

### 데이터
- `lib/core/data/food_subcategory.dart` - 서브카테고리 모델
- `lib/core/data/food_subcategories_data.dart` - 70+ 식품 보관기간 DB

### 서비스
- `lib/core/services/shelf_life_service.dart` - 보관기간 추천 서비스
- `lib/core/services/food_safety_korea_service.dart` - 식품안전나라 API (I2570)
- `lib/core/services/food_qr_service.dart` - 푸드QR API
- `lib/core/services/product_lookup_service.dart` - 통합 제품 조회 서비스

### DataSource
- `lib/features/inventory/data/datasources/food_item_sqlite_datasource.dart` - SQLite DataSource

### 설정
- `lib/core/config/api_config.dart` - API 키 관리

---

## API 키 발급 안내

### 식품안전나라 (I2570)
1. https://www.data.go.kr/data/15064775/openapi.do 접속
2. 활용 신청
3. API 키 발급
4. `ApiConfig.setFoodSafetyKoreaApiKey(key)` 또는 환경변수 설정

### 푸드QR
1. https://portal.foodqr.kr/dvlpr/mainView.do 접속
2. 개발자 등록
3. API 키 발급
4. `ApiConfig.setFoodQRApiKey(key)` 또는 환경변수 설정

---

## 알려진 이슈

1. **Isar 호환성 문제** - AGP 8.11.1과 호환되지 않아 제거됨. drift로 마이그레이션 예정.
2. **에뮬레이터 바코드 스캔** - 실제 카메라가 없어 테스트 불가. 실기기 필요.
3. **식품안전나라 API 데이터 제한** - 2018년까지 데이터만 제공 (유통물류진흥원 요청)
4. **푸드QR 데이터 부족** - 2024년 11월 시작, 현재 약 339건 등록

---

## 참고 링크

- [GitHub Repository](https://github.com/solitasroh/food-inventory-app)
- [Open Food Facts API](https://world.openfoodfacts.org/data)
- [식품안전나라 API](https://www.foodsafetykorea.go.kr/api/openApiInfo.do?svc_no=I2570)
- [푸드QR 개발자 포털](https://portal.foodqr.kr/dvlpr/mainView.do)
- [Flutter Documentation](https://docs.flutter.dev/)
