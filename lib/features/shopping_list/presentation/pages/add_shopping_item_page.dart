import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/food_subcategories_data.dart';
import '../../../../core/services/shelf_life_service.dart';
import '../../../inventory/domain/entities/enums.dart';
import '../../domain/entities/shopping_enums.dart';
import '../../domain/entities/shopping_item.dart';
import '../providers/shopping_list_provider.dart';

/// 쇼핑 아이템 추가/수정 페이지
class AddShoppingItemPage extends ConsumerStatefulWidget {
  final ShoppingItem? editItem;

  const AddShoppingItemPage({super.key, this.editItem});

  @override
  ConsumerState<AddShoppingItemPage> createState() =>
      _AddShoppingItemPageState();
}

class _AddShoppingItemPageState extends ConsumerState<AddShoppingItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _notesController = TextEditingController();

  final _shelfLifeService = ShelfLifeService();

  FoodCategory _category = FoodCategory.other;
  ShoppingPriority _priority = ShoppingPriority.medium;

  List<String> _suggestions = [];
  bool _showSuggestions = false;

  bool get _isEditing => widget.editItem != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      final item = widget.editItem!;
      _nameController.text = item.name;
      _quantityController.text = item.quantity.toString();
      _unitController.text = item.unit;
      _notesController.text = item.notes ?? '';
      _category = item.category;
      _priority = item.priority;
    } else {
      _quantityController.text = '1';
      _unitController.text = '개';
    }

    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    final query = _nameController.text.trim();
    if (query.length >= 1) {
      final results = _shelfLifeService.searchSubCategories(query);
      setState(() {
        _suggestions = results.map((r) => r.name).take(5).toList();
        _showSuggestions = _suggestions.isNotEmpty;
      });

      // 카테고리 자동 설정
      if (results.isNotEmpty) {
        final bestMatch = results.first;
        setState(() {
          _category = bestMatch.category;
        });
      }
    } else {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
    }
  }

  void _selectSuggestion(String name) {
    _nameController.text = name;
    _nameController.selection = TextSelection.fromPosition(
      TextPosition(offset: name.length),
    );
    setState(() {
      _showSuggestions = false;
    });

    // 카테고리 자동 설정
    final results = _shelfLifeService.searchSubCategories(name);
    if (results.isNotEmpty) {
      setState(() {
        _category = results.first.category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final frequentItemsAsync = ref.watch(frequentItemsProvider);
    final recentItemsAsync = ref.watch(recentItemsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // 드래그 핸들
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 헤더
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      _isEditing ? '항목 수정' : '항목 추가',
                      style: theme.textTheme.titleLarge,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _submit,
                      child: Text(_isEditing ? '저장' : '추가'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // 콘텐츠
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 빠른 추가 (새 항목일 때만)
                    if (!_isEditing) ...[
                      _buildQuickAddSection(
                        context,
                        frequentItemsAsync,
                        recentItemsAsync,
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        '직접 입력',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // 폼
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 이름 입력
                          _buildNameField(),
                          const SizedBox(height: 16),
                          // 수량 및 단위
                          Row(
                            children: [
                              Expanded(flex: 2, child: _buildQuantityField()),
                              const SizedBox(width: 16),
                              Expanded(flex: 1, child: _buildUnitField()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // 카테고리
                          _buildCategoryDropdown(),
                          const SizedBox(height: 16),
                          // 우선순위
                          _buildPrioritySelector(),
                          const SizedBox(height: 16),
                          // 메모
                          _buildNotesField(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAddSection(
    BuildContext context,
    AsyncValue<List<String>> frequentItems,
    AsyncValue<List<String>> recentItems,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 자주 구매 항목
        Text(
          '자주 구매',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        frequentItems.when(
          data: (items) => items.isEmpty
              ? Text(
                  '구매 이력이 없습니다',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items
                      .map((name) => _buildQuickAddChip(context, name))
                      .toList(),
                ),
          loading: () => const SizedBox(
            height: 32,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        // 최근 구매 항목
        Text(
          '최근 구매',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        recentItems.when(
          data: (items) => items.isEmpty
              ? Text(
                  '구매 이력이 없습니다',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items
                      .map((name) => _buildQuickAddChip(context, name))
                      .toList(),
                ),
          loading: () => const SizedBox(
            height: 32,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildQuickAddChip(BuildContext context, String name) {
    return ActionChip(
      label: Text(name),
      onPressed: () => _quickAdd(name),
      avatar: const Icon(Icons.add, size: 16),
    );
  }

  Future<void> _quickAdd(String name) async {
    // 카테고리 찾기
    final results = _shelfLifeService.searchSubCategories(name);
    final category =
        results.isNotEmpty ? results.first.category : FoodCategory.other;

    await ref.read(shoppingListProvider.notifier).addItem(
          name: name,
          category: category,
          quantity: 1,
          unit: '개',
          suggestedBy: SuggestionSource.frequent,
        );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name을(를) 추가했습니다')),
      );
    }
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: '품목명',
            hintText: '예: 우유, 계란, 양파',
            prefixIcon: Icon(Icons.shopping_basket),
          ),
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '품목명을 입력해주세요';
            }
            return null;
          },
        ),
        // 자동완성 제안
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _suggestions.map((suggestion) {
                return InkWell(
                  onTap: () => _selectSuggestion(suggestion),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(suggestion),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: _quantityController,
      decoration: const InputDecoration(
        labelText: '수량',
        prefixIcon: Icon(Icons.numbers),
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '수량을 입력해주세요';
        }
        if (double.tryParse(value) == null) {
          return '올바른 숫자를 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _buildUnitField() {
    return TextFormField(
      controller: _unitController,
      decoration: const InputDecoration(
        labelText: '단위',
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<FoodCategory>(
      value: _category,
      decoration: const InputDecoration(
        labelText: '카테고리',
        prefixIcon: Icon(Icons.category),
      ),
      items: FoodCategory.values.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category.label),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _category = value);
        }
      },
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '우선순위',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<ShoppingPriority>(
          segments: ShoppingPriority.values.map((priority) {
            return ButtonSegment(
              value: priority,
              label: Text(priority.label),
              icon: Icon(_getPriorityIcon(priority)),
            );
          }).toList(),
          selected: {_priority},
          onSelectionChanged: (selected) {
            setState(() => _priority = selected.first);
          },
        ),
      ],
    );
  }

  IconData _getPriorityIcon(ShoppingPriority priority) {
    switch (priority) {
      case ShoppingPriority.high:
        return Icons.priority_high;
      case ShoppingPriority.medium:
        return Icons.remove;
      case ShoppingPriority.low:
        return Icons.arrow_downward;
    }
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: '메모 (선택)',
        hintText: '브랜드, 용량 등',
        prefixIcon: Icon(Icons.notes),
      ),
      maxLines: 2,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final quantity = double.parse(_quantityController.text);
    final unit = _unitController.text.trim().isEmpty
        ? '개'
        : _unitController.text.trim();
    final notes =
        _notesController.text.trim().isEmpty ? null : _notesController.text;

    if (_isEditing) {
      final updatedItem = widget.editItem!.copyWith(
        name: name,
        category: _category,
        quantity: quantity,
        unit: unit,
        priority: _priority,
        notes: notes,
      );
      await ref.read(shoppingListProvider.notifier).updateItem(updatedItem);
    } else {
      await ref.read(shoppingListProvider.notifier).addItem(
            name: name,
            category: _category,
            quantity: quantity,
            unit: unit,
            priority: _priority,
            notes: notes,
          );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
