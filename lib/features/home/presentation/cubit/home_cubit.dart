import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void openCamera() => emit(HomeNavigateToScan(HomeAction.camera));
  void openGallery() => emit(HomeNavigateToScan(HomeAction.gallery));

  void reset() => emit(HomeInitial());
}
