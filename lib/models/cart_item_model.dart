import 'package:project/models/product.dart';

class CartItemModel {
  final int id;
  final Product product;
  final int quantity;
  final double subtotal;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}
