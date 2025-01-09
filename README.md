Projet Flutter Hackathon

Ce projet est un code source Flutter qui permet de scanner des codes-barres et des QR codes, tout en vérifiant s'il s'agit d'un code de type vCard.

Choix techniques et d'implémentation
Plateforme choisie : Flutter

Bibliothèques utilisées
mobile_scanner : Utilisé pour la gestion du scan de codes-barres et QR codes. Cette bibliothèque offre une interface simple et rapide pour intégrer un scanner dans une application Flutter.

Le projet contient principalement un fichier Dart pour l'interface utilisateur (main.dart) et un fichier pour le scan des qr Code (barcode_scanner_simple.dart) une fonctionnalité centrale qui consiste à scanner les codes et afficher les résultats en fonction de leur type (on affiche quand c'est Vcard sinon message d'erreur).

Gestion des erreurs
Les erreurs sont gérées avec des dialogues sous forme de pop qui permettent à l'utilisateur de savoir si un code scanné est valide ou non.

Installation du projet
Clonez le dépôt : Ouvrez un terminal et clonez le dépôt à l'aide de la commande suivante :
git clone https://github.com/Saidafk/flutter_hackathon.git

git clone https://github.com/votre-utilisateur/votre-depot.git
Installez Flutter : Assurez-vous que Flutter est installé sur votre machine. Si ce n'est pas déjà fait, suivez ces instructions pour l'installation : Installation de Flutter

Installations des dépendances : Allez dans le répertoire du projet cloné et exécutez la commande suivante pour installer les dépendances :

Assurez-vous que Flutter est installé sur votre machine ainsi que les dépendances. 

Installation d'Android Studio (ou autre IDE) : Si vous utilisez Android Studio, assurez-vous d'avoir installé Flutter et Dart dans les paramètres du plugin.

Vous pouvez maintenant lancer le projet avec la commande : flutter run

Remarques

Ce projet utilise Flutter comme technologie principale pour développer l'application mobile.
La logique de scanner est entièrement implémentée via la bibliothèque mobile_scanner.
Aucune base de données externe n'est nécessaire pour cette version du projet

