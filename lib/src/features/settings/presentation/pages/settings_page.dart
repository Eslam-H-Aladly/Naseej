import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        children: [
          const SectionHeader(
            title: 'الإعدادات',
            subtitle: 'قم بتخصيص تفضيلات حسابك كبائع.',
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('إشعارات الطلبات الجديدة'),
                  value: true,
                  onChanged: (_) {},
                ),
                const Divider(height: 0),
                SwitchListTile(
                  title: const Text('إشعارات حالة الطلب'),
                  value: true,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('اللغة'),
              subtitle: const Text('العربية / English'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: const Text('مشاركة التطبيق'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('مشاركة التطبيق قيد التطوير'),
                      ),
                    );
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.star_rate_outlined),
                  title: const Text('تقييم التطبيق'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تقييم التطبيق قيد التطوير'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('الملف الشخصي'),
                  onTap: () => context.go('/profile'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('عن التطبيق'),
                  onTap: () => context.go('/about'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل خروج'),
              onTap: () => context.go('/login'),
            ),
          ),
        ],
      ),
    );
  }
}

