part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeOpenCamera extends HomeState {}

final class HomeOpenGallery extends HomeState {}
