import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/constants.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/services/api_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isSaving = false;
  bool showPasswordFields = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    fullNameController = TextEditingController(text: user?.fullName ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      await context.read<AuthProvider>().updateProfile(
            fullName: fullNameController.text.trim(),
            email: emailController.text.trim(),
            currentPassword: currentPasswordController.text,
            newPassword: showPasswordFields && newPasswordController.text.isNotEmpty
                ? newPasswordController.text
                : null,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte mis à jour ✅')),
      );
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      setState(() => showPasswordFields = false);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une erreur est survenue')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Mon compte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Champ requis';
                  if (!v.contains('@')) return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Changer le mot de passe'),
                value: showPasswordFields,
                onChanged: (v) => setState(() => showPasswordFields = v),
              ),
              if (showPasswordFields) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Nouveau mot de passe', border: OutlineInputBorder()),
                  validator: (v) {
                    if (!showPasswordFields) return null;
                    if (v == null || v.isEmpty) return 'Champ requis';
                    if (v.length < 6) return 'Au moins 6 caractères';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Confirmer le nouveau mot de passe', border: OutlineInputBorder()),
                  validator: (v) {
                    if (!showPasswordFields) return null;
                    if (v != newPasswordController.text) return 'Les mots de passe ne correspondent pas';
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Confirme avec ton mot de passe actuel pour enregistrer les modifications',
                style: TextStyle(color: kTextLightColor, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Mot de passe actuel', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isSaving ? null : _save,
                  child: isSaving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}