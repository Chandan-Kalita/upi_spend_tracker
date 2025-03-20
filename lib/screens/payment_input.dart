import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentInput extends StatefulWidget {
  final String upiUrl;
  const PaymentInput({Key? key, required this.upiUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentInput();
}

class _PaymentInput extends State<PaymentInput> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  late Uri uri;
  @override
  void initState() {
    log("message");
    super.initState();
    Uri parsedUri = Uri.parse(widget.upiUrl);
    setState(() {
      uri = parsedUri;
    });
    log(uri.queryParameters.toString());
    amountController.text = uri.queryParameters["am"] ?? '0';
    nameController.text = uri.queryParameters["pn"] ?? "";
  }

  void onClickNext() async {
    final newUri = uri.replace(
        queryParameters: {...uri.queryParameters, "am": amountController.text});
    log(newUri.toString());
    await launchUrl(newUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Input"),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: onClickNext,
        style: ElevatedButton.styleFrom(
            shape: CircleBorder(), padding: EdgeInsets.all(30)),
        child: const Text(
          'Next',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // First input field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              height: 100,
              child: TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Amount',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Second input field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              height: 60,
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Reason',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Name field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              height: 60,
              child: Center(
                child: TextField(
                  controller: nameController,
                  readOnly: true,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
