import 'package:flutter/material.dart';

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
          Text(
            'المحفظة',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'إدارة رصيدك، المبالغ المعلقة، وطلبات السحب.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
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
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('رصيد معلق'),
                  subtitle: const Text('مبالغ طلبات لم يتم تسويتها بعد'),
                  trailing: const Text('8,450 ج.م'),
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_circle_up_outlined),
                  title: const Text('رصيد قابل للسحب'),
                  subtitle: const Text('رصيد جاهز لطلب سحب'),
                  trailing: const Text('33,730 ج.م'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.payment_outlined),
                  title: const Text('طلب سحب جديد'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('طلب سحب'),
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

