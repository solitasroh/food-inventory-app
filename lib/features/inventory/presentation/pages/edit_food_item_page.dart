import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/food_item.dart';
import '../providers/inventory_list_provider.dart';

class EditFoodItemPage extends ConsumerStatefulWidget {
  final String itemId;

  const EditFoodItemPage({
    super.key,
    required this.itemId,
  });

  @override
  ConsumerState<EditFoodItemPage> createState() => _EditFoodItemPageState();
}

class _EditFoodItemPageState extends ConsumerState<EditFoodItemPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _notesController;

  FoodCategory _selectedCategory = FoodCategory.other;
  StorageLocation _selectedLocation = StorageLocation.refrigerator;
  String _selectedUnit = '개';
  DateTime? _expirationDate;
  DateTime _purchaseDate = DateTime.now();
  DateTime? _openedDate;

  final List<String> _units = ['개', 'g', 'kg', 'ml', 'L', '팩', '봉', '병', '캔', '박스'];

  bool _isLoading = false;
  bool _isInitialized = false;
  FoodItem? _originalItem;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _priceController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeWithItem(FoodItem item) {
    if (_isInitialized) return;

    _originalItem = item;
    _nameController.text = item.name;
    _quantityController.text = item.quantity.toStringAsFixed(
      item.quantity.truncateToDouble() == item.quantity ? 0 : 1,
    );
    _priceController.text = item.price?.toStringAsFixed(0) ?? '';
    _notesController.text = item.notes ?? '';

    _selectedCategory = item.category;
    _selectedLocation = item.location;
    _selectedUnit = item.unit;
    _expirationDate = item.expirationDate;
    _purchaseDate = item.purchaseDate;
    _openedDate = item.openedDate;

    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryListProvider);

    return inventoryAsync.when(
      data: (items) {
        final item = items.where((i) => i.id == widget.itemId).firstOrNull;

        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('수정')),
            body: const Center(child: Text('식재료를 찾을 수 없습니다')),
          );
        }

        _initializeWithItem(item);
        return _buildForm();
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('수정')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('수정')),
        body: Center(child: Text('오류: $error')),
      ),
    );
  }

  Widget _buildForm() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식재료 수정'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showDiscardDialog(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveItem,
            child: const Text('저장'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            _buildNameField(),
            SizedBox(height: 16.h),
            _buildCategoryField(),
            SizedBox(height: 16.h),
            _buildLocationField(),
            SizedBox(height: 16.h),
            _buildQuantityAndUnitRow(),
            SizedBox(height: 16.h),
            _buildExpirationDateField(),
            SizedBox(height: 16.h),
            _buildPurchaseDateField(),
            SizedBox(height: 16.h),
            _buildOpenedDateField(),
            SizedBox(height: 16.h),
            _buildPriceField(),
            SizedBox(height: 16.h),
            _buildNotesField(),
            SizedBox(height: 32.h),
            _buildSaveButton(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: '식재료 이름 *',
        hintText: '예: 우유, 계란, 양파',
        prefixIcon: Icon(Icons.restaurant),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '식재료 이름을 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<FoodCategory>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: '카테고리 *',
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
          setState(() => _selectedCategory = value);
        }
      },
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '저장 위치 *',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.grey600,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<StorageLocation>(
            segments: StorageLocation.values.map((location) {
              return ButtonSegment(
                value: location,
                label: Text(
                  location.label,
                  style: TextStyle(fontSize: 12.sp),
                ),
                icon: Icon(_getLocationIcon(location), size: 18.w),
              );
            }).toList(),
            selected: {_selectedLocation},
            onSelectionChanged: (selected) {
              setState(() => _selectedLocation = selected.first);
            },
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityAndUnitRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: '수량 *',
              prefixIcon: Icon(Icons.numbers),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '수량 입력';
              }
              final quantity = double.tryParse(value);
              if (quantity == null || quantity <= 0) {
                return '올바른 수량';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<String>(
            value: _selectedUnit,
            decoration: const InputDecoration(
              labelText: '단위',
            ),
            items: _units.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Text(unit),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedUnit = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpirationDateField() {
    return InkWell(
      onTap: () => _selectExpirationDate(),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '유통기한',
          prefixIcon: const Icon(Icons.event),
          suffixIcon: _expirationDate != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _expirationDate = null),
                )
              : null,
        ),
        child: Text(
          _expirationDate != null
              ? DateFormat('yyyy년 MM월 dd일').format(_expirationDate!)
              : '유통기한 선택 (선택사항)',
          style: TextStyle(
            color: _expirationDate != null ? null : AppColors.grey500,
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseDateField() {
    return InkWell(
      onTap: () => _selectPurchaseDate(),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: '구매일 *',
          prefixIcon: Icon(Icons.shopping_cart),
        ),
        child: Text(
          DateFormat('yyyy년 MM월 dd일').format(_purchaseDate),
        ),
      ),
    );
  }

  Widget _buildOpenedDateField() {
    return InkWell(
      onTap: () => _selectOpenedDate(),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '개봉일',
          prefixIcon: const Icon(Icons.lock_open),
          suffixIcon: _openedDate != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _openedDate = null),
                )
              : null,
        ),
        child: Text(
          _openedDate != null
              ? DateFormat('yyyy년 MM월 dd일').format(_openedDate!)
              : '개봉일 선택 (선택사항)',
          style: TextStyle(
            color: _openedDate != null ? null : AppColors.grey500,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      decoration: const InputDecoration(
        labelText: '가격 (선택)',
        hintText: '예: 3500',
        prefixIcon: Icon(Icons.attach_money),
        suffixText: '원',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: '메모 (선택)',
        hintText: '추가 정보를 입력하세요',
        prefixIcon: Icon(Icons.notes),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      textInputAction: TextInputAction.newline,
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 52.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveItem,
        child: _isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                '저장',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _selectExpirationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      helpText: '유통기한 선택',
      cancelText: '취소',
      confirmText: '확인',
    );

    if (picked != null) {
      setState(() => _expirationDate = picked);
    }
  }

  Future<void> _selectPurchaseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      helpText: '구매일 선택',
      cancelText: '취소',
      confirmText: '확인',
    );

    if (picked != null) {
      setState(() => _purchaseDate = picked);
    }
  }

  Future<void> _selectOpenedDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _openedDate ?? DateTime.now(),
      firstDate: _purchaseDate,
      lastDate: DateTime.now(),
      helpText: '개봉일 선택',
      cancelText: '취소',
      confirmText: '확인',
    );

    if (picked != null) {
      setState(() => _openedDate = picked);
    }
  }

  bool _hasChanges() {
    if (_originalItem == null) return false;

    return _nameController.text.trim() != _originalItem!.name ||
        _selectedCategory != _originalItem!.category ||
        _selectedLocation != _originalItem!.location ||
        double.tryParse(_quantityController.text) != _originalItem!.quantity ||
        _selectedUnit != _originalItem!.unit ||
        _expirationDate != _originalItem!.expirationDate ||
        _purchaseDate != _originalItem!.purchaseDate ||
        _openedDate != _originalItem!.openedDate ||
        (_priceController.text.isNotEmpty
            ? double.tryParse(_priceController.text)
            : null) != _originalItem!.price ||
        (_notesController.text.isNotEmpty
            ? _notesController.text.trim()
            : null) != _originalItem!.notes;
  }

  void _showDiscardDialog() {
    if (!_hasChanges()) {
      context.pop();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('변경 사항 취소'),
        content: const Text('저장하지 않은 변경 사항이 있습니다. 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('계속 수정'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_originalItem == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedItem = _originalItem!.copyWith(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        location: _selectedLocation,
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        expirationDate: _expirationDate,
        purchaseDate: _purchaseDate,
        openedDate: _openedDate,
        price: _priceController.text.isNotEmpty
            ? double.parse(_priceController.text)
            : null,
        notes: _notesController.text.isNotEmpty
            ? _notesController.text.trim()
            : null,
        updatedAt: DateTime.now(),
      );

      await ref.read(inventoryListProvider.notifier).updateItem(updatedItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${updatedItem.name}이(가) 수정되었습니다'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  IconData _getLocationIcon(StorageLocation location) {
    switch (location) {
      case StorageLocation.refrigerator:
        return Icons.kitchen;
      case StorageLocation.freezer:
        return Icons.ac_unit;
      case StorageLocation.pantry:
        return Icons.shelves;
      case StorageLocation.other:
        return Icons.inventory;
    }
  }
}
