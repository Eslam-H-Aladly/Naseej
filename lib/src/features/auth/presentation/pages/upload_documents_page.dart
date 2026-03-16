import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../widgets/document_upload_tile.dart';

class UploadDocumentsPage extends StatelessWidget {
  const UploadDocumentsPage({super.key});

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
                  title: 'إدارة مستندات المتجر',
                  subtitle:
                      'راجع المستندات التي قمت برفعها ويمكنك تعديلها أو استبدالها.',
                ),
                const SizedBox(height: 24),
                const DocumentUploadTile(
                  icon: Icons.business,
                  title: 'السجل التجاري',
                  subtitle: 'مطلوب · استخدم ملف PDF أو صورة واضحة',
                ),
                const SizedBox(height: 12),
                const DocumentUploadTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'البطاقة الضريبية',
                  subtitle: 'مطلوب · يجب أن تكون سارية',
                ),
                const SizedBox(height: 12),
                const DocumentUploadTile(
                  icon: Icons.category_outlined,
                  title: 'تصنيف / نشاط المتجر',
                  subtitle: 'اختياري · وثيقة تصنيف النشاط إن وجدت',
                ),
                const SizedBox(height: 12),
                const DocumentUploadTile(
                  icon: Icons.attach_file_outlined,
                  title: 'مستندات إضافية',
                  subtitle: 'اختياري · عقود أو تصاريح إضافية',
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'إرسال للمراجعة',
                  onPressed: () => context.go('/review-pending'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

