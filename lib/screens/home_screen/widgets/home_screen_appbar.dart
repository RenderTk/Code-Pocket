import 'package:code_pocket/l10n/l10n.dart';
import 'package:code_pocket/providers/active_screen_provider.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:code_pocket/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _LibraryAction { deleteAll }

class HomeScreenAppbar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeScreenAppbar({super.key});

  Future<void> _handleDeleteAll(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => const _DeleteAllDialog(),
    );
    if (shouldDelete != true) return;

    try {
      await ref.read(codesProvider.notifier).deleteAllCodes();
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.libraryCleared)));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.libraryClearFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final activeScreen = ref.watch(activeScreenProvider);
    final codes = ref.watch(codesProvider).valueOrNull ?? const [];
    final isLibrary = activeScreen == ActiveScreen.savedCodes;

    return AppBar(
      toolbarHeight: 68,
      titleSpacing: AppSpacing.lg,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLogo(size: 38),
          const SizedBox(width: AppSpacing.sm),
          Text(
            l10n.appName,
            style: theme.textTheme.titleLarge?.copyWith(letterSpacing: -0.35),
          ),
        ],
      ),
      actions: [
        if (isLibrary)
          PopupMenuButton<_LibraryAction>(
            tooltip: l10n.libraryOptions,
            enabled: codes.isNotEmpty,
            onSelected: (action) {
              if (action == _LibraryAction.deleteAll) {
                _handleDeleteAll(context, ref);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _LibraryAction.deleteAll,
                child: Row(
                  children: [
                    const Icon(Icons.delete_sweep_outlined),
                    const SizedBox(width: AppSpacing.sm),
                    Text(l10n.deleteAll),
                  ],
                ),
              ),
            ],
          ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}

class _DeleteAllDialog extends StatelessWidget {
  const _DeleteAllDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AlertDialog(
      icon: Icon(Icons.delete_sweep_outlined, color: theme.colorScheme.error),
      title: Text(l10n.deleteAllTitle),
      content: Text(l10n.deleteAllMessage),
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
          child: Text(l10n.deleteAll),
        ),
      ],
    );
  }
}
