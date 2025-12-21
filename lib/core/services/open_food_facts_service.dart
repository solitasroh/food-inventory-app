import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductInfo {
  final String barcode;
  final String? name;
  final String? brand;
  final String? quantity;
  final String? imageUrl;
  final String? categories;

  ProductInfo({
    required this.barcode,
    this.name,
    this.brand,
    this.quantity,
    this.imageUrl,
    this.categories,
  });

  factory ProductInfo.fromJson(String barcode, Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;
    if (product == null) {
      return ProductInfo(barcode: barcode);
    }

    return ProductInfo(
      barcode: barcode,
      name: product['product_name_ko'] as String? ??
          product['product_name'] as String?,
      brand: product['brands'] as String?,
      quantity: product['quantity'] as String?,
      imageUrl: product['image_front_url'] as String?,
      categories: product['categories'] as String?,
    );
  }

  bool get hasData => name != null || brand != null;

  String get displayName {
    if (name != null && brand != null) {
      return '$brand $name';
    }
    return name ?? brand ?? '알 수 없는 제품';
  }
}

class OpenFoodFactsService {
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v2';

  Future<ProductInfo?> getProductByBarcode(String barcode) async {
    try {
      final url = Uri.parse('$_baseUrl/product/$barcode.json');
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'FoodInventoryApp/1.0.0 (Flutter)',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final status = json['status'] as int?;

        if (status == 1) {
          return ProductInfo.fromJson(barcode, json);
        }
      }

      return ProductInfo(barcode: barcode);
    } catch (e) {
      return null;
    }
  }
}
