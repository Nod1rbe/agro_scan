import 'package:agro_scan/app/app.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late final List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const App());
}
