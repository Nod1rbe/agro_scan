import 'package:agro_scan/features/scan/data/models/scan_history_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  static const String _historyKey = 'scan_history_v1';

  Future<List<ScanHistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? <String>[];
    return raw.map(ScanHistoryItem.fromJson).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addHistory(ScanHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final old = prefs.getStringList(_historyKey) ?? <String>[];
    final updated = <String>[item.toJson(), ...old];
    await prefs.setStringList(_historyKey, updated);
  }

  Future<void> deleteById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final old = prefs.getStringList(_historyKey) ?? <String>[];
    final updated = old.where((raw) {
      final item = ScanHistoryItem.fromJson(raw);
      return item.id != id;
    }).toList();
    await prefs.setStringList(_historyKey, updated);
  }
}
