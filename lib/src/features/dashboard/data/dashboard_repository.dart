import '../domain/entities/dashboard_entities.dart';

abstract class DashboardRepository {
  Future<DashboardData> fetchDashboard();
}

class DashboardData {
  const DashboardData({
    required this.stats,
    required this.recentOrders,
    required this.walletOverview,
  });

  final List<DashboardStat> stats;
  final List<RecentOrderSummary> recentOrders;
  final WalletOverview walletOverview;
}

class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardData> fetchDashboard() async {
    // In a real implementation this will call the backend described
    // in BACKEND_MASTER_PROMPT.md (reports, vendor balance, orders, etc.).
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final stats = <DashboardStat>[
      const DashboardStat(
        key: 'total_revenue',
        value: '45,230',
        suffix: 'ج.م',
        change: '+12.5%',
        isUp: true,
      ),
      const DashboardStat(
        key: 'total_orders',
        value: '156',
        suffix: null,
        change: '+8.2%',
        isUp: true,
      ),
      const DashboardStat(
        key: 'pending_orders',
        value: '12',
        suffix: null,
        change: '-3.1%',
        isUp: false,
      ),
      const DashboardStat(
        key: 'total_products',
        value: '48',
        suffix: null,
        change: '+2',
        isUp: true,
      ),
    ];

    final recentOrders = <RecentOrderSummary>[
      const RecentOrderSummary(
        id: '#1234',
        customerName: 'سارة أحمد',
        amount: '850',
        status: 'new',
        date: '2026-03-04',
      ),
      const RecentOrderSummary(
        id: '#1233',
        customerName: 'نورا محمد',
        amount: '1,200',
        status: 'accepted',
        date: '2026-03-03',
      ),
      const RecentOrderSummary(
        id: '#1232',
        customerName: 'فاطمة علي',
        amount: '650',
        status: 'shipped',
        date: '2026-03-03',
      ),
      const RecentOrderSummary(
        id: '#1231',
        customerName: 'مريم حسن',
        amount: '2,100',
        status: 'delivered',
        date: '2026-03-02',
      ),
      const RecentOrderSummary(
        id: '#1230',
        customerName: 'هدى سعيد',
        amount: '430',
        status: 'cancelled',
        date: '2026-03-02',
      ),
    ];

    const walletOverview = WalletOverview(
      totalBalance: '42,180',
      pendingBalance: '8,450',
      withdrawableBalance: '33,730',
    );

    return DashboardData(
      stats: stats,
      recentOrders: recentOrders,
      walletOverview: walletOverview,
    );
  }
}

