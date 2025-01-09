import 'package:flutter/material.dart';
//import 'package:flutter_hackathon/mobile_scanner_overlay.dart';
import 'package:flutter_hackathon/barcode_scanner_simple.dart';
//import 'package:flutter_hackathon/barcode_label.dart';
//import 'package:flutter_hackathon/mobile_scanner_overlay.dart';
import 'package:flutter_hackathon/vcard_details_page.dart';


void main() {
  runApp(
    const MaterialApp(
      title: 'Mobile Scanner Example',
      home: MyHome(),
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
      appBar: AppBar(title: const Text('Mobile Scanner Example')),
      body: Center(
        child: ListView(
          children: [
            _buildItem(
              context,
              'MobileScanner Simple',
              const BarcodeScannerSimple(),
            ),
            
            _buildItem(
              context,
              'Liste de tous les député',
              const VCardDetailsPage(vCardContent: '',),
            ),
          ],
        ),
      ),
    );
  }
}