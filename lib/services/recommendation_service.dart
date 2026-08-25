import 'package:project/models/recommendation_model.dart';
import 'package:project/services/api_client.dart';

class RecommendationService {
  static Future<List<RecommendationModel>> fetchMyRecommendations({required String token}) async {
    final json = await ApiClient.get('/api/recommendations/me', token: token) as List<dynamic>;
    return json.map((e) => RecommendationModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}