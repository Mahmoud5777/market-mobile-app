import 'package:flutter/material.dart';
import 'package:project/constants.dart';
import 'package:project/models/product.dart';
import 'package:project/widgets/details/details_body.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;
  const DetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: detailsAppBar(context),
      body: DetailsBody(product: product),
    );
  }

  AppBar detailsAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundColor,
      elevation: 0,//ombre par defaut
      leading: IconButton(
        padding: EdgeInsets.only(right: kDefaultPadding),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: kPrimaryColor),
      ),
    );
  }
}
