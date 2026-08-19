import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/constants.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/providers/products_provider.dart';
import 'package:project/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..tryAutoLogin()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'store',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: kPrimaryColor,
            secondary: kPrimaryColor,
          ),
        ),
        home: const Homescreen(),
      ),
    );
  }
}