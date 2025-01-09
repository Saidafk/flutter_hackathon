import 'package:http/http.dart' as http;
import 'dart:convert';


Future<Map<String, dynamic>> fetchData() async {
 Map<String, dynamic> result = {};
 try {
   final response = await http.get(Uri.parse('https://data.opendatasoft.com/api/explore/v2.1/catalog/datasets/regions-et-collectivites-doutre-mer-france@toursmetropole/records?select=results&limit=20'));


   if (response.statusCode == 200) {
     // Les données ont été récupérées avec succès


     Map<String, dynamic> donnees = jsonDecode(response.body);
     result = donnees;


   } else {
     throw Exception('Échec du chargement des données');
   }
 } catch (e) {
   print('Erreur: $e');
 }
 return result ;
}
