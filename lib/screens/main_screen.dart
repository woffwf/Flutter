import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Головна сторінка'),
        backgroundColor: Colors.pink.shade200,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Перехід на сторінку профілю
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app), 
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
            SizedBox(height: 20),
            Text(
              'Налаштуйте температуру кімнати:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.pink.shade700,
              ),
            ),
            SizedBox(height: 20),
            TemperatureControl(),
          ],
        ),
      ),
    );
  }
}

class TemperatureControl extends StatefulWidget {
  @override
  _TemperatureControlState createState() => _TemperatureControlState();
}

class _TemperatureControlState extends State<TemperatureControl> {
  double _temperature = 22.0;

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
