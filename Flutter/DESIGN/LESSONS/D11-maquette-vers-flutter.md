# D11 — Reproduire une maquette avec précision dans Flutter

Durée : 3 h. Prérequis : D10, layout Flutter (semaine 6).
Exercices : [`EXERCISES/D11.md`](../EXERCISES/D11.md)

## 1. Objectifs pédagogiques

- Décomposer une maquette en arbre de widgets **avant** de coder.
- Reproduire marges, tailles, alignements, typographie et icônes.
- Éviter les dimensions fixes inutiles.
- Découper l'écran en composants réutilisables.
- Comparer une capture Flutter à la maquette et corriger les écarts méthodiquement.

## 2. La méthode en 6 étapes

```
1. Observer   → 2. Découper   → 3. Arbre      → 4. Coder         → 5. Comparer   → 6. Corriger
   la maquette    en zones        de widgets      de haut en bas     les captures     les écarts
```

### Étape 1 — Observer

Avant toute ligne de code, note :

- les **tokens** utilisés (couleurs, styles de texte, espacements, rayons) ;
- ce qui **défile** et ce qui reste **fixe** ;
- ce qui a une **taille fixe** (avatar 48) et ce qui **s'adapte** (largeur des cartes) ;
- les éléments **répétés** : ce sont des composants.

### Étape 2 — Découper en zones

Trace des rectangles sur une capture de la maquette (même au crayon) :

```
┌────────────────────────────────┐
│ A ← Détail        ♡  ⋮         │  A : AppBar
├────────────────────────────────┤
│ ┌────────────────────────────┐ │
│ │ B        image             │ │  B : image (ratio 4:3, coins 16)
│ └────────────────────────────┘ │
│ C Riz blanc 5 kg               │  C : bloc titre (titre + origine)
│   Vakinankaratra               │
│ D 12 500 Ar         ✓ En stock │  D : ligne prix + badge
│ E Description ……………………………… │  E : texte (bodyLarge)
│   ……………………………………………………………… │
├────────────────────────────────┤
│ F [– 1 +]  [▓ AJOUTER ▓▓▓▓▓▓] │  F : barre d'action fixée en bas
└────────────────────────────────┘
```

### Étape 3 — Écrire l'arbre de widgets (sur papier)

```
Scaffold
├── appBar: AppBar(actions: [IconButton ♡, IconButton ⋮])          ← A
├── body: ListView(padding: 16)                                    ← défile
│   ├── ClipRRect(r16) > AspectRatio(4/3) > Image                  ← B
│   ├── SizedBox(24)
│   ├── BlocTitre(titre, origine)                                  ← C (composant)
│   ├── SizedBox(16)
│   ├── Row[ Text prix, Spacer, BadgeStock ]                       ← D
│   ├── SizedBox(24)
│   └── Text description                                           ← E
└── bottomNavigationBar: SafeArea > Padding(16) >                  ← F (fixe)
        Row[ SelecteurQuantite, SizedBox(16), Expanded > BoutonAction ]
```

Cette étape évite 80 % des erreurs de layout. Si tu ne sais pas écrire l'arbre,
tu ne sais pas encore coder l'écran.

### Étape 4 — Coder de haut en bas, zone par zone

- Commence par la **structure** (`Scaffold`, zones), avec des `Placeholder()` à
  la place des zones pas encore faites.
- Remplace chaque `Placeholder` par sa zone. Lance le **hot reload** après chacune.
- Extrais un **composant** dès qu'une zone a un nom métier (`BlocTitre`, `BadgeStock`).

### Étapes 5 et 6 — Comparer et corriger

Voir la section 6.

## 3. Traduire les mesures

| Maquette (Figma) | Flutter | Attention |
|---|---|---|
| 16 (unités) | `16` (pixels logiques) | Pas de conversion : 1 = 1 |
| Police 16 / interligne 24 | `fontSize: 16, height: 1.5` | `height` = interligne ÷ taille |
| Letter spacing 0,5 % | `letterSpacing: 0.08` (16 × 0,005) | Figma en %, Flutter en pixels |
| Opacité 60 % | `withValues(alpha: 0.6)` | |
| Ombre (x 0, y 2, flou 8) | `BoxShadow(offset: Offset(0, 2), blurRadius: 8)` | Préférer l'élévation M3 |
| Rayon 12 | `BorderRadius.circular(12)` | |
| Width *Fill* | `Expanded` (dans Row/Column) ou rien (ListView étire déjà) | |
| Width *Hug* | Rien : taille naturelle | |
| Width *Fixed* 343 | ⚠ Presque toujours **à ne pas** recopier | Voir ci-dessous |

### Éviter les dimensions fixes inutiles

La maquette est dessinée sur **un** écran (360 de large). Si tu recopies
« largeur de la carte : 328 », la carte sera trop petite sur une tablette et
débordera sur un petit téléphone.

| Dans la maquette | Ce que ça signifie vraiment | Flutter |
|---|---|---|
| Carte de 328 de large sur un écran de 360 | « Pleine largeur moins 16 de chaque côté » | `Padding(horizontal: 16)` + largeur libre |
| Image 328 × 246 | « Pleine largeur, ratio 4:3 » | `AspectRatio(aspectRatio: 4 / 3)` |
| Bouton 328 × 48 | « Pleine largeur, hauteur 48 » | `minimumSize: Size.fromHeight(48)` |
| Avatar 48 × 48 | Vraiment fixe | `SizedBox.square(dimension: 48)` |
| Texte dans une boîte de 200 × 40 | « Le texte, sur 2 lignes max » | `maxLines: 2`, sans hauteur fixe |

