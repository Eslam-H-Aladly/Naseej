import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'المحفظة',
            subtitle: 'إدارة رصيدك، المبالغ المعلقة، وطلبات السحب.',
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF92400E),
                    Color(0xFFF59E0B),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الرصيد الإجمالي',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '42,180 ج.م',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                AppCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time),
                    title: const Text('رصيد معلق'),
                    subtitle: const Text('مبالغ طلبات لم يتم تسويتها بعد'),
                    trailing: const Text('8,450 ج.م'),
                  ),
                ),
                const SizedBox(height: 8),
                AppCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.arrow_circle_up_outlined),
                    title: const Text('رصيد قابل للسحب'),
                    subtitle: const Text('رصيد جاهز لطلب سحب'),
                    trailing: const Text('33,730 ج.م'),
                  ),
                ),
                const Divider(),
                AppCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.payment_outlined),
                    title: const Text('طلب سحب جديد'),
                    trailing: ElevatedButton(
                      onPressed: () => context.go('/wallet/withdraw'),
                      child: const Text('طلب سحب'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'سجل طلبات السحب',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('2026-03-0${index + 1}'),
                          Text(
                            '1,500 ج.م',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            index == 0
                                ? 'قيد المراجعة'
                                : index == 1
                                    ? 'مقبول'
                                    : 'مرفوض',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

