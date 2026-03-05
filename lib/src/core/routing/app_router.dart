import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../widgets/vendor_shell.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => VendorShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/products',
            name: 'products',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProductsPage(),
            ),
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: OrdersPage(),
            ),
          ),
          GoRoute(
            path: '/wallet',
            name: 'wallet',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WalletPage(),
            ),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Oops! Page not found'),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

