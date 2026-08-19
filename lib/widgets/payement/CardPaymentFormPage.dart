import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/constants.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/services/api_client.dart';
import 'package:project/services/order_service.dart';

class CardPaymentFormPage extends StatefulWidget {
  final String paymentMethod; // "card" | "mastercard"
  const CardPaymentFormPage({super.key, required this.paymentMethod});

  @override
  State<CardPaymentFormPage> createState() => _CardPaymentFormPageState();
}

class _CardPaymentFormPageState extends State<CardPaymentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final cardHolderController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  bool isProcessing = false;

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    setState(() => isProcessing = true);

    // NOTE (simulation only): we never send the full card number or CVV to the
    // backend - only the last 4 digits, for display purposes. A real integration
    // would hand the raw card details to a payment gateway SDK (Stripe, etc.)
    // instead, and the backend would only ever see a payment token.
    final digits = cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    final last4 = digits.length >= 4 ? digits.substring(digits.length - 4) : digits;

    try {
      await OrderService.checkout(
        paymentMethod: widget.paymentMethod,
        cardLast4: last4,
        token: token,
      );

      if (!mounted) return;
      context.read<CartProvider>().clearLocally();

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Commande confirmée ✅'),
          content: const Text('Ton paiement (simulé) a été accepté et ta commande est enregistrée.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const Homescreen()),
                  (route) => false,
                );
              },
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le paiement a échoué, réessaie.')),
      );
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(widget.paymentMethod == 'mastercard' ? 'Paiement Mastercard' : 'Paiement par carte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cardHolderController,
                decoration: const InputDecoration(labelText: 'Titulaire de la carte', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                maxLength: 19,
                decoration: const InputDecoration(labelText: 'Numéro de carte', border: OutlineInputBorder()),
                validator: (v) {
                  final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                  if (digits.length < 12) return 'Numéro de carte invalide';
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryController,
                      decoration: const InputDecoration(labelText: 'MM/AA', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'CVV', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.length < 3) ? 'Invalide' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Paiement simulé - aucune vraie transaction ne sera effectuée.',
                style: TextStyle(color: kTextLightColor, fontSize: 12),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isProcessing ? null : _submit,
                  child: isProcessing
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Payer maintenant', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
