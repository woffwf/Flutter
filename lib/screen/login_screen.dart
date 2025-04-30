import 'package:flutter/material.dart';
import 'package:mob/screen/register_screen.dart';
import 'package:mob/services/local_auth_repository.dart';
import 'package:mob/services/app_state.dart';
import 'package:mob/services/network_service.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepo = LocalAuthRepository();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialConnection();
      _listenToConnectionChanges();
    });
  }

  void _checkInitialConnection() async {
    final connected = await NetworkService.hasConnection();
    Provider.of<AppState>(context, listen: false).setOffline(!connected);
  }

  void _listenToConnectionChanges() {
    NetworkService.onConnectionChange.listen((result) {
      final isOffline = result == ConnectivityResult.none;
      Provider.of<AppState>(context, listen: false).setOffline(isOffline);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final connected = await NetworkService.hasConnection();
    if (!connected) {
      setState(() {
        _errorMessage = 'Немає підключення до Інтернету';
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      final success = await _authRepo.loginUser(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        await Provider.of<AppState>(context, listen: false)
            .loadUserSettings(_emailController.text);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = 'Невірний email або пароль';
        });
      }
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = Provider.of<AppState>(context).isOffline;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Вхід'),
          backgroundColor: Colors.pink.shade200,
        ),
        body: Column(
          children: [
            if (isOffline)
              Container(
                width: double.infinity,
                color: Colors.red.shade100,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Center(
                  child: Text(
                    '⚠️ Немає підключення до Інтернету',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade50, Colors.pink.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration('Електронна пошта'),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: _inputDecoration('Пароль'),
                        validator: _validatePassword,
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: _buttonStyle(),
                        onPressed: _login,
                        child: const Text('Увійти'),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Немає акаунту?'),
                          TextButton(
                            onPressed: _goToRegister,
                            child: const Text(
                              'Зареєструватися',
                              style: TextStyle(color: Colors.pink),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.pink),
    filled: true,
    fillColor: Colors.white.withOpacity(0.8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    backgroundColor: Colors.pink.shade300,
    elevation: 5,
  );

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Будь ласка, введіть емейл';
    if (!value.contains('@gmail.com')) return 'Пошта повинна бути @gmail.com';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Введіть пароль';
    if (value.length < 6) return 'Пароль має бути щонайменше 6 символів';
    return null;
  }
}
