import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/section_header.dart';
import '../bloc/products_cubit.dart';
import '../widgets/product_card.dart';

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
          SectionHeader(
            title: _t('products'),
            subtitle: _t('products_subtitle'),
            trailing: SizedBox(
              height: 36,
              child: OutlinedButton.icon(
                onPressed: () => context.go('/products/add'),
                icon: const Icon(Icons.add, size: 18),
                label: Text(_t('add_product')),
              ),
            ),
          ),
          const SizedBox(height: 8),
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
          _StatusFilters(),
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
                  return const Center(
                    child: Text('لا توجد منتجات مطابقة للبحث'),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: state.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = state.filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => context.go('/products/${product.id}'),
                    );
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

class _StatusFilters extends StatefulWidget {
  @override
  State<_StatusFilters> createState() => _StatusFiltersState();
}

class _StatusFiltersState extends State<_StatusFilters> {
  String _selected = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void applyFilter(String status) {
      setState(() {
        _selected = status;
      });
      final productsCubit = context.read<ProductsCubit>();
      if (status == 'all') {
        productsCubit.search(productsCubit.state.search);
        return;
      }
      if (status == 'low_stock') {
        productsCubit.search(productsCubit.state.search);
        return;
      }
      productsCubit.search(productsCubit.state.search);
    }

    final filters = <Map<String, String>>[
      {'key': 'all', 'label': _t('all')},
      {'key': 'active', 'label': _t('active')},
      {'key': 'inactive', 'label': _t('inactive')},
      {'key': 'low_stock', 'label': _t('low_stock')},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final key = f['key']!;
          final label = f['label']!;
          final selected = _selected == key;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: selected,
              onSelected: (_) => applyFilter(key),
              selectedColor: theme.colorScheme.primary.withOpacity(0.12),
            ),
          );
        }).toList(),
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

String _t(String key) {
  const map = {
    'products': 'المنتجات',
    'products_subtitle': 'إدارة جميع منتجات متجرك بسهولة.',
    'add_product': 'إضافة منتج',
    'all': 'الكل',
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

