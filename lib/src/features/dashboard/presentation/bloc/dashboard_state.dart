part of 'dashboard_cubit.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    required this.status,
    required this.stats,
    required this.recentOrders,
    required this.walletOverview,
    required this.errorMessage,
  });

  const DashboardState.initial()
      : this(
          status: DashboardStatus.initial,
          stats: const [],
          recentOrders: const [],
          walletOverview: const WalletOverview(
            totalBalance: '0',
            pendingBalance: '0',
            withdrawableBalance: '0',
          ),
          errorMessage: '',
        );

  final DashboardStatus status;
  final List<DashboardStat> stats;
  final List<RecentOrderSummary> recentOrders;
  final WalletOverview walletOverview;
  final String errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    List<DashboardStat>? stats,
    List<RecentOrderSummary>? recentOrders,
    WalletOverview? walletOverview,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      recentOrders: recentOrders ?? this.recentOrders,
      walletOverview: walletOverview ?? this.walletOverview,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        stats,
        recentOrders,
        walletOverview,
        errorMessage,
      ];
}

