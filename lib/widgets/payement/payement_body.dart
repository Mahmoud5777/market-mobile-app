import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/constants.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/widgets/payement/CardPaymentFormPage.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = 'card';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Paiement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Récapitulatif', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total à payer'),
                    Text(
                      '\$${cart.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kSecondaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Choisis un moyen de paiement (simulé)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            RadioListTile<String>(
              value: 'card',
              groupValue: selectedMethod,
              title: const Text('Carte bancaire'),
              secondary: const Icon(Icons.credit_card),
              onChanged: (value) => setState(() => selectedMethod = value!),
            ),
            RadioListTile<String>(
              value: 'mastercard',
              groupValue: selectedMethod,
              title: const Text('Mastercard'),
              secondary: const Icon(Icons.credit_card),
              onChanged: (value) => setState(() => selectedMethod = value!),
            ),
            const Spacer(),
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: cart.items.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CardPaymentFormPage(paymentMethod: selectedMethod),
                            ),
                          );
                        },
                  child: const Text('Continuer', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
