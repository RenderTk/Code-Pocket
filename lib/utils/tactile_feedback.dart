import 'dart:async';

import 'package:flutter/services.dart';

void selectionHaptic() {
  unawaited(
    HapticFeedback.selectionClick().catchError((_) {
      // Haptics are an enhancement and must never block the primary action.
    }),
  );
}

void confirmationHaptic() {
  unawaited(
    HapticFeedback.mediumImpact().catchError((_) {
      // Haptics are an enhancement and must never block the primary action.
    }),
  );
}
