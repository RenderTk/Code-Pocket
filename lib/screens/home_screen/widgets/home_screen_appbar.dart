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
      ).showSnackBar(const SnackBar(content: Text('Library cleared')));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not clear the library')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
            'Code Pocket',
            style: theme.textTheme.titleLarge?.copyWith(letterSpacing: -0.35),
          ),
        ],
      ),
      actions: [
        if (isLibrary)
          PopupMenuButton<_LibraryAction>(
            tooltip: 'Library options',
            enabled: codes.isNotEmpty,
            onSelected: (action) {
              if (action == _LibraryAction.deleteAll) {
                _handleDeleteAll(context, ref);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _LibraryAction.deleteAll,
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_outlined),
                    SizedBox(width: AppSpacing.sm),
                    Text('Delete all'),
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

    return AlertDialog(
      icon: Icon(Icons.delete_sweep_outlined, color: theme.colorScheme.error),
      title: const Text('Delete every saved code?'),
      content: const Text(
        'This removes all QR codes and barcodes from this device. This action cannot be undone.',
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
          child: const Text('Delete all'),
        ),
      ],
    );
  }
}
