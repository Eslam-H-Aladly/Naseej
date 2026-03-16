import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/account_review_pending_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_vendor_page.dart';
import '../../features/auth/presentation/pages/upload_documents_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/orders/presentation/pages/order_details_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/presentation/pages/add_product_page.dart';
import '../../features/products/presentation/pages/edit_product_page.dart';
import '../../features/products/presentation/pages/product_details_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/wallet/presentation/pages/withdraw_request_page.dart';
import '../widgets/vendor_shell.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterVendorPage(),
      ),
      GoRoute(
        path: '/upload-documents',
        name: 'uploadDocuments',
        builder: (context, state) => const UploadDocumentsPage(),
      ),
      GoRoute(
        path: '/review-pending',
        name: 'reviewPending',
        builder: (context, state) => const AccountReviewPendingPage(),
      ),
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
            path: '/products/add',
            name: 'productsAdd',
            builder: (context, state) => const AddProductPage(),
          ),
          GoRoute(
            path: '/products/:id',
            name: 'productDetails',
            builder: (context, state) {
              final extra = state.extra;
              if (extra is Product) {
                return ProductDetailsPage(product: extra);
              }
              return const Scaffold(
                body: Center(child: Text('لم يتم تمرير بيانات المنتج')),
              );
            },
          ),
          GoRoute(
            path: '/products/:id/edit',
            name: 'productEdit',
            builder: (context, state) {
              final extra = state.extra;
              if (extra is Product) {
                return EditProductPage(product: extra);
              }
              return const Scaffold(
                body: Center(child: Text('لم يتم تمرير بيانات المنتج')),
              );
            },
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: OrdersPage(),
            ),
          ),
          GoRoute(
            path: '/orders/:id',
            name: 'orderDetails',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return OrderDetailsPage(orderId: id);
            },
          ),
          GoRoute(
            path: '/wallet',
            name: 'wallet',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WalletPage(),
            ),
          ),
          GoRoute(
            path: '/wallet/withdraw',
            name: 'withdraw',
            builder: (context, state) => const WithdrawRequestPage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/profile/edit',
            name: 'profileEdit',
            builder: (context, state) => const EditProfilePage(),
          ),
          GoRoute(
            path: '/about',
            name: 'about',
            builder: (context, state) => const AboutPage(),
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

