import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

/// Grid card for a single product in the products list.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int totalStock = product.variants.fold<int>(
      0,
      (sum, v) => sum + v.stock,
    );
    final bool hasLowStock =
        product.variants.any((v) => v.stock <= 1 && v.stock > 0);

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                image: product.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(product.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product.imageUrl == null
                  ? const Center(
                      child: Icon(
                        Icons.checkroom_outlined,
                        size: 36,
                        color: Color(0xFF9CA3AF),
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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