**Règle : fixer les dimensions des éléments qui ont une taille *intrinsèque*
(icônes, avatars, zones tactiles), laisser s'adapter tout le reste.**

## 4. Exemple : la zone F (barre d'action fixe)

```dart
import 'package:flutter/material.dart';

class BarreAjoutPanier extends StatelessWidget {
  const BarreAjoutPanier({
    super.key,
    required this.quantite,
    required this.onMoins,
    required this.onPlus,
    required this.onAjouter,
  });

  final int quantite;
  final VoidCallback? onMoins;
  final VoidCallback onPlus;
  final VoidCallback onAjouter;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Material(
      color: c.surfaceContainer, // élévation tonale de la barre
      child: SafeArea(
        top: false, // seulement la zone de gestes en bas
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Sélecteur de quantité : taille intrinsèque
              IconButton.outlined(
                onPressed: quantite > 1 ? onMoins : null,
                tooltip: 'Diminuer la quantité',
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$quantite',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton.outlined(
                onPressed: onPlus,
                tooltip: 'Augmenter la quantité',
                icon: const Icon(Icons.add),
              ),
              const SizedBox(width: 16),
              // Le bouton prend toute la place restante : « Fill container »
              Expanded(
                child: FilledButton.icon(
                  onPressed: onAjouter,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Ajouter'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Utilisation : `Scaffold(bottomNavigationBar: BarreAjoutPanier(...))`. La barre
reste fixe en bas pendant que le `body` défile.

## 5. Polices et icônes

- **Police** : déclarée dans `pubspec.yaml` avec **toutes** les graisses
  utilisées dans la maquette (D06). Sans le fichier « Medium », Flutter
  **simule** le 500, et le texte paraîtra légèrement différent de la maquette.
- **Icônes** : vérifie que la maquette utilise le même jeu que Flutter. Les
  `Icons` de Flutter sont les **Material Icons**. Material Symbols (variables,
  plus récents) demandent un package (`material_symbols_icons`, vérifie la
  version sur pub.dev).
- **Taille d'icône** : 24 par défaut en M3, 18 dans les boutons, 20 dans
  certains champs.

## 6. Comparer la capture et la maquette

### 6.1 Obtenir des captures comparables

1. Lance l'app sur un appareil, ou redimensionne la fenêtre Linux, à la **même
   largeur logique** que le frame de la maquette (ex. 360).
2. Capture d'écran (ou `flutter screenshot` sur un appareil Android).
3. Exporte le frame de la maquette en PNG à la même échelle.

### 6.2 Comparer

- **Superposition** : dans Figma ou GIMP, pose la capture au-dessus de la
  maquette, à 50 % d'opacité. Les écarts apparaissent en « doublons ».
- **Côte à côte** : vérifie zone par zone avec la grille de contrôle ci-dessous.
- **Flutter DevTools → Widget Inspector** : clique sur un élément pour voir sa
  taille réelle, ses contraintes et son padding. Active « Show guidelines » pour
  voir les limites des widgets.

### 6.3 Grille de contrôle

| Critère | ✓ / ✗ | Écart constaté |
|---|---|---|
| Marges d'écran | | |
| Espacements entre zones | | |
| Tailles et graisses de texte | | |
| Couleurs (avec les rôles, pas « à l'œil ») | | |
| Rayons de coins | | |
| Tailles d'icônes | | |
| Alignements (axes communs) | | |
| Troncatures | | |
| Comportement au défilement (ce qui reste fixe) | | |
| États (chargement, vide, erreur) | | |

### 6.4 Corriger méthodiquement

- **Une correction à la fois**, puis hot reload et nouvelle comparaison.
- Corrige d'abord la **structure** (zones, alignements), puis les **espacements**,
  puis la **typographie**, et les **couleurs** en dernier.
- Si un écart vient de la **maquette** (valeur hors grille, couleur hors
  palette), corrige la maquette plutôt que le code.
- **Documente** les écarts restants **acceptés** : rendu des polices
  différent entre Figma et Flutter, ombres légèrement différentes.

### 6.5 Les tests « golden » (aperçu)

Un **golden test** compare automatiquement une capture d'un widget à une image
de référence enregistrée. Si un changement de code modifie l'apparence, le test
échoue. On les verra en semaine 19 (`matchesGoldenFile`).

## 7. Erreurs fréquentes

- Coder sans avoir écrit l'arbre de widgets.
- Recopier toutes les largeurs de la maquette.
- `Container` partout : préférer le widget **dédié** (`Padding`, `SizedBox`,
  `DecoratedBox`, `ColoredBox`), qui exprime l'intention.
- Corriger « à l'œil » au lieu de mesurer avec DevTools.
- Un `Column` qui déborde parce qu'il n'est pas dans un `ListView` ou un
  `SingleChildScrollView` : c'est la bande jaune et noire.
- Comparer une capture à 411 de large avec une maquette à 360.

## 8. Questions de révision

1. Quelles sont les 6 étapes de la méthode ?
2. Pourquoi écrire l'arbre de widgets sur papier ?
3. Traduis en Flutter : police 14, interligne 20, letter spacing 1 %.
4. Une image de 328 × 185 sur un frame de 360 : comment la coder ?
5. Dans quel ordre corriger les écarts ? Pourquoi les couleurs en dernier ?
6. À quoi sert le Widget Inspector de DevTools ?

## Pour aller plus loin

- Flutter, *Understanding constraints* (à relire plusieurs fois) : https://docs.flutter.dev/ui/layout/constraints
- Flutter DevTools, *Inspector* : https://docs.flutter.dev/tools/devtools/inspector
