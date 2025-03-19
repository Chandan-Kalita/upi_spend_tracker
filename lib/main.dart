import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:upi_spend_tracker/screens/payment_input.dart';
import 'package:upi_spend_tracker/screens/scanner.dart';

void main() {
  // Make sure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const QRScannerPage()),
            );
          },
          child: const Text('Scan QR Code'),
        ),
      ),
    );
  }
}
