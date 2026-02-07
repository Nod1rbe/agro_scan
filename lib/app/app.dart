import 'package:agro_scan/features/home/presentation/pages/home_page.dart';
import 'package:agro_scan/features/splash/splash_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: SplashPage(),
    );
  }
}
