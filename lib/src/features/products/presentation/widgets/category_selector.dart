import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? _selectedCategory;
  String? _selectedSubcategory;

  static const Map<String, List<String>> _mockCategories = {
    'عبايات رسمية': ['سادة', 'مطرزة', 'مطرزة خفيفة'],
    'عبايات كاجوال': ['يومية', 'ملونة', 'فضفاضة'],
    'عبايات مناسبات': ['سهرة', 'أعراس', 'مناسبات خاصة'],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التصنيف',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'الفئة الرئيسية',
            ),
            items: _mockCategories.keys
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
                _selectedSubcategory = null;
              });
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedSubcategory,
            decoration: const InputDecoration(
              labelText: 'التصنيف الفرعي',
            ),
            items: (_mockCategories[_selectedCategory] ?? [])
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedSubcategory = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

