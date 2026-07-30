import 'package:code_pocket/screens/home_screen/home_screen.dart';
import 'package:code_pocket/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Code Pocket',
      color: theme.colorScheme.surface,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      themeAnimationDuration: AppDurations.standard,
      themeAnimationCurve: Curves.easeOutCubic,
      home: const HomeScreen(),
    );
  }
}
