import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/section_header.dart';
import '../widgets/category_selector.dart';
import '../widgets/product_image_gallery_placeholder.dart';
import '../widgets/product_variant_row.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  int _variantCount = 1;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة منتج جديد'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'بيانات المنتج',
                subtitle: 'أكمل الحقول التالية لإضافة منتج جديد.',
              ),
              const SizedBox(height: 16),
              const ProductImageGalleryPlaceholder(),
              const SizedBox(height: 16),
              const AppTextField(
                label: 'اسم المنتج (عربي)',
                hintText: 'مثال: عباية سادة كلاسيك',
              ),
              const SizedBox(height: 12),
              const AppTextField(
                label: 'اسم المنتج (إنجليزي)',
                hintText: 'Example: Classic Abaya',
              ),
              const SizedBox(height: 12),
              const AppTextField(
                label: 'وصف المنتج',
                hintText: 'أدخل وصفًا تفصيليًا للمنتج، الخامة، التصميم، الاستخدام...',
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              const CategorySelector(),
              const SizedBox(height: 16),
              Text(
                'التسعير والمخزون',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              const AppTextField(
                label: 'سعر البيع',
                hintText: 'مثال: 350',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const AppTextField(
                label: 'أقل كمية للطلب',
                hintText: 'مثال: 3',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        value: 'active',
                        groupValue: 'active',
                        onChanged: (_) {},
                        title: const Text('نشط'),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        value: 'inactive',
                        groupValue: 'active',
                        onChanged: (_) {},
                        title: const Text('غير نشط'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'متغيرات المنتج',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...List.generate(
                _variantCount,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProductVariantRow(index: i),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _variantCount++;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة متغير'),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'حفظ المنتج',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم حفظ المنتج (واجهة تجريبية)'),
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

