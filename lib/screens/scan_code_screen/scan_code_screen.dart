import 'package:audioplayers/audioplayers.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/scan_code_screen/widgets/scan_overlay.dart';
import 'package:code_pocket/screens/scan_result_screen/scan_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanCodeScreen extends StatefulWidget {
  const ScanCodeScreen({super.key});

  @override
  State<ScanCodeScreen> createState() => _ScanCodeScreenState();
}

class _ScanCodeScreenState extends State<ScanCodeScreen>
    with SingleTickerProviderStateMixin {
  bool isScanning = false;
  bool isTorchOn = false;
  bool isCameraFront = false;
  late AnimationController _animationController;
  final MobileScannerController camaraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
  );
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    camaraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScanResult(BarcodeCapture barcodeCapture) {
    if (isScanning) {
      camaraController.stop();
      setState(() => isScanning = false);
    }

    //audio feedback for success scan
    player.play(AssetSource('sounds/scan_sound.mp3'));

    final barcode = barcodeCapture.barcodes.first;
    final data = barcode.displayValue;
    final codeType = barcode.format == BarcodeFormat.qrCode
        ? CodeType.qrCode
        : CodeType.barCode;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScanResultScreen(data: data ?? '', codeType: codeType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isScanning
        ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: MobileScanner(
                    controller: camaraController,
                    errorBuilder: (context, error) {
                      String message = error.errorCode.message;

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              PlatformIcons(context).error,
                              color: Colors.redAccent,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            PlatformText(
                              'Scanner Unavailable',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: PlatformText(
                                message,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    overlayBuilder: (context, constraints) {
                      final scanArea = Size(
                        constraints.maxWidth * 0.85,
                        constraints.maxHeight * 0.35,
                      );
                      final top = (constraints.maxHeight - scanArea.height) / 2;
                      final left = (constraints.maxWidth - scanArea.width) / 2;

                      return ScanOverlay(
                        scanArea: scanArea,
                        top: top,
                        left: left,
                      );
                    },
                    onDetect: (result) {
                      if (result.barcodes.isNotEmpty) {
                        _onScanResult(result);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => camaraController.toggleTorch(),
                      icon: Icon(isTorchOn ? Icons.flash_on : Icons.flash_off),
                    ),

                    PlatformTextButton(
                      onPressed: () => setState(() => isScanning = !isScanning),
                      child: PlatformText(
                        "Close",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),

                    IconButton(
                      onPressed: () => camaraController.switchCamera(),
                      icon: Icon(
                        isCameraFront ? Icons.camera_front : Icons.camera_rear,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  child: const Icon(FontAwesomeIcons.camera, size: 100),
                ),
                const SizedBox(height: 20),
                PlatformText(
                  "Ready to scan",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: PlatformText(
                    textAlign: TextAlign.center,
                    "Position your code within the camara framer. The app will automatically detect it and scan it.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 20),
                PlatformElevatedButton(
                  onPressed: () async {
                    setState(() => isScanning = !isScanning);
                  },
                  child: PlatformText(
                    isScanning ? "Stop scanning" : "Start scanning",
                  ),
                ),
              ],
            ),
          );
  }
}
