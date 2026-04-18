import 'package:flutter/material.dart';

const Color _seed = Color(0xFF00C950);

ThemeData buildAppThemeLight() {
  final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.light);
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Alice',
    splashFactory: InkSparkle.splashFactory,
  );
  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    textTheme: base.textTheme.copyWith(
      headlineLarge: base.textTheme.headlineLarge?.copyWith(fontFamily: 'AlfaSlabOne'),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(fontFamily: 'AlfaSlabOne'),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(fontFamily: 'AlfaSlabOne'),
      titleLarge: base.textTheme.titleLarge?.copyWith(fontFamily: 'AlfaSlabOne'),
      titleMedium: base.textTheme.titleMedium?.copyWith(fontFamily: 'AlfaSlabOne'),
      titleSmall: base.textTheme.titleSmall?.copyWith(fontFamily: 'AlfaSlabOne'),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      titleTextStyle: TextStyle(
        fontFamily: 'AlfaSlabOne',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: scheme.surfaceContainerLow,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

ThemeData buildAppThemeDark() {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF22C55E),
    brightness: Brightness.dark,
    surface: const Color(0xFF0F1412),
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Alice',
    splashFactory: InkSparkle.splashFactory,
  );
  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    textTheme: base.textTheme.copyWith(
      headlineLarge: base.textTheme.headlineLarge?.copyWith(fontFamily: 'AlfaSlabOne'),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(fontFamily: 'AlfaSlabOne'),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(fontFamily: 'AlfaSlabOne'),
      titleLarge: base.textTheme.titleLarge?.copyWith(fontFamily: 'AlfaSlabOne'),
      titleMedium: base.textTheme.titleMedium?.copyWith(fontFamily: 'AlfaSlabOne'),
      titleSmall: base.textTheme.titleSmall?.copyWith(fontFamily: 'AlfaSlabOne'),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      titleTextStyle: TextStyle(
        fontFamily: 'AlfaSlabOne',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: scheme.surfaceContainerHigh,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}
