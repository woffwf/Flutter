import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth/auth_cubit.dart';
import 'package:mob/services/local_auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authRepo = LocalAuthRepository();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final existingUser = await _authRepo.getUserPassword(_emailController.text);

      if (!mounted) return;

      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Користувач з таким email вже існує')),
        );
      } else {
        await _authRepo.registerUser(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        context.read<AuthCubit>().loadUserSettings(_emailController.text);

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Паролі не співпадають';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Реєстрація'),
          backgroundColor: Colors.pink.shade200,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade50, Colors.pink.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration('Email'),
                  validator: (value) => value != null && value.contains('@gmail.com')
                      ? null
                      : 'Введіть пошту @gmail.com',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: _inputDecoration('Пароль'),
                  obscureText: true,
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : 'Пароль має містити щонайменше 6 символів',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: _inputDecoration('Повторіть пароль'),
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: _buttonStyle(),
                  onPressed: _register,
                  child: const Text('Зареєструватися'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Вже маєте акаунт?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Увійти',
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
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.pink),
    filled: true,
    fillColor: Colors.white.withOpacity(0.8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
  );

  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    backgroundColor: Colors.pink.shade300,
    elevation: 5,
  );
}
