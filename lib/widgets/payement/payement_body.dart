import 'package:flutter/material.dart';
import 'package:project/models/product.dart';
import 'package:project/widgets/payement/CardPaymentFormPage.dart';

class PaymentPage extends StatefulWidget {
  final Product produit;
  final int quantity;

  const PaymentPage({super.key, required this.produit, required this.quantity});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
   int totalPrice = widget.produit.price * widget.quantity;

    return Scaffold(
      appBar: AppBar(title: const Text("Paiement")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Résumé de la commande",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Produit : ${widget.produit.title}"),
            Text("Quantité : ${widget.quantity}"),
            Text("Total : ${totalPrice.toStringAsFixed(2)} €"),
            const SizedBox(height: 40),
            const Text("Méthode de paiement", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedMethod,
              items: const [
                DropdownMenuItem(value: "card", child: Text("Carte bancaire")),
                DropdownMenuItem(value: "mastercard", child: Text("Master Card")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
              hint: const Text("Choisir une méthode"),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Veuillez choisir une méthode de paiement")),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardPayment()),
                  );
                },
                child: const Text("Payer maintenant"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
