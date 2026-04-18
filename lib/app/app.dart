import 'package:agro_scan/app/app_theme.dart';
import 'package:agro_scan/app/theme_scope.dart';
import 'package:agro_scan/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static const String _prefKey = 'theme_mode_index';

  ThemeMode _themeMode = ThemeMode.system;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final idx = prefs.getInt(_prefKey);
    ThemeMode mode = ThemeMode.system;
    if (idx != null && idx >= 0 && idx < ThemeMode.values.length) {
      mode = ThemeMode.values[idx];
    }
    if (!mounted) return;
    setState(() {
      _themeMode = mode;
      _ready = true;
    });
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, mode.index);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppThemeLight(),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return ThemeScope(
      themeMode: _themeMode,
      setThemeMode: _setThemeMode,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AgroScan',
        themeMode: _themeMode,
        theme: buildAppThemeLight(),
        darkTheme: buildAppThemeDark(),
        home: const SplashPage(),
      ),
    );
  }
}
