
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  QrCubit() : super(QrInitial());

  void scanQr(String data) {
    emit(QrScanned(data: data));
  }

  void clear() {
    emit(QrInitial());
  }
}
