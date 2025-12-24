import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/data/food_subcategory.dart';
import '../../../../core/services/open_food_facts_service.dart';
import '../../../../core/services/shelf_life_service.dart';
import '../../../../core/services/product_lookup_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/food_item.dart';
import '../providers/inventory_list_provider.dart';

class AddFoodItemPage extends ConsumerStatefulWidget {
  const AddFoodItemPage({super.key});

  @override
  ConsumerState<AddFoodItemPage> createState() => _AddFoodItemPageState();
}

class _AddFoodItemPageState extends ConsumerState<AddFoodItemPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  FoodCategory _selectedCategory = FoodCategory.other;
  StorageLocation _selectedLocation = StorageLocation.refrigerator;
  String _selectedUnit = '개';
  DateTime? _expirationDate;
  DateTime _purchaseDate = DateTime.now();

  final List<String> _units = ['개', 'g', 'kg', 'ml', 'L', '팩', '봉', '병', '캔', '박스'];

  bool _isLoading = false;
  String? _scannedBarcode;
  String? _productImageUrl;

  // 새로운 상태 변수들
  final ShelfLifeService _shelfLifeService = ShelfLifeService();
  ShelfLifeRecommendation? _shelfLifeRecommendation;
  bool _isExpirationAutoSet = false;
  List<String> _nameSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    final query = _nameController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _nameSuggestions = _shelfLifeService.getSuggestions(query, limit: 5);
        _showSuggestions = _nameSuggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _nameSuggestions = [];
        _showSuggestions = false;
      });
    }
  }

  void _selectSuggestion(String suggestion) {
    _nameController.text = suggestion;
    _nameController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    setState(() {
      _showSuggestions = false;
    });
    _updateShelfLifeRecommendation();
  }

  void _updateShelfLifeRecommendation() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _shelfLifeRecommendation = null;
        _isExpirationAutoSet = false;
      });
      return;
    }

    final recommendation = _shelfLifeService.recommend(
      name: name,
      location: _selectedLocation,
      category: _selectedCategory,
    );

    setState(() {
      _shelfLifeRecommendation = recommendation;
    });

    // 유통기한이 아직 설정되지 않았으면 자동 설정
    if (_expirationDate == null && recommendation != null && recommendation.confidence >= 0.5) {
      setState(() {
        _expirationDate = recommendation.expirationDate;
        _isExpirationAutoSet = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식재료 추가'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: '바코드 스캔',
            onPressed: _openBarcodeScanner,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            if (_scannedBarcode != null) ...[
              _buildScannedProductCard(),
              SizedBox(height: 16.h),
            ],
            _buildNameFieldWithSuggestions(),
            SizedBox(height: 16.h),
            _buildCategoryField(),
            SizedBox(height: 16.h),
            _buildLocationField(),
            SizedBox(height: 16.h),
            _buildQuantityAndUnitRow(),
            SizedBox(height: 16.h),
            _buildExpirationDateField(),
            if (_shelfLifeRecommendation != null) ...[
              SizedBox(height: 8.h),
              _buildShelfLifeRecommendationCard(),
            ],
            SizedBox(height: 16.h),
            _buildPurchaseDateField(),
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

  Widget _buildNameFieldWithSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: '식재료 이름 *',
            hintText: '예: 우유, 계란, 양파',
            prefixIcon: Icon(Icons.restaurant),
          ),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            setState(() => _showSuggestions = false);
            _updateShelfLifeRecommendation();
            FocusScope.of(context).nextFocus();
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '식재료 이름을 입력해주세요';
            }
            return null;
          },
        ),
        if (_showSuggestions && _nameSuggestions.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _nameSuggestions.map((suggestion) {
                return InkWell(
                  onTap: () => _selectSuggestion(suggestion),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 18.w,
                          color: AppColors.grey500,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          suggestion,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
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
          _updateShelfLifeRecommendation();
        }
      },
      validator: (value) {
        if (value == null) {
          return '카테고리를 선택해주세요';
        }
        return null;
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
              _updateShelfLifeRecommendation();
            },
            style: ButtonStyle(
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
                  onPressed: () {
                    setState(() {
                      _expirationDate = null;
                      _isExpirationAutoSet = false;
                    });
                  },
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _expirationDate != null
                    ? DateFormat('yyyy년 MM월 dd일').format(_expirationDate!)
                    : '유통기한 선택 (선택사항)',
                style: TextStyle(
                  color: _expirationDate != null ? null : AppColors.grey500,
                ),
              ),
            ),
            if (_isExpirationAutoSet)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '자동',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildShelfLifeRecommendationCard() {
    final recommendation = _shelfLifeRecommendation!;
    final confidenceColor = recommendation.confidence >= 0.7
        ? AppColors.success
        : recommendation.confidence >= 0.5
            ? AppColors.warning
            : AppColors.grey500;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16.w,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                '보관기간 추천',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: confidenceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '신뢰도 ${(recommendation.confidence * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: confidenceColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${recommendation.days}일 (${recommendation.reason})',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.grey700,
            ),
          ),
          if (recommendation.matchedSubCategory != null) ...[
            SizedBox(height: 4.h),
            Text(
              '매칭: ${recommendation.matchedSubCategory!.name}',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.grey500,
              ),
            ),
          ],
          if (!_isExpirationAutoSet && recommendation.confidence >= 0.5) ...[
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _expirationDate = recommendation.expirationDate;
                    _isExpirationAutoSet = true;
                  });
                },
                icon: Icon(Icons.check, size: 16.w),
                label: const Text('이 날짜로 설정'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  textStyle: TextStyle(fontSize: 12.sp),
                ),
              ),
            ),
          ],
        ],
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
      setState(() {
        _expirationDate = picked;
        _isExpirationAutoSet = false;
      });
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

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newItem = FoodItem(
        id: '', // Provider에서 UUID 생성
        name: _nameController.text.trim(),
        barcode: _scannedBarcode,
        category: _selectedCategory,
        location: _selectedLocation,
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        expirationDate: _expirationDate,
        purchaseDate: _purchaseDate,
        price: _priceController.text.isNotEmpty
            ? double.parse(_priceController.text)
            : null,
        imageUrl: _productImageUrl,
        notes: _notesController.text.isNotEmpty
            ? _notesController.text.trim()
            : null,
        createdAt: DateTime.now(),
      );

      await ref.read(inventoryListProvider.notifier).addItem(newItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newItem.name}이(가) 추가되었습니다'),
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

  Future<void> _openBarcodeScanner() async {
    final result = await context.push<ProductInfo>('/scan');

    if (result != null && mounted) {
      setState(() {
        _scannedBarcode = result.barcode;
        _productImageUrl = result.imageUrl;

        if (result.name != null && result.name!.isNotEmpty) {
          _nameController.text = result.displayName;
        }
      });

      // 스캔된 제품으로 유통기한 추천 업데이트
      _updateShelfLifeRecommendation();

      if (result.hasData) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.displayName} 정보를 불러왔습니다'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildScannedProductCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            if (_productImageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  _productImageUrl!,
                  width: 60.w,
                  height: 60.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.grey400,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
            ] else ...[
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.qr_code,
                  color: AppColors.primary,
                  size: 32.w,
                ),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '바코드 스캔됨',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _scannedBarcode!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _scannedBarcode = null;
                  _productImageUrl = null;
                });
              },
              tooltip: '바코드 제거',
            ),
          ],
        ),
      ),
    );
  }
}
