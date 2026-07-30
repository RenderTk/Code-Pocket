import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:code_pocket/widgets/code_visual.dart';
import 'package:flutter/material.dart';

enum _CodeCardAction { open, delete }

class CodeCard extends StatelessWidget {
  const CodeCard({
    super.key,
    required this.codeData,
    required this.onTap,
    required this.onDelete,
  });

  final CodeData codeData;
  final VoidCallback onTap;
  final Future<void> Function() onDelete;

  Future<bool> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => _DeleteCodeDialog(title: codeData.title),
    );
    return shouldDelete ?? false;
  }

  Future<void> _handleDelete(BuildContext context) async {
    if (await _confirmDelete(context)) {
      await onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(codeData.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(AppRadii.surface),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: theme.colorScheme.onError,
        ),
      ),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.surface),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                _CodeThumbnail(codeData: codeData),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _CodeSummary(codeData: codeData)),
                PopupMenuButton<_CodeCardAction>(
                  tooltip: 'Code options',
                  onSelected: (action) {
                    switch (action) {
                      case _CodeCardAction.open:
                        onTap();
                      case _CodeCardAction.delete:
                        _handleDelete(context);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _CodeCardAction.open,
                      child: Row(
                        children: [
                          Icon(Icons.open_in_new_rounded),
                          SizedBox(width: AppSpacing.sm),
                          Text('Open'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _CodeCardAction.delete,
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded),
                          SizedBox(width: AppSpacing.sm),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CodeThumbnail extends StatelessWidget {
  const _CodeThumbnail({required this.codeData});

  final CodeData codeData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.control),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: CodeVisual(
        codeType: codeData.codeType,
        data: codeData.data,
        size: 56,
        drawBarcodeText: false,
      ),
    );
  }
}

class _CodeSummary extends StatelessWidget {
  const _CodeSummary({required this.codeData});

  final CodeData codeData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          codeData.title,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '${codeData.codeType.label}  •  ${formatSavedCodeDate(codeData.createdAt)}',
          style: theme.textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          codeData.data,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'monospace',
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

String formatSavedCodeDate(DateTime? date, {DateTime? now}) {
  if (date == null) return 'Saved';
  final currentTime = now ?? DateTime.now();
  final difference = currentTime.difference(date);

  if (difference.isNegative) return _formatCalendarDate(date);
  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inHours < 1) return '${difference.inMinutes} min ago';
  if (difference.inDays < 1) return '${difference.inHours} hr ago';
  if (difference.inDays == 1) return 'Yesterday';
  if (difference.inDays < 7) return '${difference.inDays} days ago';
  return _formatCalendarDate(date);
}

String _formatCalendarDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

class _DeleteCodeDialog extends StatelessWidget {
  const _DeleteCodeDialog({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error),
      title: const Text('Delete this code?'),
      content: Text(
        '“$title” will be removed from this device. This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
