import 'package:code_pocket/l10n/l10n.dart';
import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:code_pocket/widgets/code_visual.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final l10n = context.l10n;

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
                  tooltip: l10n.codeOptions,
                  onSelected: (action) {
                    switch (action) {
                      case _CodeCardAction.open:
                        onTap();
                      case _CodeCardAction.delete:
                        _handleDelete(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _CodeCardAction.open,
                      child: Row(
                        children: [
                          const Icon(Icons.open_in_new_rounded),
                          const SizedBox(width: AppSpacing.sm),
                          Text(l10n.open),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _CodeCardAction.delete,
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline_rounded),
                          const SizedBox(width: AppSpacing.sm),
                          Text(l10n.delete),
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
    final l10n = context.l10n;

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
          l10n.codeMetadata(
            codeData.codeType.label(l10n),
            formatSavedCodeDate(codeData.createdAt, l10n),
          ),
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

String formatSavedCodeDate(
  DateTime? date,
  AppLocalizations l10n, {
  DateTime? now,
}) {
  if (date == null) return l10n.saved;
  final currentTime = now ?? DateTime.now();
  final difference = currentTime.difference(date);

  if (difference.isNegative) {
    return DateFormat.yMd(l10n.localeName).format(date);
  }
  if (difference.inMinutes < 1) return l10n.justNow;
  if (difference.inHours < 1) return l10n.minutesAgo(difference.inMinutes);
  if (difference.inDays < 1) return l10n.hoursAgo(difference.inHours);
  if (difference.inDays == 1) return l10n.yesterday;
  if (difference.inDays < 7) return l10n.daysAgo(difference.inDays);
  return DateFormat.yMd(l10n.localeName).format(date);
}

class _DeleteCodeDialog extends StatelessWidget {
  const _DeleteCodeDialog({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AlertDialog(
      icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error),
      title: Text(l10n.deleteCodeTitle),
      content: Text(l10n.deleteCodeMessage(title)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
