import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_image_picker_placeholder.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل المنتج'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: product.name,
                subtitle: product.nameEn,
              ),
              const SizedBox(height: 16),
              const ProductImagePickerPlaceholder(),
              const SizedBox(height: 16),
              const AppTextField(
                label: 'اسم المنتج',
                hintText: 'اسم المنتج بالعربية',
              ),
              const SizedBox(height: 12),
              const AppTextField(
                label: 'وصف المنتج',
                hintText: 'وصف مختصر للمنتج',
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              const AppTextField(
                label: 'السعر',
                hintText: 'مثال: 250',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'حفظ التغييرات',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم حفظ التغييرات (واجهة تجريبية)'),
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
              Text(
                'ملاحظة: في حال وجود طلبات نشطة على المنتج، سيتم تعطيل تعديل بعض الحقول في الإصدار المتكامل.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

