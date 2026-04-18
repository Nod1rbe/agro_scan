import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showTopAlert(
  BuildContext context, {
  required String message,
  bool isError = true,
}) {
  Flushbar<void>(
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Alice',
        fontSize: 14,
      ),
    ),
    icon: Icon(
      isError ? Icons.error_outline : Icons.check_circle_outline,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(12),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: isError ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32),
  ).show(context);
}
