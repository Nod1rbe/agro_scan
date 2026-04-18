import 'package:agro_scan/features/scan/data/models/scan_history_item.dart';
import 'package:agro_scan/features/scan/data/repositories/history_repository.dart';
import 'package:agro_scan/features/scan/data/repositories/scan_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit(
    this._scanRepository, {
    HistoryRepository? historyRepository,
  })  : _historyRepository = historyRepository ?? HistoryRepository(),
        super(ScanInitial());

  final ScanRepository _scanRepository;
  final HistoryRepository _historyRepository;

  Future<void> analyzeImage(String imagePath) async {
    emit(ScanLoading());
    try {
      final result = await _scanRepository.analyzeImage(imagePath);

      final historyItem = ScanHistoryItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        imagePath: imagePath,
        disease: result.disease,
        description: result.description,
        solution: result.solution,
        createdAt: DateTime.now(),
      );
      await _historyRepository.addHistory(historyItem);

      emit(
        ScanSuccess(
          disease: result.disease,
          description: result.description,
          solution: result.solution,
        ),
      );
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(ScanFailure(message));
    }
  }
}
