import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головна сторінка'),
        backgroundColor: Colors.pink.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Text(
              'Налаштуйте температуру кімнати:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.pink.shade700,
              ),
            ),
            const SizedBox(height: 20),
            const TemperatureControl(),
          ],
        ),
      ),
    );
  }
}

class TemperatureControl extends StatefulWidget {
  const TemperatureControl({super.key});

  @override
  State<TemperatureControl> createState() => _TemperatureControlState();
}

class _TemperatureControlState extends State<TemperatureControl> {
  double _temperature = 22.0;

  @override
  void initState() {
    super.initState();
    _loadTemperature();
  }

  Future<void> _loadTemperature() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    setState(() {
      _temperature = prefs.getDouble('temperature_$email') ?? 22.0;
    });
  }

  Future<void> _saveTemperature(double value) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    await prefs.setDouble('temperature_$email', value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${_temperature.toStringAsFixed(1)}°C',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade700,
          ),
        ),
        Slider(
          value: _temperature,
          min: 20.0,
          max: 30.0,
          divisions: 30,
          onChanged: (double newValue) {
            setState(() {
              _temperature = newValue;
            });
            _saveTemperature(newValue);
          },
        ),
      ],
    );
  }
}
