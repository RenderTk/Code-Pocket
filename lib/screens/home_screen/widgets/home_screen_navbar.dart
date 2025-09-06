import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreenNavbar extends StatelessWidget {
  const HomeScreenNavbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Set<int> selectedIndex;
  final void Function(int index) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return PlatformNavBar(
      currentIndex: selectedIndex.first,
      itemChanged: onDestinationSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.plus),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.camera),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.solidFolder), // Both
          label: 'Saved',
        ),
      ],
    );
  }
}
