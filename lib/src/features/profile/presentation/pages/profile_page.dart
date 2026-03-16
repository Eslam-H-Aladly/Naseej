import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../auth/presentation/widgets/document_upload_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الملف الشخصي للبائع'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'بيانات المتجر',
                subtitle: 'قم بمراجعة وتعديل بيانات حساب متجرك.',
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Row(
                  children: [
                    const CircleAvatar(
                      child: Icon(Icons.storefront_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'متجر عبايات الرياض',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'example@mail.com · 05xxxxxxxx',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.go('/profile/edit'),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'الوثائق المرفوعة',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              const DocumentUploadTile(
                icon: Icons.business,
                title: 'السجل التجاري',
                subtitle: 'تم رفع المستند',
              ),
              const SizedBox(height: 8),
              const DocumentUploadTile(
                icon: Icons.receipt_long_outlined,
                title: 'البطاقة الضريبية',
                subtitle: 'تم رفع المستند',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

