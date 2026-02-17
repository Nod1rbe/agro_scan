import 'dart:io';

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

class _ProgressPageState extends State<ProgressPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScanCubit>().analyzeImage(widget.imagePath);
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
                image: File(widget.imagePath),
                disease: state.disease,
                solution: state.solution,
              ),
            ),
          );
        } else if (state is ScanFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Iltimos, kuting...'),
            ],
          ),
        ),
      ),
    );
  }
}



