import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/widgets/conexion/login.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  final auth = context.read<AuthProvider>();
  if (auth.isAuthenticated) return true;

  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (_) => LoginPage()),
  );

  return result == true;
}