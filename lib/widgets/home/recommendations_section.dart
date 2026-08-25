import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/constants.dart';
import 'package:project/models/recommendation_model.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/screens/details_screen.dart';
import 'package:project/services/recommendation_service.dart';
import 'package:project/widgets/common/smart_image.dart';

/// Shows a horizontal row of recommended products for the logged-in user.
/// Renders nothing (SizedBox.shrink) if the user isn't logged in, if the
/// backend has no recommendations yet, or if the request fails - this is a
/// "nice to have" section, never worth showing an error banner for.
class RecommendationsSection extends StatefulWidget {
  const RecommendationsSection({super.key});

  @override
  State<RecommendationsSection> createState() => _RecommendationsSectionState();
}

class _RecommendationsSectionState extends State<RecommendationsSection> {
  List<RecommendationModel> _recommendations = [];
  bool _isLoading = true;
  String? _lastLoadedToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final token = context.watch<AuthProvider>().token;
    if (token != null && token != _lastLoadedToken) {
      _lastLoadedToken = token;
      _load(token);
    } else if (token == null) {
      setState(() {
        _recommendations = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _load(String token) async {
    setState(() => _isLoading = true);
    try {
      final recs = await RecommendationService.fetchMyRecommendations(token: token);
      if (!mounted) return;
      setState(() {
        _recommendations = recs;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _recommendations = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isAuthenticated || _isLoading || _recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              'Recommandé pour vous',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextColor),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                final rec = _recommendations[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailsScreen(product: rec.product)),
                    );
                  },
                  child: Container(
                    width: 130,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: SmartImage(
                            path: rec.product.image,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rec.product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${rec.product.price.toStringAsFixed(2)}',
                                style: const TextStyle(color: kSecondaryColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}