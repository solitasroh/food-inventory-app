import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/enums.dart';

part 'filter_provider.g.dart';

@riverpod
class SelectedLocation extends _$SelectedLocation {
  @override
  StorageLocation? build() => null;

  void select(StorageLocation? location) {
    state = location;
  }

  void clear() {
    state = null;
  }

  void toggle(StorageLocation location) {
    state = state == location ? null : location;
  }
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  FoodCategory? build() => null;

  void select(FoodCategory? category) {
    state = category;
  }

  void clear() {
    state = null;
  }

  void toggle(FoodCategory category) {
    state = state == category ? null : category;
  }
}

enum SortOption {
  name('이름순'),
  expirationDate('유통기한순'),
  purchaseDate('구매일순'),
  category('카테고리순');

  final String label;
  const SortOption(this.label);
}

@riverpod
class SelectedSort extends _$SelectedSort {
  @override
  SortOption build() => SortOption.expirationDate;

  void select(SortOption option) {
    state = option;
  }
}
