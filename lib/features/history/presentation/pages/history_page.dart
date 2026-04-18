import 'dart:io';

import 'package:agro_scan/core/ui/top_alert.dart';
import 'package:agro_scan/features/scan/data/models/scan_history_item.dart';
import 'package:agro_scan/features/scan/data/repositories/history_repository.dart';
import 'package:agro_scan/features/scan/presentation/pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, this.embedded = false});

  /// `true` bo‘lsa, alohida [AppBar] chiqmaydi (masalan, bosh sahifa pastki tabida).
  final bool embedded;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryRepository _historyRepository = HistoryRepository();
  List<ScanHistoryItem> _items = <ScanHistoryItem>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _historyRepository.getHistory();
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _deleteItem(ScanHistoryItem item) async {
    await _historyRepository.deleteById(item.id);

    final imageFile = File(item.imagePath);
    if (await imageFile.exists()) {
      await imageFile.delete();
    }

    if (!mounted) return;
    setState(() {
      _items.removeWhere((e) => e.id == item.id);
    });

    showTopAlert(context, message: 'History dan o`chirildi', isError: false);
  }

  void _openResult(ScanHistoryItem item) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => ResultPage.fromHistory(item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final listPadding = widget.embedded
        ? const EdgeInsets.fromLTRB(16, 12, 16, 8)
        : const EdgeInsets.fromLTRB(16, 8, 16, 24);

    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _items.isEmpty
            ? Center(
                child: Text(
                  'Saqlangan natijalar yo`q',
                  style: TextStyle(color: cs.onSurfaceVariant, fontFamily: 'Alice'),
                ),
              )
            : ListView.builder(
                padding: listPadding,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final imageFile = File(item.imagePath);
                  final hasImage = imageFile.existsSync();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Slidable(
                      key: ValueKey<String>(item.id),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _deleteItem(item),
                            backgroundColor: cs.error,
                            foregroundColor: cs.onError,
                            icon: Icons.delete_outline_rounded,
                            label: 'O`chirish',
                          ),
                        ],
                      ),
                      child: Material(
                        color: cs.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => _openResult(item),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: hasImage
                                      ? Image.file(
                                          imageFile,
                                          width: 72,
                                          height: 72,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 72,
                                          height: 72,
                                          color: cs.surfaceContainerHighest,
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            color: cs.onSurfaceVariant,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.disease,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontFamily: 'AlfaSlabOne',
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: cs.onSurfaceVariant,
                                              fontFamily: 'Alice',
                                              height: 1.3,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${item.createdAt.year}-${item.createdAt.month.toString().padLeft(2, '0')}-${item.createdAt.day.toString().padLeft(2, '0')}',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: cs.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded, color: cs.outline),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );

    if (widget.embedded) {
      return ColoredBox(color: cs.surface, child: body);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: body,
    );
  }
}
