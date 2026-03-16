import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإشعارات'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'إشعارات حسابك',
                subtitle: 'تابع مستجدات طلباتك وحسابك كبائع.',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _NotificationCard(
                      icon: Icons.verified_outlined,
                      title: 'تم قبول حسابك كبائع',
                      body: 'مبروك! تم تفعيل حساب متجرك ويمكنك الآن البدء في إضافة منتجات.',
                      time: 'منذ 5 دقائق',
                      unread: true,
                    ),
                    const SizedBox(height: 8),
                    _NotificationCard(
                      icon: Icons.shopping_bag_outlined,
                      title: 'طلب جديد',
                      body: 'تم إنشاء طلب جديد على أحد منتجاتك.',
                      time: 'اليوم · 11:20 ص',
                      unread: false,
                    ),
                    const SizedBox(height: 8),
                    _NotificationCard(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'تحديث طلب سحب',
                      body: 'تم قبول طلب السحب الخاص بك وسيتم التحويل خلال 24 ساعة.',
                      time: 'أمس · 03:15 م',
                      unread: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
  });

  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                time,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
              ],
            ),
          ),
          if (unread) ...[
            const SizedBox(width: 8),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

