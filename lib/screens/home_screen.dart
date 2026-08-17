import 'package:flutter/material.dart';
import 'package:project/constants.dart';
import 'package:project/widgets/home/home_body.dart';
import 'package:project/widgets/menu/barre_menu.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  AppBar homeAppBar(BuildContext context) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: homeAppBar(context),
      body: HomeBody(),
    );
  }
}
