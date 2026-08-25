import 'package:project/models/product.dart';

class RecommendationModel {
  final Product product;
  final double score;

  const RecommendationModel({required this.product, required this.score});

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      score: (json['score'] as num).toDouble(),
    );
  }
}