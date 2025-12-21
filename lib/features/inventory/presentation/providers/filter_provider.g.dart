// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedLocationHash() => r'33be6316ab96217cc5ffafbc87c0a515716ad557';

/// See also [SelectedLocation].
@ProviderFor(SelectedLocation)
final selectedLocationProvider =
    AutoDisposeNotifierProvider<SelectedLocation, StorageLocation?>.internal(
  SelectedLocation.new,
  name: r'selectedLocationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedLocation = AutoDisposeNotifier<StorageLocation?>;
String _$selectedCategoryHash() => r'a580e48b16c09b59245380551d1b02113daf1686';

/// See also [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, FoodCategory?>.internal(
  SelectedCategory.new,
  name: r'selectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategory = AutoDisposeNotifier<FoodCategory?>;
String _$selectedSortHash() => r'7b47b291deb48ab20f457c31bbeb7d77916cac43';

/// See also [SelectedSort].
@ProviderFor(SelectedSort)
final selectedSortProvider =
    AutoDisposeNotifierProvider<SelectedSort, SortOption>.internal(
  SelectedSort.new,
  name: r'selectedSortProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedSortHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSort = AutoDisposeNotifier<SortOption>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
