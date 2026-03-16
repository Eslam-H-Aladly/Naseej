import 'package:flutter/material.dart';

/// Small statistic card for dashboard and wallet metrics.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.suffix,
    this.change,
    this.trendUp,
  });

  final String title;
  final String value;
  final String? suffix;
  final String? change;
  final bool? trendUp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool? isUp = trendUp;

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (suffix != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    suffix!,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
            if (change != null && isUp != null)
              Row(
                children: [
                  Icon(
                    isUp ? Icons.arrow_outward : Icons.arrow_downward,
                    size: 16,
                    color: isUp ? Colors.green.shade600 : theme.colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    change!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isUp
                          ? Colors.green.shade600
                          : theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

