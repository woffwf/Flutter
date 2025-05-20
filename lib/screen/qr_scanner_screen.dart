
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mob/cubit/qr_scanner/qr_scanner_cubit.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QrScannerCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Сканування QR-коду'),
          backgroundColor: Colors.pink.shade200,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {

              final scannedValue = 'QRCode_123';
              context.read<QrScannerCubit>().setResult(scannedValue);
              Navigator.pop(context, scannedValue);
            },
            child: const Text('Сканувати QR-код (псевдо)'),
          ),
        ),
      ),
    );
  }
}
