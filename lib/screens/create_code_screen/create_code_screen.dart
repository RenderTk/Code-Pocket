import 'package:code_pocket/l10n/l10n.dart';
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
    final l10n = context.l10n;
    final title = value?.trim() ?? '';
    if (title.isEmpty) return codeType.nameRequiredError(l10n);
    if (ref.read(codesProvider.notifier).exists(title)) {
      return l10n.duplicateName;
    }
    return null;
  }

  String? _validateData(String? value, CodeType codeType) {
    final l10n = context.l10n;
    final data = value?.trim() ?? '';
    if (data.isEmpty) return l10n.contentRequired;
    if (data.length > codeType.maxLength) {
      return codeType.tooLongError(l10n);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
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
                            AppPageHeader(
                              title: l10n.createCodeTitle,
                              description: l10n.createCodeDescription,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _FieldLabel(
                              label: l10n.formatLabel,
                              helper: l10n.formatHelper,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            const CodeTypeButtons(),
                            const SizedBox(height: AppSpacing.xl),
                            _FieldLabel(
                              label: l10n.nameLabel,
                              helper: l10n.nameHelper,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextFormField(
                              controller: _titleController,
                              focusNode: _titleFocusNode,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: selectedCodeType.titleHint(l10n),
                              ),
                              validator: (value) =>
                                  _validateTitle(value, selectedCodeType),
                              onFieldSubmitted: (_) =>
                                  _dataFocusNode.requestFocus(),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _FieldLabel(
                              label: l10n.contentLabel,
                              helper: selectedCodeType == CodeType.qrCode
                                  ? l10n.qrContentHelper
                                  : l10n.barcodeContentHelper,
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
                                hintText: selectedCodeType.dataHint(l10n),
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
                          label: Text(selectedCodeType.generateLabel(l10n)),
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
