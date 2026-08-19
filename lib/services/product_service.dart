import 'package:image_picker/image_picker.dart';
import 'package:project/models/product.dart';
import 'package:project/services/api_client.dart';

class ProductService {
  static Future<List<Product>> fetchAll() async {
    final json = await ApiClient.get('/api/products') as List<dynamic>;
    return json.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Product> fetchById(int id) async {
    final json = await ApiClient.get('/api/products/$id');
    return Product.fromJson(json as Map<String, dynamic>);
  }

  static Future<Product> create(Product product, {required String token}) async {
    final json = await ApiClient.post('/api/products', body: product.toRequestJson(), token: token);
    return Product.fromJson(json as Map<String, dynamic>);
  }

  static Future<Product> update(int id, Product product, {required String token}) async {
    final json = await ApiClient.put('/api/products/$id', body: product.toRequestJson(), token: token);
    return Product.fromJson(json as Map<String, dynamic>);
  }

  static Future<void> delete(int id, {required String token}) async {
    await ApiClient.delete('/api/products/$id', token: token);
  }

  /// Uploads [file] (picked via image_picker) as the product's image.
  /// Works on mobile and web since it reads bytes rather than a filesystem path.
  static Future<Product> uploadImage(int productId, XFile file, {required String token}) async {
    final bytes = await file.readAsBytes();
    final json = await ApiClient.uploadBytes(
      '/api/products/$productId/image',
      bytes,
      file.name,
      token: token,
    );
    return Product.fromJson(json as Map<String, dynamic>);
  }
}