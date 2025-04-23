import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mob/services/local_auth_repository.dart';
import 'package:mob/screen/login_screen.dart';
import 'package:mob/services/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editHeatingTemperature(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    double temp = appState.heatingTemp;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редагувати температуру опалення'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${temp.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 20)),
              Slider(
                value: temp,
                min: 20,
                max: 30,
                divisions: 20,
                label: '${temp.toStringAsFixed(1)}°C',
                onChanged: (value) {
                  temp = value;
                  (context as Element).markNeedsBuild();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                appState.setHeatingTemp(temp);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade200,
                foregroundColor: Colors.white,
              ),
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = LocalAuthRepository();
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        backgroundColor: Colors.pink.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authRepo.logoutUser();
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.pink.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<String?>(
          future: authRepo.getCurrentUserEmail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final email = snapshot.data ?? 'Невідомо';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Розумне опалення',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Email'),
                      subtitle: Text(email),
                      leading: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Температура опалення'),
                      subtitle: Text('${appState.heatingTemp.toStringAsFixed(1)}°C'),
                      leading: const Icon(Icons.thermostat),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editHeatingTemperature(context),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}