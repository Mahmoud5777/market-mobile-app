import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/screens/admin/admin_products_screen.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/widgets/conexion/login.dart';

class LeftSideMenu extends StatelessWidget {
  const LeftSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 100),
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(5, 0),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (auth.isAuthenticated && auth.user != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          auth.user!.fullName.isNotEmpty ? auth.user!.fullName[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(auth.user!.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(auth.user!.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            if (auth.isAdmin)
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Text('Administrateur',
                                    style: TextStyle(fontSize: 11, color: Colors.deepOrange)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Text('Non connecté', style: TextStyle(color: Colors.grey)),
                ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Accueil'),
                onTap: () => Navigator.pop(context),
              ),
              if (auth.isAdmin)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Gestion des produits'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminProductsScreen()),
                    );
                  },
                ),
              if (auth.isAuthenticated) ...[
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Mon compte'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Déconnexion'),
                  onTap: () async {
                    await context.read<AuthProvider>().logout();
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                ),
              ] else
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Se connecter'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}