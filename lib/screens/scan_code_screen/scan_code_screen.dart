import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:code_pocket/providers/active_screen_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/scan_code_screen/widgets/scan_overlay.dart';
import 'package:code_pocket/screens/scan_result_screen/scan_result_screen.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:code_pocket/utils/tactile_feedback.dart';
import 'package:code_pocket/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@visibleForTesting
CodeType codeTypeForBarcodeFormat(BarcodeFormat format) {
  return format == BarcodeFormat.qrCode ? CodeType.qrCode : CodeType.barCode;
}

class ScanCodeScreen extends ConsumerStatefulWidget {
  const ScanCodeScreen({super.key});

  @override
  ConsumerState<ScanCodeScreen> createState() => _ScanCodeScreenState();
}

class _ScanCodeScreenState extends ConsumerState<ScanCodeScreen>
    with WidgetsBindingObserver {
  late final MobileScannerController _cameraController;
  late final AudioPlayer _audioPlayer;
  bool _isTabActive = false;
  bool _isAppActive = true;
  bool _isPaused = false;
  bool _isHandlingCapture = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
    _cameraController = MobileScannerController(
      autoStart: false,
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
    ref.listenManual<ActiveScreen>(
      activeScreenProvider,
      (_, next) => _handleActiveScreen(next),
      fireImmediately: true,
    );
  }

  void _handleActiveScreen(ActiveScreen activeScreen) {
    _isTabActive = activeScreen == ActiveScreen.scanCode;
    if (_isTabActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
    } else {
      unawaited(_stopCamera());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppActive = state == AppLifecycleState.resumed;
    if (_isAppActive && _isTabActive) {
      unawaited(_startCamera());
    } else {
      unawaited(_stopCamera());
    }
  }

  Future<void> _startCamera() async {
    if (!mounted ||
        !_isTabActive ||
        !_isAppActive ||
        _isHandlingCapture ||
        _cameraController.value.isRunning ||
        _cameraController.value.isStarting) {
      return;
    }
    try {
      await _cameraController.start();
      if (mounted) setState(() => _isPaused = false);
    } on MobileScannerException {
      if (mounted) setState(() {});
    }
  }

  Future<void> _stopCamera() async {
    if (_cameraController.value.isRunning) {
      await _cameraController.stop();
    }
  }

  Future<void> _togglePaused() async {
    if (_cameraController.value.isRunning) {
      await _cameraController.stop();
      if (mounted) setState(() => _isPaused = true);
    } else {
      await _startCamera();
    }
  }

  Future<void> _handleScanResult(BarcodeCapture capture) async {
    if (_isHandlingCapture || capture.barcodes.isEmpty) return;

    final barcode = capture.barcodes.first;
    final data = barcode.rawValue ?? barcode.displayValue;
    if (data == null || data.trim().isEmpty) return;

    _isHandlingCapture = true;
    await _stopCamera();
    unawaited(
      _audioPlayer.play(AssetSource('sounds/scan_sound.mp3')).catchError((_) {
        // Sound is optional; the captured result should always remain available.
      }),
    );
    confirmationHaptic();
    if (!mounted) return;

    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ScanResultScreen(
          data: data,
          codeType: codeTypeForBarcodeFormat(barcode.format),
        ),
      ),
    );

    _isHandlingCapture = false;
    if (mounted && _isTabActive && _isAppActive) {
      await _startCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_audioPlayer.dispose());
    unawaited(_cameraController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppPageHeader(
                  title: 'Scan a code',
                  description:
                      'Align any QR code or barcode inside the frame. Detection is automatic.',
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.hero),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF090D12),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: _ScannerViewport(
                        controller: _cameraController,
                        isPaused: _isPaused,
                        onDetect: _handleScanResult,
                        onRetry: _startCamera,
                        onTogglePaused: _togglePaused,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScannerViewport extends StatelessWidget {
  const _ScannerViewport({
    required this.controller,
    required this.isPaused,
    required this.onDetect,
    required this.onRetry,
    required this.onTogglePaused,
  });

  final MobileScannerController controller;
  final bool isPaused;
  final ValueChanged<BarcodeCapture> onDetect;
  final VoidCallback onRetry;
  final VoidCallback onTogglePaused;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: controller,
          useAppLifecycleState: false,
          fit: BoxFit.cover,
          onDetect: onDetect,
          placeholderBuilder: (context) => const _CameraLoadingState(),
          errorBuilder: (context, error) =>
              _ScannerErrorState(error: error, onRetry: onRetry),
          overlayBuilder: (context, constraints) {
            final width = constraints.maxWidth * 0.78;
            final height = (width * 0.64).clamp(
              160.0,
              constraints.maxHeight * 0.48,
            );
            final top = (constraints.maxHeight - height) / 2 - 20;
            final left = (constraints.maxWidth - width) / 2;
            return ScanOverlay(
              scanArea: Size(width, height),
              top: top,
              left: left,
            );
          },
        ),
        Positioned(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.md,
          child: ValueListenableBuilder<MobileScannerState>(
            valueListenable: controller,
            builder: (context, state, child) {
              if (!state.isInitialized || state.error != null) {
                return const SizedBox.shrink();
              }
              return _CameraControls(
                state: state,
                isPaused: isPaused,
                onToggleTorch: state.torchState == TorchState.unavailable
                    ? null
                    : controller.toggleTorch,
                onTogglePaused: onTogglePaused,
                onSwitchCamera:
                    (state.availableCameras == null ||
                        state.availableCameras! > 1)
                    ? controller.switchCamera
                    : null,
              );
            },
          ),
        ),
        Positioned(
          top: AppSpacing.md,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<MobileScannerState>(
            valueListenable: controller,
            builder: (context, state, child) {
              if (!state.isInitialized || state.error != null) {
                return const SizedBox.shrink();
              }
              return Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC111722),
                    borderRadius: BorderRadius.circular(AppRadii.control),
                  ),
                  child: Text(
                    isPaused ? 'Scanner paused' : 'Hold steady',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFF0F3F7),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CameraControls extends StatelessWidget {
  const _CameraControls({
    required this.state,
    required this.isPaused,
    required this.onToggleTorch,
    required this.onTogglePaused,
    required this.onSwitchCamera,
  });

  final MobileScannerState state;
  final bool isPaused;
  final VoidCallback? onToggleTorch;
  final VoidCallback onTogglePaused;
  final VoidCallback? onSwitchCamera;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTorchOn = state.torchState == TorchState.on;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: const Color(0xD9111722),
        borderRadius: BorderRadius.circular(AppRadii.surface),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CameraControl(
            tooltip: isTorchOn ? 'Turn flashlight off' : 'Turn flashlight on',
            icon: isTorchOn
                ? Icons.flashlight_on_rounded
                : Icons.flashlight_off_rounded,
            onPressed: onToggleTorch,
          ),
          _CameraControl(
            tooltip: isPaused ? 'Resume scanner' : 'Pause scanner',
            icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            isPrimary: true,
            onPressed: onTogglePaused,
          ),
          _CameraControl(
            tooltip: 'Switch camera',
            icon: state.cameraDirection == CameraFacing.front
                ? Icons.camera_front_rounded
                : Icons.cameraswitch_rounded,
            onPressed: onSwitchCamera,
          ),
        ],
      ),
    );
  }
}

