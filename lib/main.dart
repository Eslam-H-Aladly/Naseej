import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'src/features/products/presentation/bloc/products_cubit.dart';

void main() {
  runApp(const DarElAbayaVendorApp());
}

class DarElAbayaVendorApp extends StatelessWidget {
  const DarElAbayaVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DashboardCubit()..loadMockData(),
        ),
        BlocProvider(
          create: (_) => ProductsCubit()..loadMockProducts(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Dar Alabaya Vendor',
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}

