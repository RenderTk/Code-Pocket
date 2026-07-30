import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActiveScreen { createCode, scanCode, savedCodes }

extension ActiveScreenNavigation on ActiveScreen {
  int get index => switch (this) {
    ActiveScreen.createCode => 0,
    ActiveScreen.scanCode => 1,
    ActiveScreen.savedCodes => 2,
  };

  static ActiveScreen fromIndex(int index) => switch (index) {
    0 => ActiveScreen.createCode,
    1 => ActiveScreen.scanCode,
    2 => ActiveScreen.savedCodes,
    _ => ActiveScreen.createCode,
  };
}

class ActiveScreenNotifier extends Notifier<ActiveScreen> {
  @override
  ActiveScreen build() => ActiveScreen.createCode;

  void setActiveScreen(ActiveScreen activeScreen) => state = activeScreen;
}

final activeScreenProvider =
    NotifierProvider<ActiveScreenNotifier, ActiveScreen>(
      ActiveScreenNotifier.new,
    );
