import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void openCamera() => emit(HomeOpenCamera());
  void openGallery() => emit(HomeOpenGallery());

  void reset() => emit(HomeInitial());
}
