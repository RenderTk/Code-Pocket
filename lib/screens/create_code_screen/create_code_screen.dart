import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/code_preview_screen/code_preview_screen.dart';
import 'package:code_pocket/screens/create_code_screen/widgets/code_types_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateCodeScreen extends ConsumerStatefulWidget {
  const CreateCodeScreen({super.key});

  @override
  ConsumerState<CreateCodeScreen> createState() => _CreateCodeScreenState();
}

class _CreateCodeScreenState extends ConsumerState<CreateCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _dataController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCodeType = ref.watch(selectedCodeTypeProvider);
    final hintTextFieldName = switch (selectedCodeType) {
      CodeType.qrCode => 'My QR code name here',
      CodeType.barCode => 'My barcode name here',
    };
    final generateCodeLable = switch (selectedCodeType) {
      CodeType.qrCode => 'Generate QR Code',
      CodeType.barCode => 'Generate Bar Code',
    };
    final generateCodeIcon = switch (selectedCodeType) {
      CodeType.qrCode => FontAwesomeIcons.qrcode,
      CodeType.barCode => FontAwesomeIcons.barcode,
    };

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlatformText(
                'Code Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const CodeTypeButtons(),
              const SizedBox(height: 16),
              PlatformText(
                "Title",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              // Name TextField
              PlatformTextFormField(
                controller: _titleController,
                autocorrect: false,
                hintText: hintTextFieldName,
                cursorColor: Theme.of(context).colorScheme.primary,
                material: (context, platform) => MaterialTextFormFieldData(
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                cupertino: (context, platform) => CupertinoTextFormFieldData(
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  if (ref.read(codesProvider.notifier).exists(value.trim())) {
                    return 'A ${selectedCodeType == CodeType.qrCode ? 'QR Code' : 'Bar Code'} with this title already exists';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PlatformText(
                "URL, Text or Data",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              // Data TextField
              PlatformTextFormField(
                controller: _dataController,
                autocorrect: false,
                hintText: "Enter your URL, text or data here",
                minLines: 5,
                maxLines: 10,
                cursorColor: Theme.of(context).colorScheme.primary,
                keyboardType: TextInputType.multiline,
                material: (context, platform) => MaterialTextFormFieldData(
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                cupertino: (context, platform) => CupertinoTextFormFieldData(
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a URL, text or data';
                  }
                  if (value.length > 100 &&
                      selectedCodeType == CodeType.barCode) {
                    return 'Barcodes support up to 100 characters only';
                  }
                  if (value.length > 3000 &&
                      selectedCodeType == CodeType.qrCode) {
                    return 'QR Codes support up to 3000 characters only';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: PlatformElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CodePreviewScreen(
                            codeType: selectedCodeType,
                            title: _titleController.text,
                            data: _dataController.text,
                          );
                        },
                      ),
                    );

                    if (result == true) {
                      _titleController.clear();
                      _dataController.clear();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(generateCodeIcon, size: 20),
                      const SizedBox(width: 12),
                      PlatformText(generateCodeLable),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
