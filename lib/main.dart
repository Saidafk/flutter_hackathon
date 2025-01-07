import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );*/
    return MaterialApp(
      title: 'QR Code Scanner App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'QR Scanner Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRCodeScannerPage()),
            );
          },
          child: const Text('Scanner un QR Code'),
        ),
      ),
    );
  }
}

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  State<QRCodeScannerPage> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      showDialog(

        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('QR Code Scanné'),
          content: Text('Les données du QR Code : ${scanData.code}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.resumeCamera();
              },
              child: const Text('Fermer'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }
}