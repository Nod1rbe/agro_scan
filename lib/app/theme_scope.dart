import 'package:flutter/material.dart';

/// Ilova daraxtida [MaterialApp] ustida turadi — sahifalardan tema boshqaruvi.
class ThemeScope extends InheritedWidget {
  const ThemeScope({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> setThemeMode;

  static ThemeScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope topilmadi');
    return scope!;
  }

  @override
  bool updateShouldNotify(ThemeScope oldWidget) => oldWidget.themeMode != themeMode;
}
