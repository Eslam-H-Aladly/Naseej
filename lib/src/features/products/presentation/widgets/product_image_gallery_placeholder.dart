import 'package:flutter/material.dart';

class ProductImageGalleryPlaceholder extends StatelessWidget {
  const ProductImageGalleryPlaceholder({super.key});

  void _onTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('اختيار صورة قيد التطوير')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صور المنتج',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _onTap(context),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.7),
                    ),
                  ),
                  child: Icon(
                    index == 0
                        ? Icons.image_outlined
                        : Icons.add_photo_alternate_outlined,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

