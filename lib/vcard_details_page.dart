import 'package:flutter/material.dart';



class VCardDetailsPage extends StatelessWidget {
  final String vCardContent;

  const VCardDetailsPage({super.key, required this.vCardContent});

  /// Analyse le contenu de la vCard en paires clé-valeur.
  Map<String, String> _parseVCard(String vCard) {
    final Map<String, String> details = {};
    final lines = vCard.split('\n'); // Découper en lignes
    for (final line in lines) {
      final parts = line.split(':'); // Diviser par les deux points
      if (parts.length == 2) {
        details[parts[0].trim()] = parts[1].trim();
      }
    }
    return details;
  }

  @override
  Widget build(BuildContext context) {
    final details = _parseVCard(vCardContent); // Extraire les informations

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la vCard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: details.length,
          itemBuilder: (context, index) {
            final entry = details.entries.elementAt(index);
            return Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(entry.value),
              ),
            );
          },
        ),
      ),
    );
  }
}
