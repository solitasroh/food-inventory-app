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

## 남은 작업 (TODO)

### 우선순위 높음
- [ ] **영구 저장소 구현** - drift 또는 sqflite로 메모리 저장소 교체
- [ ] **쇼핑 리스트 기능** - 부족한 식재료 자동 추가, 수동 추가
- [ ] **유통기한 알림** - 로컬 푸시 알림 (flutter_local_notifications)

### 우선순위 중간
- [ ] **설정 페이지 구현**
  - 알림 설정 (D-day 기준일 설정)
  - 테마 설정 (시스템/라이트/다크)
  - 데이터 백업/복원
  - 앱 정보
- [ ] **식재료 이미지 촬영** - 카메라/갤러리에서 이미지 추가
- [ ] **카테고리 관리** - 사용자 정의 카테고리 추가/수정
- [ ] **통계 대시보드** - 유통기한 임박 현황, 카테고리별 분포

### 우선순위 낮음
- [ ] **다국어 지원** (i18n) - 영어, 한국어
- [ ] **앱 아이콘 및 스플래시 스크린** 디자인
- [ ] **위젯** - iOS/Android 홈 화면 위젯
- [ ] **데이터 동기화** - 클라우드 백업 (Firebase/iCloud)
- [ ] **OCR 기능** - 영수증에서 식재료 자동 인식

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
| 로컬 DB | (예정) drift 또는 sqflite |
| 바코드 스캔 | mobile_scanner |
| HTTP | http |
| UI | flutter_screenutil, Material 3 |

---

## 알려진 이슈

1. **Isar 호환성 문제** - AGP 8.11.1과 호환되지 않아 제거됨. drift로 마이그레이션 예정.
2. **에뮬레이터 바코드 스캔** - 실제 카메라가 없어 테스트 불가. 실기기 필요.

---

## 참고 링크

- [GitHub Repository](https://github.com/solitasroh/food-inventory-app)
- [Open Food Facts API](https://world.openfoodfacts.org/data)
- [Flutter Documentation](https://docs.flutter.dev/)
