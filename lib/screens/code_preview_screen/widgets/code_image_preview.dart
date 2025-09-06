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
    return WidgetsToImage(
      controller: controller,
      child: Container(
        margin: const EdgeInsets.all(12),
        width: double.infinity,
        height: 270,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24),
        ),
        child: child,
      ),
    );
  }
}
