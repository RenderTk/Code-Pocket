import 'package:code_pocket/l10n/l10n.dart';
import 'package:flutter/material.dart';

class HomeScreenNavbar extends StatelessWidget {
  const HomeScreenNavbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.add_box_outlined),
            selectedIcon: const Icon(Icons.add_box_rounded),
            label: l10n.createTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.center_focus_weak_rounded),
            selectedIcon: const Icon(Icons.center_focus_strong_rounded),
            label: l10n.scanTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.folder_outlined),
            selectedIcon: const Icon(Icons.folder_rounded),
            label: l10n.libraryTab,
          ),
        ],
      ),
    );
  }
}
