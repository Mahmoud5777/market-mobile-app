import 'package:flutter/material.dart';
import 'package:project/constants.dart';
import 'package:project/widgets/conexion/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          secondary: kPrimaryColor,
        ),
      ),
      home: LoginPage(),
    );
  }
}
