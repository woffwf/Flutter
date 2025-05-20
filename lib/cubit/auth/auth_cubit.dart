
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  double heatingTemp = 22.5;

  void login(String username, String password) {
    emit(AuthLoading());
    Future.delayed(Duration(seconds: 1), () {
      if (username == 'admin' && password == 'admin') {
        emit(AuthSuccess(user: username));
      } else {
        emit(AuthFailure(message: 'Невірний логін або пароль'));
      }
    });
  }

  void logout() {
    emit(AuthInitial());
  }

  void loadUserSettings(String email) {
    print("Завантаження налаштувань для $email");
  }

  void setHeatingTemp(double value) {
    heatingTemp = value;
  }
}
