import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/release_model.dart';

class AppColors {
  AppColors._();

  static const Color paper = Color(0xFFF2EADB);
  static const Color paperDeep = Color(0xFFE6DAC4);
  static const Color surface = Color(0xFFF8F3E8);
  static const Color ink = Color(0xFF241C17);
  static const Color inkSoft = Color(0xFF6A5C50);
  static const Color oxblood = Color(0xFF7B2B1E);
  static const Color ochre = Color(0xFFC9962F);
  static const Color ochreLight = Color(0xFFE6BF6E);
  static const Color pine = Color(0xFF4B5A3C);

  static const Color hairline = Color(0x33241C17);
  static const Color hairlineStrong = Color(0x66241C17);

  static Color formatBackground(ReleaseFormat format) => switch (format) {
    ReleaseFormat.vinyl => oxblood,
    ReleaseFormat.kaset => ochre,
    ReleaseFormat.cd => pine,
  };

  static Color formatForeground(ReleaseFormat format) => switch (format) {
    ReleaseFormat.vinyl => paper,
    ReleaseFormat.kaset => ink,
    ReleaseFormat.cd => paper,
  };
}

class AppText {
  AppText._();

  static TextStyle serif({
    double size = 16,
    FontWeight weight = FontWeight.w600,
    bool italic = false,
    Color color = AppColors.ink,
    double height = 1.2,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.fraunces(
      fontSize: size,
      fontWeight: weight,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle mono({
    double size = 12,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double height = 1.3,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.ibmPlexMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.oxblood,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.oxblood,
          onPrimary: AppColors.paper,
          surface: AppColors.paper,
          onSurface: AppColors.ink,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.paper,
      splashColor: const Color(0x1F7B2B1E),
      highlightColor: Colors.transparent,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.oxblood,
        selectionColor: Color(0x337B2B1E),
        selectionHandleColor: AppColors.oxblood,
      ),
    );
  }
}
