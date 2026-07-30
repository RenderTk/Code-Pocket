import 'package:code_pocket/l10n/l10n.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CodePayloadPanel extends StatelessWidget {
  const CodePayloadPanel({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.surface),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.encodedContent, style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          SelectableText(
            data,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'monospace',
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
