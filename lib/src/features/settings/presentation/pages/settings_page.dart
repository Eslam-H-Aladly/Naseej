import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        children: [
          Text(
            'الإعدادات',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قم بتخصيص تفضيلات حسابك كبائع.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Card(
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
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('اللغة'),
              subtitle: const Text('العربية / English'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل خروج'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

