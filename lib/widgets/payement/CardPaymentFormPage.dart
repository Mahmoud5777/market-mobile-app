import 'package:flutter/material.dart';

class CardPayment extends StatefulWidget {
  @override
  _CardPaymentFormPageState createState() => _CardPaymentFormPageState();
}

class _CardPaymentFormPageState extends State<CardPayment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Traitement du paiement...")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Détails de la carte")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nom sur la carte"),
                validator: (value) => value!.isEmpty ? "Champ requis" : null,
              ),
              TextFormField(
                controller: cardNumberController,
                decoration: InputDecoration(labelText: "Numéro de carte"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.length < 16 ? "Numéro invalide" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryController,
                      decoration: InputDecoration(labelText: "MM/AA"),
                      validator: (value) => value!.isEmpty ? "Champ requis" : null,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: cvcController,
                      decoration: InputDecoration(labelText: "CVC"),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.length < 3 ? "Code invalide" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitPayment,
                child: Text("Confirmer le paiement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
