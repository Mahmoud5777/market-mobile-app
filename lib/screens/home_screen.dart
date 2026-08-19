import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/constants.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/screens/admin/admin_products_screen.dart';
import 'package:project/screens/cart_screen.dart';
import 'package:project/widgets/common/auth_guard.dart';
import 'package:project/widgets/home/home_body.dart';
import 'package:project/widgets/menu/barre_menu.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  AppBar homeAppBar(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      title: const Text(
        'Découvrez nos nouveautés high-tech',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          showGeneralDialog(
            context: context,
            barrierDismissible: false,
            barrierLabel: "Menu",
            barrierColor: Colors.black38,
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return const LeftSideMenu();
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
        icon: const Icon(Icons.menu),
      ),
      actions: [
        if (auth.isAdmin)
          IconButton(
            tooltip: 'Gérer les produits',
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminProductsScreen()),
              );
            },
          ),
        IconButton(
          tooltip: 'Panier',
          icon: Badge(
            label: Text('${cart.itemCount}'),
            isLabelVisible: cart.itemCount > 0,
            child: const Icon(Icons.shopping_cart),
          ),
          onPressed: () async {
            final loggedIn = await ensureLoggedIn(context);
            if (!loggedIn || !context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: homeAppBar(context),
      body: const HomeBody(),
    );
  }
}