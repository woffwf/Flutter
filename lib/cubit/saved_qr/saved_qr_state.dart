
part of 'saved_qr_cubit.dart';

abstract class SavedQrState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavedQrInitial extends SavedQrState {}

class SavedQrLoading extends SavedQrState {}

class SavedQrLoaded extends SavedQrState {
  final List<String> codes;

  SavedQrLoaded(this.codes);

  @override
  List<Object?> get props => [codes];
}
