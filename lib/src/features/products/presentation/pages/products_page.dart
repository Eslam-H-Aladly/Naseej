import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../bloc/products_cubit.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t('products'),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              final total = state.filteredProducts.length;
              return Text(
                '$total ${_t('total_products')}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _SearchField(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state.status == ProductsStatus.loading ||
                    state.status == ProductsStatus.initial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == ProductsStatus.failure) {
                  return Center(
                    child: Text(
                      'تعذر تحميل المنتجات',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }

                if (state.filteredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد منتجات مطابقة للبحث',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: state.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = state.filteredProducts[index];
                    return _ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: _t('search_products'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        isDense: true,
      ),
      onChanged: context.read<ProductsCubit>().search,
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalStock = product.variants.fold<int>(
      0,
      (sum, v) => sum + v.stock,
    );
    final hasLowStock =
        product.variants.any((v) => v.stock <= 1 && v.stock > 0);

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF9FAFB),
                    Color(0xFFE5E7EB),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.checkroom_outlined,
                  size: 36,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.nameEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: product.saleType == 'wholesale'
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : theme.colorScheme.secondary.withOpacity(0.3),
                        ),
                        child: Text(
                          _t(product.saleType),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (hasLowStock)
                        Row(
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              size: 14,
                              color: Colors.orange.shade600,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _t('low_stock'),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.orange.shade600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(0)} ${_t('egp')}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_t('stock')}: $totalStock',
                            style: theme.textTheme.labelSmall,
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: product.status == 'active'
                                  ? Colors.green.shade50
                                  : Colors.grey.shade200,
                            ),
                            child: Text(
                              _t(product.status),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: product.status == 'active'
                                    ? Colors.green.shade700
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _t(String key) {
  const map = {
    'products': 'المنتجات',
    'total_products': 'إجمالي المنتجات',
    'search_products': 'البحث عن منتجات...',
    'retail': 'تجزئة',
    'wholesale': 'جملة',
    'low_stock': 'مخزون منخفض',
    'stock': 'المخزون',
    'active': 'نشط',
    'inactive': 'غير نشط',
    'egp': 'ج.م',
  };

  return map[key] ?? key;
}

