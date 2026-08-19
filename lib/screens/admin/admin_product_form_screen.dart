import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:project/constants.dart';
import 'package:project/models/product.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/products_provider.dart';
import 'package:project/services/api_client.dart';
import 'package:project/widgets/common/smart_image.dart';

class AdminProductFormScreen extends StatefulWidget {
  final Product? existingProduct;
  const AdminProductFormScreen({super.key, this.existingProduct});

  @override
  State<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends State<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController subTitleController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController imageUrlController;
  late final TextEditingController stockController;

  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;

  bool isSaving = false;
  bool get isEditing => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    titleController = TextEditingController(text: p?.title ?? '');
    subTitleController = TextEditingController(text: p?.subTitle ?? '');
    descriptionController = TextEditingController(text: p?.description ?? '');
    priceController = TextEditingController(text: p != null ? p.price.toString() : '');
    imageUrlController = TextEditingController(text: p != null && p.isNetworkImage ? p.image : '');
    stockController = TextEditingController(text: p != null ? p.stock.toString() : '');
  }

  @override
  void dispose() {
    titleController.dispose();
    subTitleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _pickedImage = file;
      _pickedImageBytes = bytes;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    setState(() => isSaving = true);

    final product = Product(
      id: widget.existingProduct?.id ?? 0,
      title: titleController.text.trim(),
      subTitle: subTitleController.text.trim(),
      description: descriptionController.text.trim(),
      price: double.parse(priceController.text.trim()),
      image: imageUrlController.text.trim(),
      stock: int.parse(stockController.text.trim()),
    );

    try {
      final productsProvider = context.read<ProductsProvider>();

      final savedProduct = isEditing
          ? await productsProvider.updateProduct(widget.existingProduct!.id, product, token: token)
          : await productsProvider.createProduct(product, token: token);

      if (_pickedImage != null) {
        await productsProvider.uploadProductImage(savedProduct.id, _pickedImage!, token: token);
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? 'Produit mis à jour' : 'Produit ajouté')),
      );
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

  Widget _buildImagePreview() {
    if (_pickedImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(_pickedImageBytes!, height: 160, width: double.infinity, fit: BoxFit.cover),
      );
    }
    if (imageUrlController.text.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SmartImage(
          path: imageUrlController.text.trim(),
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 48, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(isEditing ? 'Modifier le produit' : 'Ajouter un produit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildImagePreview(),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(_pickedImage != null ? 'Changer la photo' : 'Choisir une photo depuis la galerie'),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: imageUrlController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'ou colle une URL d\'image existante',
                  helperText: 'Ignoré si une photo a été choisie ci-dessus',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: subTitleController,
                decoration: const InputDecoration(labelText: 'Sous-titre', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Prix (\$)', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Champ requis';
                  if (double.tryParse(v.trim()) == null) return 'Nombre invalide';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Champ requis';
                  if (int.tryParse(v.trim()) == null) return 'Nombre entier requis';
                  return null;
                },
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
                      : Text(isEditing ? 'Enregistrer les modifications' : 'Ajouter le produit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}