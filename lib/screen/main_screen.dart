import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:mob/services/app_state.dart';
import 'package:mob/services/network_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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

  @override
  Widget build(BuildContext context) {
    final isOffline = Provider.of<AppState>(context).isOffline;

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
                    'Температура з MQTT:',
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
          ),
        ],
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
  late MqttServerClient _client;

  @override
  void initState() {
    super.initState();
    _loadTemperature();
    _connectToMqtt();
  }

  Future<void> _loadTemperature() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    double savedTemp = prefs.getDouble('temperature_$email') ?? 22.0;

    if (savedTemp < 20.0 || savedTemp > 30.0) {
      savedTemp = 22.0;
    }

    if (!mounted) return;
    setState(() {
      _temperature = savedTemp;
    });
  }

  Future<void> _saveTemperature(double value) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    await prefs.setDouble('temperature_$email', value);
  }

  Future<void> _connectToMqtt() async {
    _client = MqttServerClient.withPort('test.mosquitto.org', 'flutter_client', 1883);
    _client.logging(on: false);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = () => debugPrint('MQTT disconnected');
    _client.onConnected = () => debugPrint('MQTT connected');
    _client.onSubscribed = (String topic) => debugPrint('Subscribed to $topic');

    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    try {
      await _client.connect();
      _client.subscribe('sensor/temperature', MqttQos.atLeastOnce);
      _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final double? newTemp = double.tryParse(message);

        if (newTemp != null && newTemp >= 20.0 && newTemp <= 30.0) {
          if (!mounted) return;
          setState(() {
            _temperature = newTemp;
          });
          _saveTemperature(newTemp);
        } else {
          debugPrint('Отримано некоректну температуру: $message');
        }
      });
    } catch (e) {
      debugPrint('MQTT connection failed: $e');
      _client.disconnect();
    }
  }

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
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