class _CameraControl extends StatelessWidget {
  const _CameraControl({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: Size.square(isPrimary ? 52 : 48),
        backgroundColor: isPrimary
            ? theme.colorScheme.primary
            : const Color(0x1FFFFFFF),
        foregroundColor: isPrimary
            ? theme.colorScheme.onPrimary
            : const Color(0xFFF0F3F7),
        disabledForegroundColor: const Color(0x66F0F3F7),
      ),
      icon: Icon(icon),
    );
  }
}

class _CameraLoadingState extends StatelessWidget {
  const _CameraLoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: const Color(0xFF090D12),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.center_focus_strong_rounded,
              color: theme.colorScheme.primary,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Starting camera',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFF0F3F7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerErrorState extends StatelessWidget {
  const _ScannerErrorState({required this.error, required this.onRetry});

  final MobileScannerException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPermissionDenied =
        error.errorCode == MobileScannerErrorCode.permissionDenied;

    return ColoredBox(
      color: const Color(0xFF090D12),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.no_photography_outlined,
                color: Color(0xFFF0F3F7),
                size: 40,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                isPermissionDenied
                    ? 'Camera access is off'
                    : 'Camera unavailable',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFF0F3F7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isPermissionDenied
                    ? 'Allow camera access in device settings, then try again.'
                    : 'Check that a camera is available, then try again.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFAAB3C0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
