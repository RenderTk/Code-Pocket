import 'dart:io';
import 'dart:typed_data';

import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

Future<void> onShareCode(
  BuildContext context,
  WidgetsToImageController controller, {
  String? title,
  String? subject,
  String? text,
}) async {
  try {
    // Capture as PNG with high resolution
    Uint8List? pngBytes = await controller.capturePng(
      pixelRatio: 3.0,
      waitForAnimations: true,
    );

    if (pngBytes == null) {
      throw Exception('Failed to capture image');
    }

    // Get temporary directory
    final Directory tempDir = await getTemporaryDirectory();

    // Create a unique filename
    final String fileName = 'code_${DateTime.now().millisecondsSinceEpoch}.png';
    final String filePath = '${tempDir.path}/$fileName';

    // Write PNG bytes to temporary file
    final File tempFile = File(filePath);
    await tempFile.writeAsBytes(pngBytes);

    // Share the image file
    await SharePlus.instance.share(
      ShareParams(
        title: title,
        text: text,
        subject: subject,
        files: [XFile(filePath)],
      ),
    );

    // Optional: Clean up the temporary file after a delay
    // (Share Plus usually copies the file, so it's safe to delete)
    Future.delayed(const Duration(seconds: 10), () {
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }
    });
  } catch (e) {
    if (!context.mounted) return;

    SnackbarHelper.showCustomSnackbar(
      context: context,
      message: "Failed to share code: $e",
      type: SnackbarType.error,
    );
  }
}

Future<void> onSaveCode(
  BuildContext context,
  WidgetRef ref,
  CodeData code,
) async {
  final notifier = ref.read(codesProvider.notifier);

  await notifier.addCode(code);

  if (ref.read(codesProvider).hasError) {
    notifier.clearError();
    if (context.mounted) {
      SnackbarHelper.showCustomSnackbar(
        context: context,
        message:
            "Error saving ${code.codeType == CodeType.qrCode ? "QR code" : "Barcode"}!",
        type: SnackbarType.error,
      );
    }
    return;
  }

  if (context.mounted) {
    SnackbarHelper.showCustomSnackbar(
      context: context,
      message:
          "${code.codeType == CodeType.qrCode ? "QR code" : "Barcode"} saved!",
      type: SnackbarType.success,
    );
    Navigator.pop(context, true);
  }
}
