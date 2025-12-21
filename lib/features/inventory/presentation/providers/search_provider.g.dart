// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredItemsHash() => r'37532fa29f8836249da3cb33fef4aa7fff174a02';

/// See also [filteredItems].
@ProviderFor(filteredItems)
final filteredItemsProvider = AutoDisposeProvider<List<FoodItem>>.internal(
  filteredItems,
  name: r'filteredItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredItemsRef = AutoDisposeProviderRef<List<FoodItem>>;
String _$filteredItemsCountHash() =>
    r'5ad88303647606290274dfefcd2786a4873a729b';

/// See also [filteredItemsCount].
@ProviderFor(filteredItemsCount)
final filteredItemsCountProvider = AutoDisposeProvider<int>.internal(
  filteredItemsCount,
  name: r'filteredItemsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredItemsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredItemsCountRef = AutoDisposeProviderRef<int>;
String _$totalItemsCountHash() => r'e4a2ebdbb833eb03ba49a05c61e28148de6ddf4b';

/// See also [totalItemsCount].
@ProviderFor(totalItemsCount)
final totalItemsCountProvider = AutoDisposeProvider<int>.internal(
  totalItemsCount,
  name: r'totalItemsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalItemsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TotalItemsCountRef = AutoDisposeProviderRef<int>;
String _$itemsCountByLocationHash() =>
    r'cf46a812ba266197f90765e7c05b2b4cab0309b0';

/// See also [itemsCountByLocation].
@ProviderFor(itemsCountByLocation)
final itemsCountByLocationProvider =
    AutoDisposeProvider<Map<String, int>>.internal(
  itemsCountByLocation,
  name: r'itemsCountByLocationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$itemsCountByLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ItemsCountByLocationRef = AutoDisposeProviderRef<Map<String, int>>;
String _$searchQueryHash() => r'b07ebd22fb9cb0db36c8d833cc6e21f4fcbd9b7b';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$isSearchingHash() => r'72d368f3f2254b26cec663e3c49e922cbb5df20c';

/// See also [IsSearching].
@ProviderFor(IsSearching)
final isSearchingProvider =
    AutoDisposeNotifierProvider<IsSearching, bool>.internal(
  IsSearching.new,
  name: r'isSearchingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isSearchingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsSearching = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
