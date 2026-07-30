import 'package:code_pocket/themes/app_theme.dart';
import 'package:flutter/material.dart';

class ScanOverlay extends StatefulWidget {
  const ScanOverlay({
    super.key,
    required this.scanArea,
    required this.top,
    required this.left,
  });

  final Size scanArea;
  final double top;
  final double left;

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldAnimate = !MediaQuery.disableAnimationsOf(context);
    if (shouldAnimate && !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    } else if (!shouldAnimate && _animationController.isAnimating) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scanRect = Rect.fromLTWH(
      widget.left,
      widget.top,
      widget.scanArea.width,
      widget.scanArea.height,
    );
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _ScanMaskPainter(scanRect: scanRect)),
          CustomPaint(
            painter: _ScanCornersPainter(
              scanRect: scanRect,
              color: theme.colorScheme.primary,
            ),
          ),
          if (!reduceMotion)
            Positioned(
              left: widget.left + 18,
              top: widget.top,
              width: widget.scanArea.width - 36,
              height: widget.scanArea.height,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(
                      0,
                      (_animationController.value * 2) - 1,
                    ),
                    child: child,
                  );
                },
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.35,
                        ),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScanMaskPainter extends CustomPainter {
  const _ScanMaskPainter({required this.scanRect});

  final Rect scanRect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xA80A0E14),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        scanRect,
        const Radius.circular(AppRadii.surface),
      ),
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScanMaskPainter oldDelegate) =>
      oldDelegate.scanRect != scanRect;
}

class _ScanCornersPainter extends CustomPainter {
  const _ScanCornersPainter({required this.scanRect, required this.color});

  final Rect scanRect;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const length = 34.0;
    const inset = 1.5;
    final rect = scanRect.deflate(inset);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(rect.left, rect.top + length)
      ..lineTo(rect.left, rect.top)
      ..lineTo(rect.left + length, rect.top)
      ..moveTo(rect.right - length, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.top + length)
      ..moveTo(rect.right, rect.bottom - length)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.right - length, rect.bottom)
      ..moveTo(rect.left + length, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.bottom - length);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ScanCornersPainter oldDelegate) =>
      oldDelegate.scanRect != scanRect || oldDelegate.color != color;
}
