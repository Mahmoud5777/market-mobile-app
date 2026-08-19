import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/constants.dart';
import 'package:project/models/product.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/screens/cart_screen.dart';
import 'package:project/services/api_client.dart';
import 'package:project/widgets/common/auth_guard.dart';
import 'package:project/widgets/details/color_dot.dart';
import 'package:project/widgets/details/product_image.dart';

class DetailsBody extends StatefulWidget {
  final Product product;
  const DetailsBody({super.key, required this.product});

  @override
  State<DetailsBody> createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<DetailsBody> {
  int quantity = 1;
  bool isAdding = false;

  Future<void> _addToCart() async {
    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    setState(() => isAdding = true);
    try {
      await context.read<CartProvider>().addToCart(
            productId: widget.product.id,
            quantity: quantity,
            token: token,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Ajouté au panier ✅"),
          action: SnackBarAction(
            label: "Voir le panier",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ajouter au panier")),
      );
    } finally {
      if (mounted) setState(() => isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double totalPrice = widget.product.price * quantity;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(child: ProductImage(size: size, image: widget.product.image)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorDot(fillColor: kTextLightColor, isSelected: true),
                      ColorDot(fillColor: Colors.blue, isSelected: false),
                      ColorDot(fillColor: Colors.red, isSelected: false),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              if (quantity < widget.product.stock || widget.product.stock == 0) {
                                setState(() {
                                  quantity++;
                                });
                              }
                            },
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'prix : \$${widget.product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                color: kSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total : \$${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: kSecondaryColor,
                              ),
                            ),
                            if (widget.product.stock > 0)
                              Text(
                                '${widget.product.stock} en stock',
                                style: const TextStyle(fontSize: 13, color: kTextLightColor),
                              )
                            else
                              const Text(
                                'Rupture de stock',
                                style: TextStyle(fontSize: 13, color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 1.5,
              vertical: kDefaultPadding / 2,
            ),
            child: Text(
              widget.product.description,
              style: const TextStyle(color: Colors.white, fontSize: 19.0),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: (isAdding || widget.product.stock == 0) ? null : _addToCart,
                  child: isAdding
                      ? const SizedBox(
                          height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text(
                          'Ajouter au panier',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}