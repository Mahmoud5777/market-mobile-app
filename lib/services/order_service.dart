import 'package:project/services/api_client.dart';

class OrderService {
  static Future<Map<String, dynamic>> checkout({
    required String paymentMethod,
    String? cardLast4,
    required String token,
  }) async {
    final json = await ApiClient.post('/api/orders/checkout', body: {
      'paymentMethod': paymentMethod,
      if (cardLast4 != null) 'cardLast4': cardLast4,
    }, token: token);
    return json as Map<String, dynamic>;
  }

  static Future<List<dynamic>> fetchOrders({required String token}) async {
    final json = await ApiClient.get('/api/orders', token: token);
    return json as List<dynamic>;
  }
}
