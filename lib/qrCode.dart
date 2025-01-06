import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerWidget extends StatefulWidget {
  @override
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String _qrCode = 'Scan a QR code';
  QRViewController? controller;
  Map<String, String> contactInfo = {};

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Informations scannées:', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ...contactInfo.entries.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('${entry.key}: ${entry.value}'),
                  )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        setState(() {
          _qrCode = scanData.code!;
        });
        handleQRCode(_qrCode);
      }
    });
  }

  void handleQRCode(String code) {
    try {
      if (code.toUpperCase().contains('BEGIN:VCARD')) {
        Map<String, String> parsedData = parseVCard(code);
        setState(() {
          contactInfo = parsedData;
        });
      }
    } catch (e) {
      print("Erreur lors du traitement de la VCard: $e");
    }
  }

  Map<String, String> parseVCard(String vcard) {
    Map<String, String> result = {};
    List<String> lines = vcard.split('\n');
    String currentKey = '';
    String currentValue = '';

    for (String line in lines) {
      line = line.trim();
      
      // Ignorer les lignes BEGIN:VCARD et END:VCARD
      if (line.toUpperCase() == 'BEGIN:VCARD' || line.toUpperCase() == 'END:VCARD') {
        continue;
      }

      // Traiter les lignes avec le format KEY:VALUE
      if (line.contains(':')) {
        List<String> parts = line.split(':');
        String key = parts[0].split(';')[0]; // Prendre la partie avant le premier point-virgule
        String value = parts.sublist(1).join(':').trim();

        // Convertir les clés en noms plus lisibles
        switch (key.toUpperCase()) {
          case 'FN':
            result['Nom complet'] = value;
            break;
          case 'N':
            List<String> nameParts = value.split(';');
            if (nameParts.length >= 2) {
              result['Nom'] = nameParts[0];
              result['Prénom'] = nameParts[1];
            }
            break;
          case 'TEL':
            result['Téléphone'] = value;
            break;
          case 'EMAIL':
            result['Email'] = value;
            break;
          case 'ORG':
            result['Organisation'] = value;
            break;
          case 'TITLE':
            result['Titre'] = value;
            break;
          case 'ADR':
            result['Adresse'] = value.replaceAll(';', ' ');
            break;
          case 'URL':
            result['Site web'] = value;
            break;
        }
      }
    }
    return result;
  }
}