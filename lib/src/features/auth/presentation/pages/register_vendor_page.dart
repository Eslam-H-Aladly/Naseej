import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/section_header.dart';
import '../widgets/store_image_picker_placeholder.dart';
import '../widgets/document_upload_tile.dart';

class RegisterVendorPage extends StatelessWidget {
  const RegisterVendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'إنشاء حساب بائع',
                  subtitle: 'أدخل بيانات متجرك واستكمل المستندات المطلوبة.',
                ),
                const SizedBox(height: 24),
                const StoreImagePickerPlaceholder(),
                const SizedBox(height: 24),
                const AppTextField(
                  label: 'اسم المتجر',
                  hintText: 'مثال: متجر عبايات الرياض',
                ),
                const SizedBox(height: 16),
                const AppTextField(
                  label: 'البريد الإلكتروني',
                  hintText: 'example@mail.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                const AppTextField(
                  label: 'رقم الجوال',
                  hintText: '05xxxxxxxx',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                Text(
                  'المستندات القانونية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const DocumentUploadTile(
                  icon: Icons.business,
                  title: 'السجل التجاري',
                  subtitle: 'مطلوب',
                ),
                const SizedBox(height: 8),
                const DocumentUploadTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'البطاقة الضريبية',
                  subtitle: 'مطلوب',
                ),
                const SizedBox(height: 8),
                const DocumentUploadTile(
                  icon: Icons.category_outlined,
                  title: 'تصنيف / نشاط المتجر',
                  subtitle: 'اختياري',
                ),
                const SizedBox(height: 8),
                const DocumentUploadTile(
                  icon: Icons.attach_file_outlined,
                  title: 'مستندات إضافية',
                  subtitle: 'اختياري',
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'متابعة لرفع المستندات',
                  onPressed: () => context.go('/upload-documents'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

