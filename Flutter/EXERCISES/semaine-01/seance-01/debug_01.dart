// Défi de débogage
//
// Ce programme ne compile pas. Il contient plusieurs erreurs.
//
// Ta mission :
//   1. Exécute-le et lis les messages d'erreur EN ENTIER.
//   2. Corrige les erreurs UNE PAR UNE, en ré-exécutant après chaque correction.
//   3. Pour chaque erreur, ajoute un commentaire au-dessus de la ligne :
//        // Erreur : <ce qui n'allait pas> — Correction : <ce que tu as fait>
//   4. Une fois que ça compile, vérifie que la SORTIE est correcte :
//      il reste un bug qui ne provoque aucune erreur de compilation.
//
// Sortie attendue une fois corrigé :
//   Client : Hery
//   Le nom compte 4 lettres
//   Commande de 2 articles à 12.5 Ar
//   Total : 25.0 Ar
//   Statut : L'envoi est prêt

void main() {
  final client = 'Hery'
  int quantite = 2;
  int prixUnitaire = 12.5;
  const dateCommande = DateTime.now();

  print('Client : $client');
  print('Le nom compte $client.length lettres');
  print('Commande de ' + quantite + ' articles à $prixUnitaire Ar');

  var total = quantite * prixUnitaire;
  print('Total : $total Ar');

  client = 'Hery R.';
  print('Statut : 'L'envoi est prêt');
}
