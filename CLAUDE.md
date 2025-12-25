# Food Inventory App - 식재료 관리 앱

## 📋 프로젝트 개요

가정용 식재료 재고 관리, 유통기한 추적, 쇼핑 리스트 생성을 위한 Flutter 크로스플랫폼 앱

## 🛠 기술 스택

- **Framework**: Flutter 3.x (Dart)
- **State Management**: Riverpod 2.x
- **Routing**: go_router
- **Local Database**: Isar
- **DI**: get_it + injectable
- **Code Generation**: freezed, json_serializable, riverpod_generator

## 🏗 아키텍처

Clean Architecture 패턴 적용:

```
lib/
├── core/           # 공통 유틸, 상수, 테마, 에러 처리
├── features/       # 기능별 모듈
│   └── [feature]/
│       ├── data/           # Repository 구현, DataSource, Model
│       ├── domain/         # Entity, UseCase, Repository 인터페이스
│       └── presentation/   # Page, Widget, Provider
└── main.dart
```

## 📏 코딩 컨벤션

- **Dart Style Guide** 준수
- 파일명: `snake_case.dart`
- 클래스: `PascalCase`
- 변수/함수: `camelCase`
- private 멤버: `_underscorePrefix`
- const 생성자 적극 활용
- 한 파일에 하나의 public 클래스

## 🎨 네이밍 규칙

- Page: `*_page.dart` (예: `inventory_list_page.dart`)
- Widget: `*_widget.dart` 또는 용도별 (예: `food_item_card.dart`)
- Provider: `*_provider.dart`
- Entity: `*_entity.dart` 또는 모델명 그대로
- Repository: `*_repository.dart` (인터페이스), `*_repository_impl.dart` (구현)
- UseCase: `*_usecase.dart`

## 📦 주요 의존성

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.0
  get_it: ^7.7.0
  injectable: ^2.4.2
  freezed_annotation: ^2.4.1
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  mobile_scanner: ^5.1.1
  flutter_local_notifications: ^17.2.1
```

## 🔧 자주 사용하는 명령어

```bash
# 코드 생성 (freezed, riverpod, isar 등)
flutter pub run build_runner build --delete-conflicting-outputs

# watch 모드
flutter pub run build_runner watch --delete-conflicting-outputs

# 테스트
flutter test

# 린트 검사
flutter analyze

# 클린 빌드
flutter clean && flutter pub get
```

## 📁 핵심 파일 위치

- 앱 진입점: `lib/main.dart`
- 라우터: `lib/core/router/app_router.dart`
- 테마: `lib/core/theme/app_theme.dart`
- DI 설정: `lib/core/di/injection.dart`
- 재고 관리: `lib/features/inventory/`
- 쇼핑 리스트: `lib/features/shopping_list/`

## 🗃 데이터 모델

### FoodItem (식재료)

- id, name, barcode, category, location
- quantity, unit, expirationDate, purchaseDate
- openedDate, price, imageUrl, notes

### StorageLocation (저장 위치)

- refrigerator, freezer, pantry, other

### FoodCategory (카테고리)

- vegetables, fruits, meat, seafood, dairy
- grains, seasonings, processed, beverages, other

## ✅ MVP 기능 범위

1. 식재료 CRUD (수동 입력)
2. 바코드 스캔 등록
3. 유통기한 추적 및 알림
4. 저장 위치별/카테고리별 필터링
5. 검색 기능

## 🚫 주의사항

- Isar 스키마 변경 시 마이그레이션 필요
- build_runner 충돌 시 `--delete-conflicting-outputs` 사용
- iOS 시뮬레이터에서 카메라(바코드) 테스트 불가
