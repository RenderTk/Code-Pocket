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
  final _imageController = WidgetsToImageController();
  bool _isSaving = false;
  bool _isSharing = false;

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
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
      await shareCodeImage(
        _imageController,
        title: widget.title,
        text: widget.data,
        sharePositionOrigin: sharePositionOriginFor(context),
      );
    } catch (error, stackTrace) {
      debugPrint('Code sharing failed: $error');
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
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      await ref
          .read(codesProvider.notifier)
          .addCode(
            CodeData(
              title: widget.title,
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.readOnly ? l10n.savedCodeTitle : l10n.previewTitle),
      ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PreviewHeader(
                    title: widget.title,
                    codeType: widget.codeType,
                  ),
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
                  _PreviewActions(
                    readOnly: widget.readOnly,
                    isSaving: _isSaving,
                    isSharing: _isSharing,
                    onSave: _handleSave,
                    onCopy: _handleCopy,
                    onShare: _handleShare,
                    onCreateAnother: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({required this.title, required this.codeType});

  final String title;
  final CodeType codeType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.previewReady,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Chip(
          avatar: Icon(codeType.icon, size: 18),
          label: Text(codeType.label(l10n)),
          side: BorderSide(color: theme.colorScheme.outline),
          backgroundColor: theme.colorScheme.surface,
        ),
      ],
    );
  }
}

class _PreviewActions extends StatelessWidget {
  const _PreviewActions({
    required this.readOnly,
    required this.isSaving,
    required this.isSharing,
    required this.onSave,
    required this.onCopy,
    required this.onShare,
    required this.onCreateAnother,
  });

  final bool readOnly;
  final bool isSaving;
  final bool isSharing;
  final VoidCallback onSave;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onCreateAnother;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      children: [
        if (!readOnly)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isSaving ? null : onSave,
              icon: isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.bookmark_add_outlined),
              label: Text(isSaving ? l10n.saving : l10n.saveToLibrary),
            ),
          ),
        if (!readOnly) const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCopy,
                icon: const Icon(Icons.content_copy_rounded),
                label: Text(l10n.copy),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: readOnly
                  ? FilledButton.icon(
                      onPressed: isSharing ? null : onShare,
                      icon: const Icon(Icons.ios_share_rounded),
                      label: Text(isSharing ? l10n.sharing : l10n.share),
                    )
                  : OutlinedButton.icon(
                      onPressed: isSharing ? null : onShare,
                      icon: const Icon(Icons.ios_share_rounded),
                      label: Text(isSharing ? l10n.sharing : l10n.share),
                    ),
            ),
          ],
        ),
        if (!readOnly) ...[
          const SizedBox(height: AppSpacing.xs),
          TextButton.icon(
            onPressed: onCreateAnother,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.createAnother),
          ),
        ],
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.whiteCanvasNote,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
