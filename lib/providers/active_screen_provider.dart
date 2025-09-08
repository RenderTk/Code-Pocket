import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActiveScreen { createCode, scanCode, savedCodes }

class ActiveScreenNotifier extends Notifier<ActiveScreen> {
  @override
  ActiveScreen build() => ActiveScreen.createCode;

  void setActiveScreen(ActiveScreen activeScreen) => state = activeScreen;
}

final activeScreenProvider =
    NotifierProvider<ActiveScreenNotifier, ActiveScreen>(
      ActiveScreenNotifier.new,
    );
