import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mob/services/local_auth_repository.dart';
import 'package:mob/screen/login_screen.dart';
import 'package:mob/screen/main_screen.dart';
import 'package:mob/services/app_state.dart';
import 'package:mob/services/network_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    if (!mounted) return;
    Provider.of<AppState>(context, listen: false).setOffline(!connected);
  }

  void _listenToConnectionChanges() {
    NetworkService.onConnectionChange.listen((result) {
      final isOffline = result == ConnectivityResult.none;
      if (!mounted) return;
      Provider.of<AppState>(context, listen: false).setOffline(isOffline);
    });
  }

  Future<void> _editHeatingTemperature(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    double temp = appState.heatingTemp;

    await showDialog(
      context: context,
      builder: (dialogContext) {
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
                  (dialogContext as Element).markNeedsBuild();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                appState.setHeatingTemp(temp);
                Navigator.pop(dialogContext);
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

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Підтвердження виходу'),
        content: const Text('Чи дійсно ви хочете покинути акаунт?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade200,
              foregroundColor: Colors.white,
            ),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final authRepo = LocalAuthRepository();
      await authRepo.logoutUser();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      if (!mounted) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = LocalAuthRepository();
    final appState = Provider.of<AppState>(context);
    final isOffline = appState.isOffline;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        backgroundColor: Colors.pink.shade200,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          )
        ],
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
          ),
        ],
      ),
    );
  }
}
