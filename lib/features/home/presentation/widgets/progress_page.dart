import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressPage extends StatelessWidget {
  final String imagePath;
  const ProgressPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            SvgPicture.asset('assets/icons/logo.svg', height: 70),
            SizedBox(height: 16),
            SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Color(0xFF00C950))),
            SizedBox(height: 16),
            Text('Rasm tahlil qilinmoqda...', style: TextStyle(fontFamily: 'AlfaSlabOne', fontSize: 16)),
            SizedBox(height: 8),
            Text(
              'Sun’iy intellekt o‘simlikni kasalliklar bor-yo‘qligini tekshirmoqda',
              style: TextStyle(fontFamily: 'Alice'),
              textAlign: .center,
            ),
          ],
        ),
      ),
    );
  }
}
