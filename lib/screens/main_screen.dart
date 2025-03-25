import 'package:flutter/material.dart';

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
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 224, 180, 194),
              Color.fromARGB(255, 222, 172, 190),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: MainContent(),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        Text(
          'Розумне опалення',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 205, 34, 102),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Налаштуйте температуру кімнати:',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 202, 31, 100),
          ),
        ),
        SizedBox(height: 20),
        TemperatureControl(), 
      ],
    );
  }
}

class TemperatureControl extends StatefulWidget {
  const TemperatureControl({super.key});

  @override
  TemperatureControlState createState() => TemperatureControlState();
}

class TemperatureControlState extends State<TemperatureControl> {
  double _temperature = 22.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${_temperature.toStringAsFixed(1)}°C',
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD6236A),
          ),
        ),
        Slider(
          value: _temperature,
          min: 15.0,
          max: 30.0,
          divisions: 30,
          onChanged: (double newValue) {
            setState(() {
              _temperature = newValue;
            });
          },
        ),
      ],
    );
  }
}
