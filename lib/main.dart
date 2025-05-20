
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen/main_screen.dart';
import 'screen/profile_screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/qr_scanner_screen.dart';
import 'screen/saved_qr_screen.dart';

import 'cubit/auth/auth_cubit.dart';
import 'cubit/qr/qr_cubit.dart';
import 'cubit/connection/connection_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => QrCubit()),
        BlocProvider(create: (_) => ConnectionCubit()),
      ],
      child: MaterialApp(
        title: 'Cubit Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainScreen(),
        routes: {
          '/home': (_) => const MainScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/scan': (_) => const QrScannerScreen(),
          '/saved': (_) => const SavedQrScreen(),
        },
      ),
    );
  }
}
