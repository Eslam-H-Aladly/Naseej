import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('عن التطبيق'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'منصة دار العباية',
                subtitle: 'حل متكامل لربط البائعين بالعملاء في عالم العبايات.',
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Text(
                  'تساعد منصة دار العباية البائعين على إدارة منتجاتهم وطلبات عملائهم بسهولة، مع تجربة عربية مخصصة وسهلة الاستخدام.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'السياسات',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              AppCard(
                child: ListTile(
                  title: const Text('سياسة الخصوصية'),
                  subtitle: const Text('كيف نتعامل مع بياناتك ومعلوماتك.'),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 8),
              AppCard(
                child: ListTile(
                  title: const Text('الشروط والأحكام'),
                  subtitle: const Text('قواعد استخدام المنصة للبائعين والعملاء.'),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

