part of 'scan_cubit.dart';

@immutable
sealed class ScanState {}

final class ScanInitial extends ScanState {}

final class ScanLoading extends ScanState {}

final class ScanSuccess extends ScanState {
  ScanSuccess({
    required this.disease,
    required this.description,
    required this.solution,
  });

  final String disease;
  final String description;
  final String solution;
}

final class ScanFailure extends ScanState {
  ScanFailure(this.message);

  final String message;
}
