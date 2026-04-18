import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void openCamera() => emit(HomeOpenCamera());
  void openGallery() => emit(HomeOpenGallery());

  void reset() => emit(HomeInitial());
}
