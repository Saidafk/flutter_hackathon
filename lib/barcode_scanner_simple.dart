import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_hackathon/scanner_error_widget.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  _BarcodeScannerSimpleState createState() => _BarcodeScannerSimpleState();
}

// Fonction pour vérifier si le code scanné est une vCard
bool _isVCard(String? code) {
  return code != null && code.startsWith('BEGIN:VCARD');
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;  // Pour stocker le code scanné
  String scanResult = '';  // Résultat du scan
  bool _hasScanned = false;  // Flag pour éviter un double scan

  // Fonction pour afficher le résultat du scan
  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text('Scan something!', style: TextStyle(color: Colors.white));
    }
    return Text(value.displayValue ?? 'No display value.', style: const TextStyle(color: Colors.white));
  }

  // Cette fonction est appelée à chaque scan détecté
  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.isNotEmpty ? barcodes.barcodes.first : null;
      });
    }
  }

  // Affiche un dialogue avec le résultat du scan
  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan Result'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _hasScanned = false;  // Réinitialisation de l'état après scan
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Affiche une erreur si ce n'est pas une vCard
  void _showResultDialogError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            onDetect: (BarcodeCapture capture) {
              if (_hasScanned) return;  // Evite un double scan
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (_isVCard(code)) {
                  setState(() {
                    scanResult = code ?? "Aucune valeur";
                    _hasScanned = true;  // Marque que le scan est terminé
                  });
                  _showResultDialog("vCard scannée : $scanResult");  // Affiche le message de succès
                } else {
                  setState(() {
                    _hasScanned = true;
                  });
                  _showResultDialogError("Erreur : Ce n'est pas une vCard.");  // Affiche un message d'erreur
                }
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
