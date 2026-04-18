import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class ScanAnalysis {
  const ScanAnalysis({
    required this.disease,
    required this.description,
    required this.solution,
  });

  final String disease;
  final String description;
  final String solution;
}

class ScanRepository {
  static const String _endpoint = 'https://api.openai.com/v1/responses';
  static const String _model = 'gpt-4.1-mini';
  static const int _maxImageSide = 1280;
  static const int _jpegQuality = 72;

  Future<ScanAnalysis> analyzeImage(String imagePath) async {
    final apiKey = _normalizeApiKey(dotenv.env['OPENAI_API_KEY'] ?? '');
    if (apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY topilmadi. .env faylga qo`shing.');
    }

    final imageDataUri = await _prepareImageDataUri(imagePath);

    final payload = <String, dynamic>{
      'model': _model,
      'temperature': 0.2,
      'max_output_tokens': 280,
      'input': <Map<String, dynamic>>[
        <String, dynamic>{
          'role': 'system',
          'content': <Map<String, dynamic>>[
            <String, dynamic>{
              'type': 'input_text',
              'text':
                  'Sen o`simlik kasalliklari bo`yicha agronom yordamchisan. Juda qisqa, aniq va foydali javob ber.',
            },
          ],
        },
        <String, dynamic>{
          'role': 'user',
          'content': <Map<String, dynamic>>[
            <String, dynamic>{
              'type': 'input_text',
              'text':
                  'Rasmni tahlil qil va faqat JSON qaytar: {"disease":"...","description":"...","solution":"..."} . Har bir maydon 1-3 gapdan oshmasin.',
            },
            <String, dynamic>{
              'type': 'input_image',
              'image_url': imageDataUri,
              'detail': 'low',
            },
          ],
        },
      ],
    };

    final response = await _postWithRetry(apiKey: apiKey, payload: payload);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final preview = response.body.length > 200
          ? '${response.body.substring(0, 200)}...'
          : response.body;
      throw Exception('AI so`rovida xatolik: ${response.statusCode}. $preview');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final rawText = _extractOutputText(data);
    final parsed = _safeJsonDecode(rawText);

    return ScanAnalysis(
      disease: parsed['disease']?.toString().trim().isNotEmpty == true
          ? parsed['disease'].toString().trim()
          : 'Aniqlanmadi',
      description: parsed['description']?.toString().trim().isNotEmpty == true
          ? parsed['description'].toString().trim()
          : 'Tavsif olinmadi.',
      solution: parsed['solution']?.toString().trim().isNotEmpty == true
          ? parsed['solution'].toString().trim()
          : 'Yechim olinmadi.',
    );
  }

  String _extractOutputText(Map<String, dynamic> data) {
    final outputText = data['output_text'];
    if (outputText is String && outputText.trim().isNotEmpty) {
      return outputText.trim();
    }

    final output = data['output'];
    if (output is List) {
      for (final item in output) {
        if (item is Map<String, dynamic>) {
          final content = item['content'];
          if (content is List) {
            for (final c in content) {
              if (c is Map<String, dynamic>) {
                final text = c['text'];
                if (text is String && text.trim().isNotEmpty) {
                  return text.trim();
                }
              }
            }
          }
        }
      }
    }
    throw Exception('AI javobidan matn ajratib bo`lmadi.');
  }

  Map<String, dynamic> _safeJsonDecode(String text) {
    final cleaned = text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
    try {
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (_) {
      return <String, dynamic>{
        'disease': 'Aniqlanmadi',
        'description': cleaned,
        'solution': 'Mutaxassis bilan maslahat qiling.',
      };
    }
  }

  String _normalizeApiKey(String raw) {
    return raw
        .trim()
        .replaceAll('"', '')
        .replaceAll("'", '')
        .replaceAll(';', '');
  }

  Future<String> _prepareImageDataUri(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      return 'data:image/jpeg;base64,${base64Encode(bytes)}';
    }

    img.Image resized = decoded;
    if (decoded.width > _maxImageSide || decoded.height > _maxImageSide) {
      resized = img.copyResize(
        decoded,
        width: decoded.width >= decoded.height ? _maxImageSide : null,
        height: decoded.height > decoded.width ? _maxImageSide : null,
      );
    }

    final jpgBytes = img.encodeJpg(resized, quality: _jpegQuality);
    return 'data:image/jpeg;base64,${base64Encode(jpgBytes)}';
  }

  Future<http.Response> _postWithRetry({
    required String apiKey,
    required Map<String, dynamic> payload,
  }) async {
    const retryableCodes = <int>{429, 500, 502, 503, 504};
    const delays = <Duration>[
      Duration(milliseconds: 700),
      Duration(milliseconds: 1400),
      Duration(milliseconds: 2400),
    ];

    late http.Response lastResponse;

    for (var i = 0; i < delays.length + 1; i++) {
      lastResponse = await http
          .post(
            Uri.parse(_endpoint),
            headers: <String, String>{
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 75));

      if (!retryableCodes.contains(lastResponse.statusCode)) {
        return lastResponse;
      }

      if (i < delays.length) {
        await Future<void>.delayed(delays[i]);
      }
    }

    return lastResponse;
  }
}
