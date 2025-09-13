import 'package:barcode_widget/barcode_widget.dart';
import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/code_preview_screen/widgets/code_image_preview.dart';
import 'package:code_pocket/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ScanResultScreen extends ConsumerStatefulWidget {
  const ScanResultScreen({
    super.key,
    required this.data,
    required this.codeType,
  });
  final String data;
  final CodeType codeType;

  @override
  ConsumerState<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends ConsumerState<ScanResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageController = WidgetsToImageController();

  @override
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  bool validateTitle() {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final hintTextFieldName = switch (widget.codeType) {
      CodeType.qrCode => 'My QR code name here',
      CodeType.barCode => 'My barcode name here',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 50, color: Colors.green),
                ),
                const SizedBox(height: 5),
                PlatformText(
                  "Successfull scan",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                PlatformTextFormField(
                  controller: _titleController,
                  autocorrect: false,
                  hintText: hintTextFieldName,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    if (ref.read(codesProvider.notifier).exists(value.trim())) {
                      return 'A ${widget.codeType == CodeType.qrCode ? 'QR Code' : 'Bar Code'} with this title already exists';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // CODE PREVIEW BARCODE
                if (widget.codeType == CodeType.barCode)
                  CodeImagePreview(
                    controller: _imageController,
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

                // CODE PREVIEW QR
                if (widget.codeType == CodeType.qrCode)
                  CodeImagePreview(
                    controller: _imageController,
                    child: QrImageView(
                      data: widget.data, // The data to encode
                      version: QrVersions
                          .auto, // Automatically determines the QR code version
                    ),
                  ),
                const SizedBox(height: 16),

                ///SAVE BUTTON
                PlatformElevatedButton(
                  onPressed: () async {
                    if (!validateTitle()) return;

                    final code = CodeData(
                      title: _titleController.text,
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

                const SizedBox(height: 10),

                // SHARE BUTTON
                PlatformElevatedButton(
                  onPressed: () async {
                    if (!validateTitle()) return;

                    onShareCode(
                      context,
                      _imageController,
                      title: _titleController.text,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FontAwesomeIcons.share, size: 16),
                      const SizedBox(width: 8),
                      PlatformText('Share'),
                    ],
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
