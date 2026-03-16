import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

class DocumentUploadTile extends StatefulWidget {
  const DocumentUploadTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  State<DocumentUploadTile> createState() => _DocumentUploadTileState();
}

class _DocumentUploadTileState extends State<DocumentUploadTile> {
  bool _uploaded = false;

  void _toggleUpload() {
    setState(() {
      _uploaded = !_uploaded;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('واجهة رفع المستندات فقط')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String chipLabel = _uploaded ? 'مرفوع' : 'غير مرفوع';
    final Color chipColor = _uploaded
        ? Colors.green.shade600
        : theme.colorScheme.onSurface.withOpacity(0.5);

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(widget.icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: chipColor.withOpacity(0.1),
            ),
            child: Text(
              chipLabel,
              style: theme.textTheme.labelSmall?.copyWith(color: chipColor),
            ),
          ),
          const SizedBox(width: 8),
          AppButton(
            label: _uploaded ? 'تعديل' : 'رفع',
            onPressed: _toggleUpload,
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}

