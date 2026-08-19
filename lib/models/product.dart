class Product {
  final int id;
  final double price;
  final String title;
  final String subTitle;
  final String description;
  // Can be either a bundled asset path (e.g. "images/airpod.png") or a full
  // network URL returned by the backend (e.g. "https://.../uploads/xyz.png").
  final String image;
  final int stock;

  const Product({
    required this.id,
    required this.price,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.image,
    this.stock = 0,
  });

  /// true when [image] is a network URL rather than a bundled asset path.
  bool get isNetworkImage => image.startsWith('http://') || image.startsWith('https://');

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      price: (json['price'] as num).toDouble(),
      title: json['title'] as String? ?? '',
      subTitle: json['subTitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: (json['imageUrl'] as String?)?.trim().isNotEmpty == true
          ? json['imageUrl'] as String
          : 'images/mobile.png', // fallback placeholder if the admin didn't set an image yet
      stock: json['stock'] as int? ?? 0,
    );
  }

  /// Used when an admin creates/updates a product (matches backend's ProductRequest).
  Map<String, dynamic> toRequestJson() {
    return {
      'title': title,
      'subTitle': subTitle,
      'description': description,
      'price': price,
      'imageUrl': image,
      'stock': stock,
    };
  }
}
