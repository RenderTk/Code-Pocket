import 'package:code_pocket/providers/active_screen_provider.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Función para mostrar el diálogo de confirmación
Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
  final result = await showPlatformDialog<bool>(
    context: context,
    builder: (BuildContext context) => PlatformAlertDialog(
      title: const Text('Delete All Codes'),
      content: const Text(
        'Are you sure you want to delete all your QR and barcode data? '
        'This action cannot be undone.',
      ),
      actions: [
        PlatformDialogAction(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        PlatformDialogAction(
          onPressed: () {
            Navigator.pop(context, true); // Cerrar el diálogo
          },
          child: const Text('Delete All', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
  return result ?? false;
}

class HomeScreenAppbar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeScreenAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeScreen = ref.watch(activeScreenProvider);

    return PlatformAppBar(
      backgroundColor: theme.colorScheme.surface,
      leading: const Icon(FontAwesomeIcons.codepen),
      title: Text(
        'Code Pocket',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      trailingActions: [
        if (activeScreen == ActiveScreen.savedCodes)
          IconButton(
            onPressed: () async {
              final shouldDelete = await _showDeleteConfirmationDialog(context);
              if (shouldDelete) {
                ref.read(codesProvider.notifier).deleteAllCodes();
              }
            },
            icon: Icon(PlatformIcons(context).delete),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
