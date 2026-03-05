import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الطلبات',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تابع طلبات عملائك وحالتها بسهولة.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final status = index.isEven ? 'جديد' : 'تم الشحن';
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    title: Text('#12${30 + index}'),
                    subtitle: Text('عميل تجريبي · 2026-03-0${(index % 5) + 1}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '850 ج.م',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          status,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: status == 'جديد'
                                ? theme.colorScheme.primary
                                : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: 8,
            ),
          ),
        ],
      ),
    );
  }
}

