import 'package:flutter/material.dart';
import 'package:flutter_hackathon/barcode_scanner_simple.dart';
import 'package:flutter_hackathon/mobile_scanner_overlay.dart';


void main() {
  runApp(
    const MaterialApp(
      title: 'Mobile Scanner test',
      home: MyHome(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  Widget _buildItem(BuildContext context, String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => page,
              ),
            );
          },
          child: Text(label),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner test')),
      body: Center(
        child: ListView(
          children: [
            _buildItem(
              context,
              'MobileScanner ',
              const BarcodeScannerSimple(),
            ),
          ],
        ),
      ),
    );
  }
}