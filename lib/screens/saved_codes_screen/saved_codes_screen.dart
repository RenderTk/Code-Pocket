import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/screens/code_preview_screen/code_preview_screen.dart';
import 'package:code_pocket/screens/saved_codes_screen/widgets/code_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedCodesScreen extends ConsumerStatefulWidget {
  const SavedCodesScreen({super.key});

  @override
  ConsumerState<SavedCodesScreen> createState() => _SavedCodesScreenState();
}

class _SavedCodesScreenState extends ConsumerState<SavedCodesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final codes = ref.watch(codesProvider);

    return codes.when(
      data: (codes) {
        final List<CodeData> filteredCodes;

        if (_searchController.text.isNotEmpty) {
          filteredCodes = codes.where((code) {
            return code.title.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );
          }).toList();
        } else {
          filteredCodes = codes;
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SearchBar(
                controller: _searchController,
                hintText: 'Search your codes',
                trailing: [
                  PlatformIconButton(
                    icon: Icon(
                      PlatformIcons(context).clear,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _searchController.text = value;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    _searchController.text = value;
                  });
                },
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
              const SizedBox(height: 15),
              filteredCodes.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: filteredCodes.length,
                        itemBuilder: (context, index) {
                          final code = filteredCodes[index];
                          return CodeCard(
                            codeData: code,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CodePreviewScreen(
                                    codeType: code.codeType,
                                    title: code.title,
                                    data: code.data,
                                    readOnly: true,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  : Expanded(
                      // Wrap the Column with Expanded
                      child: Center(
                        // Add Center widget
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No saved codes found',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching for a code or generating a new one.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
      loading: () => const Center(child: PlatformCircularProgressIndicator()),
      error: (error, stack) => Center(child: PlatformText('Error: $error')),
    );
  }
}
