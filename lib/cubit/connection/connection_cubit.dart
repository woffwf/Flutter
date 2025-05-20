
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionState> {
  ConnectionCubit() : super(ConnectionUnknown());

  void setConnected() => emit(ConnectionOnline());

  void setDisconnected() => emit(ConnectionOffline());

  bool get isOffline => state is ConnectionOffline;
}
