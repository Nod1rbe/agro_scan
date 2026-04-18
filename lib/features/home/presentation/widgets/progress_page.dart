import 'dart:io';
import 'dart:ui';

import 'package:agro_scan/core/ui/top_alert.dart';
import 'package:agro_scan/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:agro_scan/features/scan/presentation/pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressPage extends StatefulWidget {
  final String imagePath;
  const ProgressPage({super.key, required this.imagePath});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  static const double _scanFrameHeight = 340;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
    context.read<ScanCubit>().analyzeImage(widget.imagePath);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanCubit, ScanState>(
      listener: (context, state) {
        if (state is ScanSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResultPage(
                imagePath: widget.imagePath,
                disease: state.disease,
                description: state.description,
                solution: state.solution,
              ),
            ),
          );
        } else if (state is ScanFailure) {
          showTopAlert(context, message: state.message, isError: true);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: const Color(0x73000000)),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ScanFrame(
                      controller: _scanController,
                      height: _scanFrameHeight,
                      imagePath: widget.imagePath,
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Rasm tahlil qilinmoqda...',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'AlfaSlabOne',
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kasallik belgilari AI orqali tekshirilyapti',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Alice',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanFrame extends StatelessWidget {
  const _ScanFrame({
    required this.controller,
    required this.height,
    required this.imagePath,
  });

  final AnimationController controller;
  final double height;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00C950), width: 2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final top = (controller.value * (height - 4)) - 4;
            return Stack(
              children: [
                Positioned.fill(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: const Color(0x2E000000),
                  ),
                ),
                Positioned(
                  top: top,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0x0000C950),
                          const Color(0xF200C950),
                          const Color(0x0000C950),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xA600FF66),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}