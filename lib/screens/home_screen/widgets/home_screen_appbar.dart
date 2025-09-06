import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreenAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
