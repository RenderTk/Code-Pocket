import 'package:code_pocket/l10n/l10n.dart';
import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/code_preview_screen/widgets/code_image_preview.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:code_pocket/utils/common.dart';
import 'package:code_pocket/utils/tactile_feedback.dart';
import 'package:code_pocket/widgets/code_payload_panel.dart';
import 'package:code_pocket/widgets/code_visual.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _isSaving = false;
  bool _isSharing = false;

  @override
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    final l10n = context.l10n;
    final title = value?.trim() ?? '';
    if (title.isEmpty) return l10n.scanNameRequired;
    if (ref.read(codesProvider.notifier).exists(title)) {
      return l10n.duplicateName;
    }
    return null;
  }

  Future<void> _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.data));
    selectionHaptic();
    if (!mounted) return;
    final l10n = context.l10n;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.copiedToClipboard)));
  }

  Future<void> _handleShare() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final enteredTitle = _titleController.text.trim();
      final l10n = context.l10n;
      await shareCodeImage(
        _imageController,
        title: enteredTitle.isEmpty
            ? widget.codeType.scannedShareTitle(l10n)
            : enteredTitle,
        text: widget.data,
        sharePositionOrigin: sharePositionOriginFor(context),
      );
    } catch (error, stackTrace) {
      debugPrint('Scanned code sharing failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _handleSave() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(codesProvider.notifier)
          .addCode(
            CodeData(
              title: _titleController.text.trim(),
              data: widget.data,
              codeType: widget.codeType,
            ),
          );
      confirmationHaptic();
      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.savedToLibrary)));
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanResultTitle)),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ScanSuccessHeader(codeType: widget.codeType),
                    const SizedBox(height: AppSpacing.xl),
                    CodeImagePreview(
                      controller: _imageController,
                      child: CodeVisual(
                        codeType: widget.codeType,
                        data: widget.data,
                        size: widget.codeType == CodeType.qrCode ? 220 : 340,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    CodePayloadPanel(data: widget.data),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l10n.scanSaveTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(l10n.scanSaveHelper, style: theme.textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _titleController,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: widget.codeType.titleHint(l10n),
                      ),
                      validator: _validateTitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isSaving ? null : _handleSave,
                        icon: _isSaving
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.bookmark_add_outlined),
                        label: Text(
                          _isSaving ? l10n.saving : l10n.saveToLibrary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _handleCopy,
                            icon: const Icon(Icons.content_copy_rounded),
                            label: Text(l10n.copy),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isSharing ? null : _handleShare,
                            icon: const Icon(Icons.ios_share_rounded),
                            label: Text(_isSharing ? l10n.sharing : l10n.share),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.center_focus_strong_rounded),
                        label: Text(l10n.scanAnother),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanSuccessHeader extends StatelessWidget {
  const _ScanSuccessHeader({required this.codeType});

  final CodeType codeType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF23845C).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Color(0xFF23845C)),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.codeCaptured, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                codeType.detectedMessage(l10n),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
