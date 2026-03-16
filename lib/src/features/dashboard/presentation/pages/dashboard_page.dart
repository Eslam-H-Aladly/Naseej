import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_card.dart';
import '../bloc/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading ||
              state.status == DashboardStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DashboardStatus.failure) {
            return Center(
              child: Text(
                'حدث خطأ في تحميل لوحة التحكم',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatsGrid(state: state),
                const SizedBox(height: 24),
                _RecentOrdersAndWallet(state: state),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: state.stats.length,
      itemBuilder: (context, index) {
        final stat = state.stats[index];

        return StatCard(
          title: _translate(stat.key),
          value: stat.value,
          suffix: stat.suffix,
          change: stat.change,
          trendUp: stat.isUp,
        );
      },
    );
  }
}

class _RecentOrdersAndWallet extends StatelessWidget {
  const _RecentOrdersAndWallet({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _translate('recent_orders'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...state.recentOrders.map(
                (order) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${order.id} · ${order.date}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${order.amount} ${_translate('egp')}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: _statusColor(order.status, theme)
                                  .withOpacity(0.1),
                            ),
                            child: Text(
                              _translate(order.status),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _statusColor(order.status, theme),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _translate('wallet_overview'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
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
                      _translate('total_balance'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.walletOverview.totalBalance} ${_translate('egp')}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _WalletRow(
                label: _translate('pending_balance'),
                value:
                    '${state.walletOverview.pendingBalance} ${_translate('egp')}',
                color: Colors.orange.shade600,
              ),
              const SizedBox(height: 8),
              _WalletRow(
                label: _translate('withdrawable'),
                value:
                    '${state.walletOverview.withdrawableBalance} ${_translate('egp')}',
                color: Colors.green.shade600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status, ThemeData theme) {
    switch (status) {
      case 'new':
        return theme.colorScheme.primary;
      case 'accepted':
      case 'delivered':
        return Colors.green.shade600;
      case 'shipped':
        return Colors.orange.shade600;
      case 'cancelled':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.primary;
    }
  }
}

class _WalletRow extends StatelessWidget {
  const _WalletRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color.withOpacity(0.16),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

String _translate(String key) {
  // Simple inline translations based on the React LanguageContext.
  const map = {
    'dashboard': 'لوحة التحكم',
    'products': 'المنتجات',
    'orders': 'الطلبات',
    'wallet': 'المحفظة',
    'settings': 'الإعدادات',
    'total_revenue': 'إجمالي الإيرادات',
    'total_orders': 'إجمالي الطلبات',
    'pending_orders': 'طلبات معلقة',
    'total_products': 'إجمالي المنتجات',
    'recent_orders': 'أحدث الطلبات',
    'wallet_overview': 'نظرة عامة على المحفظة',
    'total_balance': 'الرصيد الإجمالي',
    'pending_balance': 'رصيد معلق',
    'withdrawable': 'قابل للسحب',
    'egp': 'ج.م',
    'new': 'جديد',
    'accepted': 'مقبول',
    'shipped': 'تم الشحن',
    'delivered': 'تم التوصيل',
    'cancelled': 'ملغي',
  };

  return map[key] ?? key;
}

