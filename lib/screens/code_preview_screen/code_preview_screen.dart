import 'package:barcode_widget/barcode_widget.dart';
import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/code_preview_screen/widgets/code_image_preview.dart';
import 'package:code_pocket/utils/common.dart';
import 'package:code_pocket/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class CodePreviewScreen extends ConsumerStatefulWidget {
  const CodePreviewScreen({
    super.key,
    required this.codeType,
    required this.title,
    required this.data,
    this.readOnly = false,
  });
  final CodeType codeType;
  final String title;
  final String data;
  final bool readOnly;

  @override
  ConsumerState<CodePreviewScreen> createState() => _CodePreviewScreenState();
}

class _CodePreviewScreenState extends ConsumerState<CodePreviewScreen> {
  final _controller = WidgetsToImageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.codeType == CodeType.qrCode
            ? PlatformText('QR Code Preview')
            : PlatformText('Bar Code Preview'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlatformText(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                if (widget.codeType == CodeType.barCode)
                  CodeImagePreview(
                    controller: _controller,
                    child: SizedBox(
                      width: 300,
                      height: 120,
                      child: BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: widget.data,
                        drawText: true,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                if (widget.codeType == CodeType.qrCode)
                  CodeImagePreview(
                    controller: _controller,
                    child: QrImageView(
                      data: widget.data, // The data to encode
                      version: QrVersions
                          .auto, // Automatically determines the QR code version
                    ),
                  ),
                const SizedBox(height: 16),

                if (!widget.readOnly) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // COPY BUTTON
                      Expanded(
                        child: PlatformElevatedButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget.data));
                            SnackbarHelper.showCustomSnackbar(
                              context: context,
                              message: "Copied to clipboard!",
                              type: SnackbarType.info,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.copy, size: 16),
                              const SizedBox(width: 8),
                              PlatformText('Copy'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // SAVE BUTTON
                      Expanded(
                        child: PlatformElevatedButton(
                          onPressed: () async {
                            final code = CodeData(
                              title: widget.title,
                              data: widget.data,
                              codeType: widget.codeType,
                            );
                            await onSaveCode(context, ref, code);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.floppyDisk, size: 16),
                              const SizedBox(width: 8),
                              PlatformText('Save'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // SHARE BUTTON
                  PlatformElevatedButton(
                    onPressed: () async =>
                        onShareCode(context, _controller, title: widget.title),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(FontAwesomeIcons.share, size: 16),
                        const SizedBox(width: 8),
                        PlatformText('Share'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // CREATE ANOTHER QR/BARCODE
                  PlatformElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(FontAwesomeIcons.plus, size: 16),
                        const SizedBox(width: 8),
                        PlatformText('Create Another'),
                      ],
                    ),
                  ),
                ],

                if (widget.readOnly) ...[
                  // SHARE BUTTON
                  PlatformElevatedButton(
                    onPressed: () async =>
                        onShareCode(context, _controller, title: widget.title),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(FontAwesomeIcons.share, size: 16),
                        const SizedBox(width: 8),
                        PlatformText('Share'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  PlatformElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.data));
                      SnackbarHelper.showCustomSnackbar(
                        context: context,
                        message: "Copied to clipboard!",
                        type: SnackbarType.info,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(FontAwesomeIcons.copy, size: 16),
                        const SizedBox(width: 8),
                        PlatformText('Copy'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
