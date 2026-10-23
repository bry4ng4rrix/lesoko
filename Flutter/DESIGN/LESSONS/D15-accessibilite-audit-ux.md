# D15 — Accessibilité, audit UX et tests utilisateurs

Durée : 3 h. Prérequis : D01 à D14.
Exercices : [`EXERCISES/D15.md`](../EXERCISES/D15.md)

## 1. Objectifs pédagogiques

- Expliquer pourquoi l'accessibilité concerne tout le monde.
- Connaître les principes WCAG (POUR) et les critères essentiels sur mobile.
- Utiliser `Semantics`, les libellés et TalkBack pour tester une app Flutter.
- Écrire des tests automatisés d'accessibilité.
- Mener un audit UX (évaluation heuristique) et un test utilisateur simple.

## 2. Pourquoi l'accessibilité ?

Environ **une personne sur six** dans le monde vit avec un handicap important
(OMS). Mais l'accessibilité aide aussi tout le monde, dans des situations
**temporaires** ou **contextuelles** :

| Permanent | Temporaire | Situationnel |
|---|---|---|
| Malvoyance | Œil dilaté chez l'ophtalmo | Plein soleil sur l'écran |
| Un seul bras | Bras plâtré | Un bébé dans les bras |
| Surdité | Otite | Marché bruyant |
| Troubles cognitifs | Fatigue, médicaments | Distraction, interruptions |

Une app accessible est une app **plus facile pour tous**. C'est aussi une
obligation légale dans de nombreux pays (European Accessibility Act depuis juin 2025).

## 3. WCAG : les 4 principes (POUR)

| Principe | Question | Exemples mobile |
|---|---|---|
| **Perceptible** | Peut-on percevoir l'information ? | Contraste, texte alternatif des images, pas d'info par la couleur seule, texte agrandi |
| **Utilisable** (Operable) | Peut-on utiliser les commandes ? | Cibles de 48 dp, pas de geste complexe obligatoire, temps suffisant |
| **Compréhensible** | Comprend-on le contenu et le fonctionnement ? | Libellés clairs, erreurs expliquées, comportement prévisible |
| **Robuste** | Fonctionne-t-il avec les technologies d'assistance ? | Sémantique correcte pour TalkBack / VoiceOver |

Niveaux : A (minimum), **AA (la cible habituelle)**, AAA (renforcé).

## 4. La checklist essentielle (mobile)

| # | Critère | Comment vérifier |
|---|---|---|
| 1 | Contraste du texte ≥ 4,5:1 (≥ 3:1 en grand) | Outil de contraste, `textContrastGuideline` |
| 2 | Contraste des composants ≥ 3:1 | Bordures de champs, icônes seules |
| 3 | Cibles tactiles ≥ 48 × 48 dp | `androidTapTargetGuideline` |
| 4 | Chaque élément interactif a un **libellé** | TalkBack ; `labeledTapTargetGuideline` |
| 5 | Images informatives décrites ; décoratives ignorées | `semanticLabel`, `excludeFromSemantics` |
| 6 | Information jamais portée par la couleur seule | Revue visuelle en niveaux de gris |
| 7 | Texte agrandi à 200 % sans perte | Réglage système |
| 8 | Ordre de lecture logique | TalkBack, balayage |
| 9 | États annoncés (sélectionné, coché, désactivé, erreur) | TalkBack |
| 10 | Pas de geste complexe **obligatoire** (alternative visible au glissement) | Revue |
| 11 | Animations réductibles | `disableAnimations` |
| 12 | Erreurs de formulaire explicites et annoncées | TalkBack |

## 5. La sémantique dans Flutter

Flutter construit un **arbre sémantique** parallèle à l'arbre de widgets.
TalkBack (Android) et VoiceOver (iOS) le lisent.

La plupart des widgets Material fournissent déjà leur sémantique : `Text`,
`ElevatedButton`, `Checkbox`, `Switch`, `TextField` (via `labelText`). Le
travail du développeur porte sur les **cas particuliers** :

| Situation | Solution |
|---|---|
| `IconButton` | Toujours un `tooltip` (sert de libellé) |
| `Icon` ou `Image` **informative** | `semanticLabel: 'Stock faible'` |
| `Image` **décorative** | `excludeFromSemantics: true` |
| Groupe d'éléments lus comme **un seul** (carte produit) | `MergeSemantics` |
| Widget personnalisé cliquable (`GestureDetector`, `InkWell`) | `Semantics(button: true, label: …)`. Mieux : utiliser un widget Material |
| Valeur visuelle ambiguë (« 12 500 Ar ») | `Semantics(label: '12 500 ariary')` si la lecture est mauvaise |
| Message qui apparaît (erreur, succès) | `SemanticsService.announce` ou `Semantics(liveRegion: true)` |
| Élément purement décoratif | `ExcludeSemantics` |

### Exemple

