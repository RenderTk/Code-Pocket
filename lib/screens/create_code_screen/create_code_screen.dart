import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/code_preview_screen/code_preview_screen.dart';
import 'package:code_pocket/screens/create_code_screen/widgets/code_types_buttons.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:code_pocket/utils/tactile_feedback.dart';
import 'package:code_pocket/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCodeScreen extends ConsumerStatefulWidget {
  const CreateCodeScreen({super.key});

  @override
  ConsumerState<CreateCodeScreen> createState() => _CreateCodeScreenState();
}

class _CreateCodeScreenState extends ConsumerState<CreateCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dataController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _dataFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _dataController.dispose();
    _titleFocusNode.dispose();
    _dataFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleGenerate(CodeType codeType) async {
    if (!_formKey.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();
    selectionHaptic();

    final didFinish = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CodePreviewScreen(
          codeType: codeType,
          title: _titleController.text.trim(),
          data: _dataController.text.trim(),
        ),
      ),
    );

    if (!mounted || didFinish != true) return;
    _formKey.currentState?.reset();
    _titleFocusNode.requestFocus();
  }

  String? _validateTitle(String? value, CodeType codeType) {
    final title = value?.trim() ?? '';
    if (title.isEmpty) return 'Enter a name for this ${codeType.label}.';
    if (ref.read(codesProvider.notifier).exists(title)) {
      return 'A saved code already uses this name.';
    }
    return null;
  }

  String? _validateData(String? value, CodeType codeType) {
    final data = value?.trim() ?? '';
    if (data.isEmpty) return 'Enter the value you want to encode.';
    if (data.length > codeType.maxLength) {
      return '${codeType.label}s support up to ${codeType.maxLength} characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCodeType = ref.watch(selectedCodeTypeProvider);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppPageHeader(
                              title: 'Create a code',
                              description:
                                  'Turn a link, message, or identifier into a code you can save and share.',
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            const _FieldLabel(
                              label: 'Format',
                              helper: 'Choose how the value should be encoded.',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            const CodeTypeButtons(),
                            const SizedBox(height: AppSpacing.xl),
                            const _FieldLabel(
                              label: 'Name',
                              helper:
                                  'Use a name that will be easy to find in your library.',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _titleController,
                              focusNode: _titleFocusNode,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: selectedCodeType.titleHint,
                              ),
                              validator: (value) =>
                                  _validateTitle(value, selectedCodeType),
                              onFieldSubmitted: (_) =>
                                  _dataFocusNode.requestFocus(),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _FieldLabel(
                              label: 'Content',
                              helper: selectedCodeType == CodeType.qrCode
                                  ? 'QR codes can store links, messages, and longer text.'
                                  : 'Code 128 barcodes work best with short identifiers.',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              key: ValueKey(selectedCodeType),
                              controller: _dataController,
                              focusNode: _dataFocusNode,
                              autocorrect: false,
                              keyboardType: TextInputType.multiline,
                              minLines: selectedCodeType == CodeType.qrCode
                                  ? 5
                                  : 3,
                              maxLines: 8,
                              maxLength: selectedCodeType.maxLength,
                              decoration: InputDecoration(
                                hintText: selectedCodeType.dataHint,
                                alignLabelWithHint: true,
                              ),
                              validator: (value) =>
                                  _validateData(value, selectedCodeType),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xs,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _handleGenerate(selectedCodeType),
                          icon: Icon(selectedCodeType.icon),
                          label: Text(selectedCodeType.generateLabel),
                        ),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.helper});

  final String label;
  final String helper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          helper,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
