import { useLanguage } from '@/contexts/LanguageContext';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import {
  TrendingUp,
  ShoppingCart,
  Clock,
  Package,
  Wallet,
  ArrowUpRight,
  ArrowDownRight,
} from 'lucide-react';
import { cn } from '@/lib/utils';

const Dashboard = () => {
  const { t, lang } = useLanguage();

  const stats = [
    {
      key: 'total_revenue',
      value: '45,230',
      suffix: lang === 'ar' ? 'ج.م' : 'EGP',
      change: '+12.5%',
      up: true,
      icon: TrendingUp,
      color: 'text-primary',
      bg: 'bg-primary/10',
    },
    {
      key: 'total_orders',
      value: '156',
      change: '+8.2%',
      up: true,
      icon: ShoppingCart,
      color: 'text-success',
      bg: 'bg-success/10',
    },
    {
      key: 'pending_orders',
      value: '12',
      change: '-3.1%',
      up: false,
      icon: Clock,
      color: 'text-warning',
      bg: 'bg-warning/10',
    },
    {
      key: 'total_products',
      value: '48',
      change: '+2',
      up: true,
      icon: Package,
      color: 'text-accent-foreground',
      bg: 'bg-accent',
    },
  ];

  const recentOrders = [
    { id: '#1234', customer: 'سارة أحمد', amount: '850', status: 'new', date: '2026-03-04' },
    { id: '#1233', customer: 'نورا محمد', amount: '1,200', status: 'accepted', date: '2026-03-03' },
    { id: '#1232', customer: 'فاطمة علي', amount: '650', status: 'shipped', date: '2026-03-03' },
    { id: '#1231', customer: 'مريم حسن', amount: '2,100', status: 'delivered', date: '2026-03-02' },
    { id: '#1230', customer: 'هدى سعيد', amount: '430', status: 'cancelled', date: '2026-03-02' },
  ];

  const statusColors: Record<string, string> = {
    new: 'bg-primary/15 text-primary border-primary/20',
    accepted: 'bg-success/15 text-success border-success/20',
    shipped: 'bg-warning/15 text-warning border-warning/20',
    delivered: 'bg-success/15 text-success border-success/20',
    cancelled: 'bg-destructive/15 text-destructive border-destructive/20',
  };

  return (
    <div className="space-y-8">
      {/* Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
        {stats.map((stat) => (
          <Card key={stat.key} className="border-0 shadow-sm hover:shadow-md transition-shadow duration-300">
            <CardContent className="p-5">
              <div className="flex items-start justify-between">
                <div className="space-y-2">
                  <p className="text-sm text-muted-foreground font-medium">{t(stat.key)}</p>
                  <div className="flex items-baseline gap-1.5">
                    <span className="text-2xl font-bold tracking-tight">{stat.value}</span>
                    {stat.suffix && <span className="text-sm text-muted-foreground">{stat.suffix}</span>}
                  </div>
                  <div className="flex items-center gap-1">
                    {stat.up ? (
                      <ArrowUpRight className="h-3.5 w-3.5 text-success" />
                    ) : (
                      <ArrowDownRight className="h-3.5 w-3.5 text-destructive" />
                    )}
                    <span className={cn('text-xs font-medium', stat.up ? 'text-success' : 'text-destructive')}>
                      {stat.change}
                    </span>
                  </div>
                </div>
                <div className={cn('p-2.5 rounded-xl', stat.bg)}>
                  <stat.icon className={cn('h-5 w-5', stat.color)} />
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
        {/* Recent Orders */}
        <Card className="xl:col-span-2 border-0 shadow-sm">
          <CardHeader className="pb-3">
            <CardTitle className="text-lg">{t('recent_orders')}</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {recentOrders.map((order) => (
                <div
                  key={order.id}
                  className="flex items-center justify-between p-3 rounded-xl bg-muted/40 hover:bg-muted/70 transition-colors"
                >
                  <div className="flex items-center gap-3">
                    <div className="h-10 w-10 rounded-full bg-primary/8 flex items-center justify-center">
                      <ShoppingCart className="h-4 w-4 text-primary" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold">{order.customer}</p>
                      <p className="text-xs text-muted-foreground">{order.id} · {order.date}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-sm font-bold">{order.amount} {t('egp')}</span>
                    <Badge variant="outline" className={cn('text-xs', statusColors[order.status])}>
                      {t(order.status)}
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Wallet Overview */}
        <Card className="border-0 shadow-sm">
          <CardHeader className="pb-3">
            <div className="flex items-center gap-2">
              <Wallet className="h-5 w-5 text-primary" />
              <CardTitle className="text-lg">{t('wallet_overview')}</CardTitle>
            </div>
          </CardHeader>
          <CardContent className="space-y-5">
            <div className="rounded-xl bg-gradient-to-br from-primary to-primary/80 p-5 text-primary-foreground">
              <p className="text-sm opacity-80">{t('total_balance')}</p>
              <p className="text-3xl font-bold mt-1">42,180 <span className="text-base font-normal">{t('egp')}</span></p>
            </div>
            <div className="space-y-3">
              <div className="flex items-center justify-between p-3 rounded-lg bg-warning/8">
                <div className="flex items-center gap-2">
                  <Clock className="h-4 w-4 text-warning" />
                  <span className="text-sm">{t('pending_balance')}</span>
                </div>
                <span className="text-sm font-bold">8,450 {t('egp')}</span>
              </div>
              <div className="flex items-center justify-between p-3 rounded-lg bg-success/8">
                <div className="flex items-center gap-2">
                  <TrendingUp className="h-4 w-4 text-success" />
                  <span className="text-sm">{t('withdrawable')}</span>
                </div>
                <span className="text-sm font-bold">33,730 {t('egp')}</span>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Dashboard;
