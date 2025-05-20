
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'saved_qr_state.dart';

class SavedQrCubit extends Cubit<SavedQrState> {
  SavedQrCubit() : super(SavedQrInitial());

  Future<void> loadQrCodes() async {
    emit(SavedQrLoading());
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList('saved_qr_codes') ?? [];
    emit(SavedQrLoaded(codes));
  }

  Future<void> deleteQrCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList('saved_qr_codes') ?? [];
    codes.remove(code);
    await prefs.setStringList('saved_qr_codes', codes);
    emit(SavedQrLoaded(codes));
  }
}
