import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/release_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SenandikaApp());
}

class SenandikaApp extends StatelessWidget {
  const SenandikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReleaseProvider>(
      create: (_) => ReleaseProvider(),
      child: MaterialApp(
        title: 'Senandika',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // Batasi skala font sistem agar tata letak kartu tidak overflow.
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: mediaQuery.textScaler.clamp(
                minScaleFactor: 0.9,
                maxScaleFactor: 1.1,
              ),
            ),
            child: child!,
          );
        },
        home: const HomeScreen(),
      ),
    );
  }
}
