import 'dart:io';

import 'package:agro_scan/features/history/presentation/pages/history_page.dart';
import 'package:agro_scan/features/scan/data/models/scan_history_item.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    super.key,
    required this.imagePath,
    required this.disease,
    required this.description,
    required this.solution,
  });

  /// Yangi tahlildan keyin yoki historydan — fayl bo‘lmasa placeholder chiqadi.
  final String imagePath;
  final String disease;
  final String description;
  final String solution;

  factory ResultPage.fromHistory(ScanHistoryItem item) {
    return ResultPage(
      imagePath: item.imagePath,
      disease: item.disease,
      description: item.description,
      solution: item.solution,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            pinned: true,
            title: const Text('Tahlil natijasi'),
            actions: [
              IconButton(
                tooltip: 'History',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (_) => const HistoryPage()),
                  );
                },
                icon: const Icon(Icons.history_rounded),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeroImage(imagePath: imagePath),
                  const SizedBox(height: 20),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      avatar: Icon(Icons.bug_report_outlined, size: 20, color: cs.primary),
                      label: Text(
                        disease,
                        style: textTheme.titleMedium?.copyWith(
                          fontFamily: 'AlfaSlabOne',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      side: BorderSide(color: cs.outlineVariant),
                      backgroundColor: cs.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    icon: Icons.description_outlined,
                    title: 'Tavsif',
                    body: description,
                    accent: cs.tertiary,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.healing_outlined,
                    title: 'Yechim',
                    body: solution,
                    accent: cs.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final file = File(imagePath);
    final exists = file.existsSync();

    return Material(
      elevation: 2,
      shadowColor: cs.shadow.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: exists
            ? Image.file(
                file,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder(context),
              )
            : _placeholder(context),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hide_image_outlined, size: 56, color: cs.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(
            'Rasm topilmadi',
            style: TextStyle(color: cs.onSurfaceVariant, fontFamily: 'Alice'),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accent, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: 'AlfaSlabOne',
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: cs.onSurface,
                    height: 1.45,
                    fontFamily: 'Alice',
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
