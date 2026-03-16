import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/section_header.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل بيانات المتجر'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'تعديل بيانات المتجر',
                subtitle: 'قم بتحديث بيانات التواصل واسم المتجر.',
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: 'اسم المتجر',
                hintText: 'متجر عبايات الرياض',
              ),
              const SizedBox(height: 12),
              const AppTextField(
                label: 'البريد الإلكتروني',
                hintText: 'example@mail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              const AppTextField(
                label: 'رقم الجوال',
                hintText: '05xxxxxxxx',
                keyboardType: TextInputType.phone,
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
            ],
          ),
        ),
      ),
    );
  }
}

