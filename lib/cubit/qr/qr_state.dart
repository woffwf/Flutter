
part of 'qr_cubit.dart';

abstract class QrState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrInitial extends QrState {}

class QrScanned extends QrState {
  final String data;

  QrScanned({required this.data});

  @override
  List<Object?> get props => [data];
}
