import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/models/product.dart';
import 'package:project/services/product_service.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await ProductService.fetchAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product> createProduct(Product product, {required String token}) async {
    final created = await ProductService.create(product, token: token);
    await fetchProducts();
    return created;
  }

  Future<Product> updateProduct(int id, Product product, {required String token}) async {
    final updated = await ProductService.update(id, product, token: token);
    await fetchProducts();
    return updated;
  }

  Future<void> deleteProduct(int id, {required String token}) async {
    await ProductService.delete(id, token: token);
    await fetchProducts();
  }

  Future<void> uploadProductImage(int productId, XFile file, {required String token}) async {
    await ProductService.uploadImage(productId, file, token: token);
    await fetchProducts();
  }
}