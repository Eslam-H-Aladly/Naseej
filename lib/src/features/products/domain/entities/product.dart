class ProductVariant {
  const ProductVariant({
    required this.fabric,
    required this.color,
    required this.sizeCm,
    required this.stock,
  });

  final String fabric;
  final String color;
  final String sizeCm;
  final int stock;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.price,
    required this.saleType,
    required this.variants,
    required this.status,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String nameEn;
  final String description;
  final double price;
  final String saleType; // retail | wholesale
  final List<ProductVariant> variants;
  final String status; // active | inactive
  final String? imageUrl;
}

