import 'package:project/models/cart_item_model.dart';
import 'package:project/services/api_client.dart';

class CartResult {
  final List<CartItemModel> items;
  final double total;
  const CartResult({required this.items, required this.total});

  factory CartResult.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return CartResult(
      items: itemsJson.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CartService {
  static Future<CartResult> fetchCart({required String token}) async {
    final json = await ApiClient.get('/api/cart', token: token);
    return CartResult.fromJson(json as Map<String, dynamic>);
  }

  static Future<CartResult> addItem({
    required int productId,
    required int quantity,
    required String token,
  }) async {
    final json = await ApiClient.post('/api/cart/items',
        body: {'productId': productId, 'quantity': quantity}, token: token);
    return CartResult.fromJson(json as Map<String, dynamic>);
  }

  static Future<CartResult> updateItem({
    required int itemId,
    required int quantity,
    required String token,
  }) async {
    // productId is required by the backend DTO but ignored for updates; the item is
    // identified by itemId. We don't have it here, so the provider passes it along instead
    // - see CartProvider.updateQuantity.
    final json = await ApiClient.put('/api/cart/items/$itemId',
        body: {'productId': 0, 'quantity': quantity}, token: token);
    return CartResult.fromJson(json as Map<String, dynamic>);
  }

  static Future<CartResult> removeItem({required int itemId, required String token}) async {
    final json = await ApiClient.delete('/api/cart/items/$itemId', token: token);
    return CartResult.fromJson(json as Map<String, dynamic>);
  }
}
