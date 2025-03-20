import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:upi_spend_tracker/screens/payment_input.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with WidgetsBindingObserver {
  final MobileScannerController cameraController = MobileScannerController();
  String? qrCode;
  bool hasScanned = false;
  StreamSubscription<Object?>? _subscription;
  bool hasQrError = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    log("message");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!cameraController.value.hasCameraPermission) {
      return;
    }
    log(state.toString());
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        unawaited(cameraController.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(cameraController.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && !hasScanned) {
                  final String code = barcodes.first.rawValue ?? "Unknown";
                  log("detected: " + code);

                  try {
                    Uri uri = Uri.parse(code);
                    if (uri.scheme != "upi" ||
                        uri.host != "pay" ||
                        uri.hasQuery == false) {
                      throw FormatException();
                    }

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PaymentInput(upiUrl: code)));
                    log(uri.scheme);
                    log(uri.host);
                  } catch (e) {
                    if (!hasQrError) {
                      log(e.toString());
                      setState(() {
                        hasQrError = true;
                      });
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Invalid Qr"),
                              ));
                    }
                  }

                  setState(() {
                    qrCode = code;
                    hasScanned = true;
                  });

                  // Prevent multiple scans
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() {
                        hasScanned = false;
                      });
                    }
                  });
                }
              },
              errorBuilder: (context, error, child) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 64,
                      ),
                      Text(
                        'Camera error: ${error.toString()}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
