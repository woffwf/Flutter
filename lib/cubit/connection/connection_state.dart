
part of 'connection_cubit.dart';

abstract class ConnectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectionUnknown extends ConnectionState {}

class ConnectionOnline extends ConnectionState {}

class ConnectionOffline extends ConnectionState {}
