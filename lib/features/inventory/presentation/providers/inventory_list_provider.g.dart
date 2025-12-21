// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expiringItemsHash() => r'2ee4d64a8d3fd30498fea1e89e38892b84046d56';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [expiringItems].
@ProviderFor(expiringItems)
const expiringItemsProvider = ExpiringItemsFamily();

/// See also [expiringItems].
class ExpiringItemsFamily extends Family<AsyncValue<List<FoodItem>>> {
  /// See also [expiringItems].
  const ExpiringItemsFamily();

  /// See also [expiringItems].
  ExpiringItemsProvider call({
    int days = 3,
  }) {
    return ExpiringItemsProvider(
      days: days,
    );
  }

  @override
  ExpiringItemsProvider getProviderOverride(
    covariant ExpiringItemsProvider provider,
  ) {
    return call(
      days: provider.days,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expiringItemsProvider';
}

/// See also [expiringItems].
class ExpiringItemsProvider extends AutoDisposeFutureProvider<List<FoodItem>> {
  /// See also [expiringItems].
  ExpiringItemsProvider({
    int days = 3,
  }) : this._internal(
          (ref) => expiringItems(
            ref as ExpiringItemsRef,
            days: days,
          ),
          from: expiringItemsProvider,
          name: r'expiringItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expiringItemsHash,
          dependencies: ExpiringItemsFamily._dependencies,
          allTransitiveDependencies:
              ExpiringItemsFamily._allTransitiveDependencies,
          days: days,
        );

  ExpiringItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    FutureOr<List<FoodItem>> Function(ExpiringItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpiringItemsProvider._internal(
        (ref) => create(ref as ExpiringItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<FoodItem>> createElement() {
    return _ExpiringItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpiringItemsProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExpiringItemsRef on AutoDisposeFutureProviderRef<List<FoodItem>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _ExpiringItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<FoodItem>>
    with ExpiringItemsRef {
  _ExpiringItemsProviderElement(super.provider);

  @override
  int get days => (origin as ExpiringItemsProvider).days;
}

String _$expiredItemsHash() => r'71c5bc6e53367e24bf36bae0708d940cf0e32870';

/// See also [expiredItems].
@ProviderFor(expiredItems)
final expiredItemsProvider = AutoDisposeFutureProvider<List<FoodItem>>.internal(
  expiredItems,
  name: r'expiredItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$expiredItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ExpiredItemsRef = AutoDisposeFutureProviderRef<List<FoodItem>>;
String _$inventoryListHash() => r'ee7492d59568d7c1ce4924c45c44bd8efc2c3cb0';

/// See also [InventoryList].
@ProviderFor(InventoryList)
final inventoryListProvider =
    AutoDisposeAsyncNotifierProvider<InventoryList, List<FoodItem>>.internal(
  InventoryList.new,
  name: r'inventoryListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InventoryList = AutoDisposeAsyncNotifier<List<FoodItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
