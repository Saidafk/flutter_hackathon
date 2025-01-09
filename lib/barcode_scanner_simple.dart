import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_hackathon/scanner_error_widget.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

bool _isVCard(String? code) {
  // Vérifie si le code commence par BEGIN:VCARD
  return code != null && code.startsWith('BEGIN:VCARD');
}




class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;
  String scanResult = '';
  String error ='';
  bool _hasScanned = false;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

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
                setState(() {
                  _hasScanned = false;  // Réinitialiser l'état pour relancer le scan
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

   void _showResultDialogError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan Error'),  // Titre de la boîte de dialogue
          content: Text(message),  // Affichage du message d'erreur
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _hasScanned = false;  // Réinitialiser l'état pour relancer le scan
                });
                Navigator.of(context).pop();  // Fermer la boîte de dialogue
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(MobileScannerException error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScannerErrorWidget(error: error);  // Pass the exception
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (BarcodeCapture capture) {
              if (_hasScanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (_isVCard(code)) {
                  setState(() {
                    scanResult = code ?? "Aucune valeur";
                    _hasScanned = true;
                  });
                  _showResultDialog("vCard scannée : $scanResult");
                  
                } else {
                  setState(() {
                      _hasScanned = true; // Arrêter le scan après la première détection
                    });
                  _showResultDialogError("Erreur : Ce n'est pas une vCard.");
                  
                }
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
                  

