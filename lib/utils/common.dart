import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

Rect sharePositionOriginFor(BuildContext context) {
  final renderObject = context.findRenderObject();
  if (renderObject is RenderBox && renderObject.hasSize) {
    final rect = renderObject.localToGlobal(Offset.zero) & renderObject.size;
    if (!rect.isEmpty) return rect;
  }

  final viewSize = MediaQuery.sizeOf(context);
  return Offset.zero & viewSize;
}

Future<void> shareCodeImage(
  WidgetsToImageController controller, {
  required String title,
  required Rect sharePositionOrigin,
  String? text,
}) async {
  final Uint8List? pngBytes = await controller.capturePng(
    pixelRatio: 3,
    waitForAnimations: true,
  );
  if (pngBytes == null) {
    throw StateError('The code image could not be captured.');
  }

  final tempDirectory = await getTemporaryDirectory();
  final safeTitle = title
      .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')
      .replaceAll(RegExp('_+'), '_');
  final file = File(
    '${tempDirectory.path}/${safeTitle.isEmpty ? 'code' : safeTitle}.png',
  );
  await file.writeAsBytes(pngBytes, flush: true);

  try {
    await SharePlus.instance.share(
      ShareParams(
        title: title,
        subject: title,
        text: text,
        files: [XFile(file.path, mimeType: 'image/png')],
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  } finally {
    unawaited(
      Future<void>.delayed(const Duration(seconds: 10), () async {
        if (await file.exists()) {
          await file.delete();
        }
      }),
    );
  }
}