```dart
import 'package:flutter/material.dart';

class LigneProduitAccessible extends StatelessWidget {
  const LigneProduitAccessible({
    super.key,
    required this.nom,
    required this.prix,
    required this.stockFaible,
    required this.onOuvrir,
  });

  final String nom;
  final String prix;
  final bool stockFaible;
  final VoidCallback onOuvrir;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    // MergeSemantics : TalkBack lit la ligne en UNE fois :
    // « Riz blanc 5 kg, 12 500 Ar, Stock faible, bouton »
    return MergeSemantics(
      child: ListTile(
        onTap: onOuvrir,
        leading: const Icon(Icons.inventory_2), // décorative : pas de label
        title: Text(nom),
        subtitle: Text(prix),
        trailing: stockFaible
            ? Icon(
                Icons.warning_amber,
                color: c.error,
                semanticLabel: 'Stock faible', // informative : décrite
              )
            : null,
      ),
    );
  }
}
```

## 6. Tester l'accessibilité

### 6.1 Manuellement

1. **TalkBack** (Android) : Paramètres → Accessibilité → TalkBack. Balaye vers
   la droite pour passer à l'élément suivant, touche deux fois pour activer.
   **Ferme les yeux** et essaie d'accomplir une tâche.
2. **Texte agrandi** à 200 % et **taille d'affichage** maximale.
3. **Niveaux de gris** (options pour développeurs → simuler un espace
   colorimétrique) : l'information reste-t-elle compréhensible ?
4. **Accessibility Scanner** (application Google) : analyse un écran et signale
   les problèmes de contraste, de taille de cible et de libellé.

### 6.2 Automatiquement (tests de widgets)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('la page respecte les règles d\'accessibilité', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Produits')),
          body: IconButton(
            onPressed: () {},
            tooltip: 'Ajouter un produit',
            icon: const Icon(Icons.add),
          ),
        ),
      ),
    );

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    handle.dispose();
  });
}
```

Ces tests ne remplacent pas un test avec TalkBack, mais ils **empêchent les
régressions**.

## 7. L'audit UX : évaluation heuristique

Méthode rapide et peu coûteuse pour trouver les problèmes d'ergonomie :

1. **Définir le périmètre** : quels parcours ? (« commander un produit »)
2. **Parcourir** chaque écran **deux fois** : une fois pour la vue d'ensemble,
   une fois en détail.
3. Pour chaque problème, noter :
   - l'**écran** et l'élément ;
   - l'**heuristique** violée (les 10 de Nielsen, D01) ;
   - la **gravité** (0 à 4) ;
   - une **recommandation**.
4. **Prioriser** : gravité × fréquence.
5. Idéalement, **3 à 5 évaluateurs** indépendants, puis fusionner les listes.
   Un seul évaluateur trouve environ 35 % des problèmes.

Échelle de gravité de Nielsen :

| Note | Signification |
|---|---|
| 0 | Pas un problème |
| 1 | Cosmétique : à corriger si on a le temps |
| 2 | Mineur : priorité basse |
| 3 | Majeur : priorité haute |
| 4 | Catastrophique : à corriger avant publication |

Modèle prêt à remplir : [`RESSOURCES/grille-audit-ux.md`](../RESSOURCES/grille-audit-ux.md).

## 8. Le test utilisateur

Rien ne remplace le fait d'**observer une vraie personne** utiliser ton app.

### Préparer

- **5 participants** proches de ton persona : ils révèlent environ 80 % des
  problèmes majeurs (Nielsen). Mieux vaut plusieurs petits tests que un gros.
- **3 à 5 tâches** réalistes, formulées **sans** les mots de l'interface :
  - ❌ « Touchez "Ajouter au panier" sur le riz »
  - ✅ « Vous voulez acheter deux sacs de riz. Faites-le. »
- Un **vrai téléphone**, l'app ou le prototype Figma.

### Conduire

- Demande de **penser à voix haute** (« dites ce que vous cherchez, ce que vous pensez »).
- **N'aide pas.** Si la personne bloque : « Qu'est-ce que vous chercheriez ? ».
  Ton silence est la partie la plus difficile du test.
- Ne défends pas ton design : « c'est l'app qui est testée, pas vous ».
- Note : **réussite** de la tâche (oui / avec aide / non), **temps**, **hésitations**, **citations**.

### Analyser

- Regroupe les problèmes observés chez plusieurs participants.
- Classe-les par gravité.
- Corrige, puis **reteste**.

## 9. Erreurs fréquentes

- Considérer l'accessibilité comme une tâche de fin de projet.
- `IconButton` sans `tooltip`.
- `GestureDetector` sur un `Container` à la place d'un bouton (pas de sémantique, pas de focus).
- Images décoratives lues par TalkBack (« image, image, image »).
- Tester l'app avec ses collègues développeurs.
- Aider les participants pendant le test.

## 10. Questions de révision

1. Donne un exemple de handicap permanent, temporaire et situationnel pour la vue.
2. Que signifie POUR ?
3. Quelle est la différence entre `semanticLabel` et `excludeFromSemantics` ? Quand utiliser chacun ?
4. À quoi sert `MergeSemantics` ?
5. Pourquoi 5 participants suffisent-ils pour un test utilisateur ?
6. Reformule la tâche « Utilisez le filtre "Promotions" » pour un test.

## Pour aller plus loin

- Flutter, *Accessibility* : https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility
- WCAG 2.2 en bref : https://www.w3.org/WAI/standards-guidelines/wcag/glance/
- NN/g, *How to Conduct a Heuristic Evaluation* : https://www.nngroup.com/articles/how-to-conduct-a-heuristic-evaluation/
- Material 3, *Accessibility* : https://m3.material.io/foundations/overview/principles
