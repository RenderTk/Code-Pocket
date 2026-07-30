import 'package:code_pocket/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class CodeImagePreview extends StatelessWidget {
  const CodeImagePreview({
    super.key,
    required this.child,
    required this.controller,
  });

  final Widget child;
  final WidgetsToImageController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WidgetsToImage(
      controller: controller,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 250, maxHeight: 330),
        padding: const EdgeInsets.all(AppSpacing.xl),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFCFDFE),
          borderRadius: BorderRadius.circular(AppRadii.hero),
          border: Border.all(color: const Color(0xFFD8DFE8)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 36,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
