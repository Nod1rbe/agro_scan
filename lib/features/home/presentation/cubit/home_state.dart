part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeNavigateToScan extends HomeState {
  final HomeAction action;
  HomeNavigateToScan(this.action);
}

enum HomeAction { camera, gallery }
