import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodeTypeButtons extends ConsumerWidget {
  const CodeTypeButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedCodeType = ref.watch(selectedCodeTypeProvider);

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<CodeType>(
        showSelectedIcon: false,
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 58)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: theme.colorScheme.outline),
          ),
          textStyle: WidgetStatePropertyAll(theme.textTheme.labelLarge),
        ),
        segments: CodeType.values
            .map(
              (type) => ButtonSegment<CodeType>(
                value: type,
                icon: Icon(type.icon),
                label: Text(type.label),
              ),
            )
            .toList(growable: false),
        selected: {selectedCodeType},
        onSelectionChanged: (selection) {
          ref
              .read(selectedCodeTypeProvider.notifier)
              .setCodeType(selection.first);
        },
      ),
    );
  }
}
