import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class _CodeButton extends StatelessWidget {
  const _CodeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  width: 2,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 25),
            PlatformText(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeTypeButtons extends ConsumerWidget {
  const CodeTypeButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCodeType = ref.watch(selectedCodeTypeProvider);
    final qrCodeSelected = selectedCodeType == CodeType.qrCode;
    final barCodeSelected = selectedCodeType == CodeType.barCode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _CodeButton(
            label: "QR Code",
            icon: FontAwesomeIcons.qrcode,
            isSelected: qrCodeSelected,
            onTap: () {
              ref
                  .read(selectedCodeTypeProvider.notifier)
                  .setCodeType(CodeType.qrCode);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _CodeButton(
            label: "Bar Code",
            icon: FontAwesomeIcons.barcode,
            isSelected: barCodeSelected,
            onTap: () {
              ref
                  .read(selectedCodeTypeProvider.notifier)
                  .setCodeType(CodeType.barCode);
            },
          ),
        ),
      ],
    );
  }
}
