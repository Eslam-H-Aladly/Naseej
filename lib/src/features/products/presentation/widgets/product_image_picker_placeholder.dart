import 'package:flutter/material.dart';

/// UI-only image picker placeholder for product images.
class ProductImagePickerPlaceholder extends StatefulWidget {
  const ProductImagePickerPlaceholder({super.key});

  @override
  State<ProductImagePickerPlaceholder> createState() =>
      _ProductImagePickerPlaceholderState();
}

class _ProductImagePickerPlaceholderState
    extends State<ProductImagePickerPlaceholder> {
  bool _hasMockImage = false;

  void _onTap() {
    setState(() {
      _hasMockImage = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('اختيار صورة قيد التطوير'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: _onTap,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.7),
            style: BorderStyle.solid,
          ),
        ),
        child: _hasMockImage
            ? Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF9FAFB),
                          Color(0xFFE5E7EB),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.checkroom_outlined,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Text(
                      'تغيير الصورة',
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'إضافة صورة للمنتج',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

