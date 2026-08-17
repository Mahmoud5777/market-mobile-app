import 'package:flutter/material.dart';
import 'package:project/constants.dart';
import 'package:project/models/product.dart';
import 'package:project/widgets/details/color_dot.dart';
import 'package:project/widgets/details/product_image.dart';
import 'package:project/widgets/payement/payement_body.dart';

class DetailsBody extends StatefulWidget {
  final Product product;
  const DetailsBody({super.key, required this.product});

  @override
  State<DetailsBody> createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<DetailsBody> {
 int quantity = 1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int totalPrice =widget.product.price *quantity ;

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
                      // Sélecteur de quantité
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
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
                      // Titre et prix
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
                              'prix : \$${widget.product.price}',
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentPage(produit: widget.product,quantity: quantity,),
                      ),
                    );
                  },
                  child: const Text(
                    'Acheter maintenant',
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
