import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/services/open_food_facts_service.dart';
import '../../../../core/theme/app_colors.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  final OpenFoodFactsService _apiService = OpenFoodFactsService();

  bool _isProcessing = false;
  String? _lastScannedCode;
  bool _torchEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('바코드 스캔'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(_torchEnabled ? Icons.flash_on : Icons.flash_off),
            onPressed: () async {
              await _controller.toggleTorch();
              setState(() => _torchEnabled = !_torchEnabled);
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          _buildScanOverlay(),
          if (_isProcessing) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return Center(
      child: Container(
        width: 280.w,
        height: 180.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '바코드를 사각형 안에 맞춰주세요',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 16.h),
                Text(
                  '제품 정보 검색 중...',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final code = barcode.rawValue;

    if (code == null || code == _lastScannedCode) return;

    _lastScannedCode = code;
    setState(() => _isProcessing = true);

    try {
      final productInfo = await _apiService.getProductByBarcode(code);

      if (!mounted) return;

      if (productInfo != null) {
        _showProductDialog(productInfo);
      } else {
        _showErrorDialog(code);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showProductDialog(ProductInfo product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(product.hasData ? '제품 정보' : '제품을 찾을 수 없음'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrl != null) ...[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    product.imageUrl!,
                    height: 120.h,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.image_not_supported,
                      size: 60.w,
                      color: AppColors.grey400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
            _buildInfoRow('바코드', product.barcode),
            if (product.name != null) _buildInfoRow('제품명', product.name!),
            if (product.brand != null) _buildInfoRow('브랜드', product.brand!),
            if (product.quantity != null) _buildInfoRow('용량', product.quantity!),
            if (!product.hasData) ...[
              SizedBox(height: 8.h),
              Text(
                'Open Food Facts에 등록되지 않은 제품입니다.\n바코드 정보만 사용합니다.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.grey600,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _lastScannedCode = null;
            },
            child: const Text('다시 스캔'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(product);
            },
            child: const Text('사용하기'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String barcode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: const Text('제품 정보를 가져오는 중 오류가 발생했습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _lastScannedCode = null;
            },
            child: const Text('다시 시도'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(ProductInfo(barcode: barcode));
            },
            child: const Text('바코드만 사용'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.grey600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
