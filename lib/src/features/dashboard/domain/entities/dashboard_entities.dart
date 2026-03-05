class DashboardStat {
  const DashboardStat({
    required this.key,
    required this.value,
    required this.suffix,
    required this.change,
    required this.isUp,
  });

  final String key;
  final String value;
  final String? suffix;
  final String change;
  final bool isUp;
}

class RecentOrderSummary {
  const RecentOrderSummary({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.date,
  });

  final String id;
  final String customerName;
  final String amount;
  final String status;
  final String date;
}

class WalletOverview {
  const WalletOverview({
    required this.totalBalance,
    required this.pendingBalance,
    required this.withdrawableBalance,
  });

  final String totalBalance;
  final String pendingBalance;
  final String withdrawableBalance;
}

