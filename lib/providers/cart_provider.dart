import 'package:flutter/material.dart';
import 'package:project/models/cart_item_model.dart';
import 'package:project/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItemModel> _items = [];
  double _total = 0.0;
  bool _isLoading = false;
  String? _error;

  List<CartItemModel> get items => _items;
  double get total => _total;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> loadCart(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await CartService.fetchCart(token: token);
      _items = result.items;
      _total = result.total;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart({required int productId, required int quantity, required String token}) async {
    final result = await CartService.addItem(productId: productId, quantity: quantity, token: token);
    _items = result.items;
    _total = result.total;
    notifyListeners();
  }

  Future<void> updateQuantity({required int itemId, required int quantity, required String token}) async {
    final result = await CartService.updateItem(itemId: itemId, quantity: quantity, token: token);
    _items = result.items;
    _total = result.total;
    notifyListeners();
  }

  Future<void> removeItem({required int itemId, required String token}) async {
    final result = await CartService.removeItem(itemId: itemId, token: token);
    _items = result.items;
    _total = result.total;
    notifyListeners();
  }

  /// Called right after a successful checkout - the backend already emptied the cart.
  void clearLocally() {
    _items = [];
    _total = 0.0;
    notifyListeners();
  }
}
