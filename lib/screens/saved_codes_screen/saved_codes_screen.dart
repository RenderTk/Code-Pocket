import 'package:code_pocket/l10n/l10n.dart';
import 'package:code_pocket/models/code_data.dart';
import 'package:code_pocket/providers/active_screen_provider.dart';
import 'package:code_pocket/providers/codes_provider.dart';
import 'package:code_pocket/providers/selected_code_type_provider.dart';
import 'package:code_pocket/screens/code_preview_screen/code_preview_screen.dart';
import 'package:code_pocket/screens/saved_codes_screen/widgets/code_card.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:code_pocket/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@visibleForTesting
List<CodeData> filterSavedCodes(
  List<CodeData> codes, {
  required String query,
  required SavedCodeFilter filter,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  final matchingType = codes.where((code) => filter.includes(code.codeType));
  if (normalizedQuery.isEmpty) return matchingType.toList(growable: false);

  final startsWith = <CodeData>[];
  final contains = <CodeData>[];
  for (final code in matchingType) {
    final title = code.title.toLowerCase();
    final data = code.data.toLowerCase();
    if (title.startsWith(normalizedQuery)) {
      startsWith.add(code);
    } else if (title.contains(normalizedQuery) ||
        data.contains(normalizedQuery)) {
      contains.add(code);
    }
  }
  return [...startsWith, ...contains];
}

class SavedCodesScreen extends ConsumerStatefulWidget {
  const SavedCodesScreen({super.key});

  @override
  ConsumerState<SavedCodesScreen> createState() => _SavedCodesScreenState();
}

class _SavedCodesScreenState extends ConsumerState<SavedCodesScreen> {
  final _searchController = TextEditingController();
  SavedCodeFilter _selectedFilter = SavedCodeFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete(CodeData code) async {
    try {
      await ref.read(codesProvider.notifier).deleteCode(code.id!);
      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.codeDeleted)));
    } catch (_) {
      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.codeDeleteFailed)));
    }
  }

  void _openCode(CodeData code) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => CodePreviewScreen(
          codeType: code.codeType,
          title: code.title,
          data: code.data,
          readOnly: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final codes = ref.watch(codesProvider);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            0,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: codes.when(
                loading: () => const _LibraryLoadingState(),
                error: (error, stackTrace) => _LibraryErrorState(
                  onRetry: () =>
                      ref.read(codesProvider.notifier).refreshCodes(),
                ),
                data: (savedCodes) => _LibraryContent(
                  codes: savedCodes,
                  query: _searchController.text,
                  searchController: _searchController,
                  selectedFilter: _selectedFilter,
                  onQueryChanged: (_) => setState(() {}),
                  onClearQuery: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  onFilterChanged: (filter) {
                    setState(() => _selectedFilter = filter);
                  },
                  onOpenCode: _openCode,
                  onDeleteCode: _handleDelete,
                  onCreateCode: () {
                    ref
                        .read(activeScreenProvider.notifier)
                        .setActiveScreen(ActiveScreen.createCode);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LibraryContent extends StatelessWidget {
  const _LibraryContent({
    required this.codes,
    required this.query,
    required this.searchController,
    required this.selectedFilter,
    required this.onQueryChanged,
    required this.onClearQuery,
    required this.onFilterChanged,
    required this.onOpenCode,
    required this.onDeleteCode,
    required this.onCreateCode,
  });

  final List<CodeData> codes;
  final String query;
  final TextEditingController searchController;
  final SavedCodeFilter selectedFilter;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;
  final ValueChanged<SavedCodeFilter> onFilterChanged;
  final ValueChanged<CodeData> onOpenCode;
  final Future<void> Function(CodeData) onDeleteCode;
  final VoidCallback onCreateCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final filteredCodes = filterSavedCodes(
      codes,
      query: query,
      filter: selectedFilter,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppPageHeader(
          title: l10n.libraryTitle,
          description: l10n.libraryDescription,
          trailing: codes.isEmpty
              ? null
              : _LibraryCount(count: filteredCodes.length),
        ),
        const SizedBox(height: AppSpacing.lg),
        SearchBar(
          controller: searchController,
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.surface),
          hintText: l10n.searchHint,
          leading: const Icon(Icons.search_rounded),
          trailing: [
            if (query.isNotEmpty)
              IconButton(
                tooltip: l10n.clearSearch,
                onPressed: onClearQuery,
                icon: const Icon(Icons.close_rounded),
              ),
          ],
          onChanged: onQueryChanged,
          onSubmitted: onQueryChanged,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        ),
        const SizedBox(height: AppSpacing.sm),
        _LibraryFilters(
          selectedFilter: selectedFilter,
          onFilterChanged: onFilterChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: codes.isEmpty
              ? _EmptyLibrary(onCreateCode: onCreateCode)
              : filteredCodes.isEmpty
              ? const _NoLibraryResults()
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: filteredCodes.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final code = filteredCodes[index];
                    return CodeCard(
                      key: ValueKey(code.id),
                      codeData: code,
                      onTap: () => onOpenCode(code),
                      onDelete: () => onDeleteCode(code),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _LibraryFilters extends StatelessWidget {
  const _LibraryFilters({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final SavedCodeFilter selectedFilter;
  final ValueChanged<SavedCodeFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    const filters = SavedCodeFilter.values;

    return Row(
      key: const ValueKey('library-filter-row'),
      children: [
        for (var index = 0; index < filters.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: ChoiceChip(
              label: Center(child: Text(filters[index].label(l10n))),
              backgroundColor: theme.colorScheme.surface,
              selected: filters[index] == selectedFilter,
              onSelected: (_) => onFilterChanged(filters[index]),
            ),
          ),
        ],
      ],
    );
  }
}

class _LibraryCount extends StatelessWidget {
  const _LibraryCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadii.control),
      ),
      child: Text(
        '$count',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.onCreateCode});

  final VoidCallback onCreateCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return _LibraryMessage(
      icon: Icons.folder_open_rounded,
      title: l10n.emptyLibraryTitle,
      message: l10n.emptyLibraryMessage,
      action: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        onPressed: onCreateCode,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.createCodeTitle),
      ),
    );
  }
}

class _NoLibraryResults extends StatelessWidget {
  const _NoLibraryResults();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: _LibraryMessage(
        icon: Icons.search_off_rounded,
        title: l10n.noMatchesTitle,
        message: l10n.noMatchesMessage,
      ),
    );
  }
}

class _LibraryMessage extends StatelessWidget {
  const _LibraryMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadii.surface),
                      ),
                      child: Icon(
                        icon,
                        size: 32,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      title,
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (action != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      action!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LibraryLoadingState extends StatelessWidget {
  const _LibraryLoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppPageHeader(
          title: l10n.libraryTitle,
          description: l10n.libraryDescription,
        ),
        const SizedBox(height: AppSpacing.lg),
        _SkeletonBlock(height: 56, color: theme.colorScheme.surface),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) =>
                _SkeletonBlock(height: 98, color: theme.colorScheme.surface),
          ),
        ),
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadii.surface),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
    );
  }
}

class _LibraryErrorState extends StatelessWidget {
  const _LibraryErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppPageHeader(
          title: l10n.libraryTitle,
          description: l10n.libraryDescription,
        ),
        Expanded(
          child: _LibraryMessage(
            icon: Icons.sync_problem_rounded,
            title: l10n.libraryUnavailableTitle,
            message: l10n.libraryUnavailableMessage,
            action: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.tryAgain),
            ),
          ),
        ),
      ],
    );
  }
}
