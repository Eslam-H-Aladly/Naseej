import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/section_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'تسجيل الدخول',
                  subtitle: 'ادخل إلى بوابة البائع باستخدام حسابك.',
                ),
                const SizedBox(height: 24),
                const AppTextField(
                  label: 'رقم الجوال أو البريد الإلكتروني',
                  hintText: '05xxxxxxxx أو example@mail.com',
                ),
                const SizedBox(height: 16),
                const AppTextField(
                  label: 'كلمة المرور / رمز التحقق',
                  hintText: '••••••••',
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'تسجيل الدخول',
                  onPressed: () => context.go('/'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('إنشاء حساب جديد للبائع'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

