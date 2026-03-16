import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/app_card.dart';

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
          const SectionHeader(
            title: 'الطلبات',
            subtitle: 'تابع طلبات عملائك وحالتها بسهولة.',
          ),
          const SizedBox(height: 12),
          const _StatusFilterChips(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final orderId = '12${30 + index}';
                final status = index % 4;
                final statusLabel = switch (status) {
                  0 => 'جديد',
                  1 => 'مكتمل',
                  2 => 'مرتجع',
                  _ => 'ملغي',
                };
                final Color statusColor = switch (status) {
                  0 => theme.colorScheme.primary,
                  1 => Colors.green.shade700,
                  2 => Colors.orange.shade700,
                  _ => theme.colorScheme.error,
                };
                return AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  onTap: () => context.go('/orders/$orderId'),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.08),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#$orderId',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'عميل تجريبي · 2026-03-0${(index % 5) + 1}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
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
                            statusLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _StatusFilterChips extends StatefulWidget {
  const _StatusFilterChips();

  @override
  State<_StatusFilterChips> createState() => _StatusFilterChipsState();
}

class _StatusFilterChipsState extends State<_StatusFilterChips> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final filters = ['الكل', 'جديد', 'مكتمل', 'مرتجع', 'ملغي'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (index) {
          final selected = _selected == index;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ChoiceChip(
              label: Text(filters[index]),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _selected = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }
}


