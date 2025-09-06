import 'package:code_pocket/screens/create_code_screen/create_code_screen.dart';
import 'package:code_pocket/screens/home_screen/widgets/home_screen_appbar.dart';
import 'package:code_pocket/screens/home_screen/widgets/home_screen_navbar.dart';
import 'package:code_pocket/screens/saved_codes_screen/saved_codes_screen.dart';
import 'package:code_pocket/screens/scan_code_screen/scan_code_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        },
      ),
    );
  }
}
