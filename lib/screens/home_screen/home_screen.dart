import 'package:code_pocket/providers/active_screen_provider.dart';
import 'package:code_pocket/screens/create_code_screen/create_code_screen.dart';
import 'package:code_pocket/screens/home_screen/widgets/home_screen_appbar.dart';
import 'package:code_pocket/screens/home_screen/widgets/home_screen_navbar.dart';
import 'package:code_pocket/screens/saved_codes_screen/saved_codes_screen.dart';
import 'package:code_pocket/screens/scan_code_screen/scan_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ActiveScreen indexToActiveScreen(int index) {
    switch (index) {
      case 0:
        return ActiveScreen.createCode;
      case 1:
        return ActiveScreen.scanCode;
      case 2:
        return ActiveScreen.savedCodes;
      default:
        return ActiveScreen.createCode;
    }
  }

  final Set<int> _selectedIndex = {0};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeScreenAppbar(),
      body: IndexedStack(
        index: _selectedIndex.first,
        children: const [
          CreateCodeScreen(),
          ScanCodeScreen(),
          SavedCodesScreen(),
        ],
      ),
      bottomNavigationBar: HomeScreenNavbar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex
              ..clear()
              ..add(index);
          });
          ref
              .read(activeScreenProvider.notifier)
              .setActiveScreen(indexToActiveScreen(index));
        },
      ),
    );
  }
}
