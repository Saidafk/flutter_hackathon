import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_hackathon/scanner_error_widget.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

bool _isVCard(String? code) {
  return code != null && code.startsWith('BEGIN:VCARD');
}

// Extrait le prénom et nom de la vCard
Map<String, String>? extractNameFromVCard(String vcard) {
  String? firstName;
  String? lastName;
  
  final lines = vcard.split('\n');
  for (var line in lines) {
    if (line.startsWith('N:')) {
      final parts = line.substring(2).split(';');
      if (parts.length >= 2) {
        lastName = parts[0].trim();
        firstName = parts[1].trim();
        return {
          'firstName': firstName,
          'lastName': lastName,
        };
      }
    }
  }
  return null;
}

Future<List<List<dynamic>>> loadCSV() async {
  try {
    final data = await rootBundle.loadString('assets/depute.csv');
    return const CsvToListConverter().convert(data);
  } catch (e) {
    debugPrint('Erreur lors de la lecture du CSV: $e');
    return [];
  }
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;
  String scanResult = '';
  bool _hasScanned = false;

  Widget _buildBarcode(Barcode? value) {
    return Text(
      value?.displayValue ?? 'Scan something!',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _showResultDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _hasScanned = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _verifyVCard(String vcard) async {
    final nameInfo = extractNameFromVCard(vcard);
    if (nameInfo == null) {
      _showResultDialog('Erreur', 'Impossible d\'extraire le nom de la vCard');
      return;
    }

    final csvData = await loadCSV();
    bool found = false;

    for (var row in csvData) {
      if (row.length >= 3 && 
          row[1].trim() == nameInfo['firstName'] && 
          row[2].trim() == nameInfo['lastName']) {
        found = true;
        _showResultDialog(
          'Succès',
          'Correspondance trouvée pour ${nameInfo['firstName']} ${nameInfo['lastName']}'
        );
        break;
      }
    }

    if (!found) {
      _showResultDialog(
        'Erreur',
        'Aucune correspondance trouvée pour ${nameInfo['firstName']} ${nameInfo['lastName']}'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (BarcodeCapture capture) async {
              if (_hasScanned) return;
              
              final barcode = capture.barcodes.firstOrNull;
              final code = barcode?.rawValue;
              
              if (code == null) {
                _showResultDialog('Erreur', 'Code scanné vide');
                return;
              }

              setState(() {
                _hasScanned = true;
                _barcode = barcode;
              });

              if (_isVCard(code)) {
                await _verifyVCard(code);
              } else {
                _showResultDialog('Erreur', 'Le code scanné n\'est pas une vCard');
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: _buildBarcode(_barcode),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}