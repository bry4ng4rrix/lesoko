// Séance 1 — exemple complet : variables, types et chaînes.
// Exécution : dart run LESSONS/semaine-01/exemples/s01_bases.dart

/// Point d'entrée : Dart commence toujours l'exécution ici.
void main() {
  // --- 1. Types explicites ---------------------------------------------
  String nomApp = 'StockFacile'; // texte
  int nombreProduits = 42; // entier
  double prixMoyen = 12.5; // nombre à virgule
  bool enLigne = true; // vrai / faux

  // --- 2. Inférence avec var -------------------------------------------
  var ville = 'Antananarivo'; // Dart déduit : String
  ville = 'Toamasina'; // OK : même type
  // ville = 3;           // ERREUR : ville est un String pour toujours

  // --- 3. final et const -----------------------------------------------
  final demarrage = DateTime.now(); // connu à l'exécution, puis figé
  const tauxTva = 0.20; // connu à la compilation, figé
  // demarrage = DateTime.now(); // ERREUR : final ne se réaffecte pas

  // --- 4. Interpolation ------------------------------------------------
  print('Application : $nomApp');
  print('Produits : $nombreProduits, en ligne : $enLigne');

  // ${...} obligatoire dès qu'il y a une expression (calcul, appel, propriété)
  print('Prix TTC moyen : ${prixMoyen * (1 + tauxTva)}');
  print('Le nom contient ${nomApp.length} caractères');

  // --- 5. Quelques méthodes de String ----------------------------------
  const brut = '  bonjour flutter  ';
  print('[${brut.trim()}]'); // [bonjour flutter]
  print(brut.trim().toUpperCase()); // BONJOUR FLUTTER
  print(brut.contains('flutter')); // true

  // --- 6. Chaîne sur plusieurs lignes ----------------------------------
  final resume = '''
--- Résumé ---
Ville      : $ville
Démarrage  : ${demarrage.hour}h${demarrage.minute}
''';
  print(resume);

  // --- 7. Connaître le type d'une valeur à l'exécution -----------------
  print(prixMoyen.runtimeType); // double
  print((nombreProduits / 2).runtimeType); // double : "/" renvoie toujours un double
}
