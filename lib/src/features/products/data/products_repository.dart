import '../domain/entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> fetchVendorProducts();
}

class MockProductsRepository implements ProductsRepository {
  @override
  Future<List<Product>> fetchVendorProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return const [
      Product(
        id: '1',
        name: 'عباية الملكة السوداء',
        nameEn: 'Black Queen Abaya',
        description: 'عباية فاخرة من الكريب الثقيل',
        price: 850,
        saleType: 'retail',
        status: 'active',
        variants: [
          ProductVariant(
            fabric: 'كريب',
            color: 'أسود',
            sizeCm: '52',
            stock: 15,
          ),
          ProductVariant(
            fabric: 'كريب',
            color: 'أسود',
            sizeCm: '54',
            stock: 8,
          ),
          ProductVariant(
            fabric: 'كريب',
            color: 'أسود',
            sizeCm: '56',
            stock: 1,
          ),
        ],
      ),
      Product(
        id: '2',
        name: 'عباية النسيم',
        nameEn: 'Naseem Abaya',
        description: 'عباية خفيفة من الشيفون',
        price: 620,
        saleType: 'retail',
        status: 'active',
        variants: [
          ProductVariant(
            fabric: 'شيفون',
            color: 'كحلي',
            sizeCm: '52',
            stock: 20,
          ),
          ProductVariant(
            fabric: 'شيفون',
            color: 'كحلي',
            sizeCm: '54',
            stock: 12,
          ),
        ],
      ),
      Product(
        id: '3',
        name: 'عباية الجوهرة',
        nameEn: 'Jawharah Abaya',
        description: 'عباية مطرزة يدوياً بالكريستال',
        price: 2100,
        saleType: 'wholesale',
        status: 'active',
        variants: [
          ProductVariant(
            fabric: 'ندا',
            color: 'أسود',
            sizeCm: '52',
            stock: 50,
          ),
          ProductVariant(
            fabric: 'ندا',
            color: 'بيج',
            sizeCm: '54',
            stock: 0,
          ),
        ],
      ),
      Product(
        id: '4',
        name: 'عباية الوردة',
        nameEn: 'Rose Abaya',
        description: 'عباية يومية بسيطة وأنيقة',
        price: 430,
        saleType: 'retail',
        status: 'inactive',
        variants: [
          ProductVariant(
            fabric: 'لينن',
            color: 'رمادي',
            sizeCm: '56',
            stock: 3,
          ),
        ],
      ),
    ];
  }
}

