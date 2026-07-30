import 'package:code_pocket/providers/active_screen_provider.dart';
import 'package:code_pocket/screens/create_code_screen/create_code_screen.dart';
import 'package:code_pocket/screens/home_screen/widgets/home_screen_appbar.dart';
import 'package:code_pocket/screens/home_screen/widgets/home_screen_navbar.dart';
import 'package:code_pocket/screens/saved_codes_screen/saved_codes_screen.dart';
import 'package:code_pocket/screens/scan_code_screen/scan_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeScreen = ref.watch(activeScreenProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const HomeScreenAppbar(),
      body: IndexedStack(
        index: activeScreen.index,
        children: const [
          CreateCodeScreen(),
          ScanCodeScreen(),
          SavedCodesScreen(),
        ],
      ),
      bottomNavigationBar: HomeScreenNavbar(
        selectedIndex: activeScreen.index,
        onDestinationSelected: (index) {
          ref
              .read(activeScreenProvider.notifier)
              .setActiveScreen(ActiveScreenNavigation.fromIndex(index));
        },
      ),
    );
  }
}
