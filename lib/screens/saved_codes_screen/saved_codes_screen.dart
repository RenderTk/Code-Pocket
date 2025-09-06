import 'package:code_pocket/providers/codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedCodesScreen extends ConsumerWidget {
  const SavedCodesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codes = ref.watch(codesProvider);

    return codes.when(
      data: (codes) {
        if (codes.isEmpty) {
          return Center(
            child: Text(
              'No saved codes yet.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: codes.length,
              itemBuilder: (context, index) {
                final code = codes[index];
                return Card(
                  child: ListTile(
                    title: Text(code.title),
                    subtitle: Text(code.data),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref.read(codesProvider.notifier).deleteCode(code.id!);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
