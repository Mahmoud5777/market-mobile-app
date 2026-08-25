import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/constants.dart';
import 'package:project/providers/products_provider.dart';
import 'package:project/screens/details_screen.dart';
import 'package:project/widgets/home/product_card.dart';
import 'package:project/widgets/home/recommendations_section.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    // Fetch the product list from the backend as soon as the screen is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductsProvider>();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 70.0),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () => context.read<ProductsProvider>().fetchProducts(),
                  child: Builder(builder: (context) {
                    if (productsProvider.isLoading && productsProvider.products.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (productsProvider.error != null && productsProvider.products.isEmpty) {
                      return ListView(
                        children: [
                          const SizedBox(height: 120),
                          Icon(Icons.wifi_off, size: 48, color: kTextLightColor),
                          const SizedBox(height: 12),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Impossible de charger les produits.\nVérifie que le serveur backend est démarré.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: kTextLightColor),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    final products = productsProvider.products;

                    // index 0 = section "Recommandé pour vous" (invisible si rien à
                    // afficher), les index suivants = la liste normale de produits.
                    return ListView.builder(
                      itemCount: products.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return const RecommendationsSection();
                        }
                        final product = products[index - 1];
                        return ProductCard(
                          itemindex: index - 1,
                          product: product,
                          press: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(product: product),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}