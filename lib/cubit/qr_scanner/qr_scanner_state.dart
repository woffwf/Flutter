
part of 'qr_scanner_cubit.dart';

abstract class QrScannerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrScannerInitial extends QrScannerState {}

class QrScannerSuccess extends QrScannerState {
  final String result;

  QrScannerSuccess(this.result);

  @override
  List<Object?> get props => [result];
}
