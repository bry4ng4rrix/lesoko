# D07 — Espacements, formes, bordures, ombres et élévation

Durée : 2 h 30. Prérequis : D04 à D06. Exercices : [`EXERCISES/D07.md`](../EXERCISES/D07.md)

## 1. Objectifs pédagogiques

- Utiliser un système d'espacement en multiples de 4 et 8.
- Distinguer padding, margin et gap, et les appliquer en Flutter.
- Choisir des rayons de coins cohérents.
- Savoir quand utiliser une bordure, une ombre ou une couleur de fond.
- Comprendre l'élévation en Material 3 (tonale plutôt qu'ombrée).
- Connaître les tailles minimales des zones tactiles.

## 2. Pourquoi un système d'espacement ?

Sans système, chaque espace est choisi « à l'œil » : 13 ici, 15 là, 18 ailleurs.
Le résultat semble « presque aligné », ce qui fait amateur, et chaque décision
prend du temps.

Avec un **système en grille de 8** (et 4 pour les petits ajustements) :

| Token | Valeur | Usage typique |
|---|---|---|
| `xxs` | 2 | Rare : écart icône / badge |
| `xs` | 4 | Entre un titre et son sous-titre |
| `s` | 8 | Entre éléments liés (icône et texte, champs d'un même groupe) |
| `m` | 16 | **Marges d'écran**, padding des cartes, entre éléments d'une liste |
| `l` | 24 | Entre sections |
| `xl` | 32 | Grandes séparations, haut/bas d'un écran vide |
| `xxl` | 48 | Respiration autour d'un élément isolé |

Pourquoi 8 ? Il se divise bien (8 → 4 → 2), correspond aux densités d'écran
courantes (1x, 1,5x, 2x, 3x donnent des pixels entiers) et c'est la base de
Material Design. Avantage immédiat : tu ne choisis plus parmi une infinité de
valeurs, mais parmi 6.

## 3. Padding, margin, gap

```
┌─────────────── margin (extérieur) ────────────────┐
│  ┌──────────── bordure ────────────────────────┐  │
│  │  padding (intérieur)                        │  │
│  │   ┌─────────┐  gap  ┌─────────┐             │  │
│  │   │ enfant  │ ◄───► │ enfant  │             │  │
│  │   └─────────┘       └─────────┘             │  │
│  └─────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────┘
```

| Concept | Flutter |
|---|---|
| Padding (intérieur) | `Padding(padding: EdgeInsets.all(16))` ou `Container(padding: …)` |
| Margin (extérieur) | `Container(margin: …)`, ou un `Padding` autour |
| Gap (entre enfants) | `SizedBox(height: 8)` entre les enfants d'une `Column` ; `Column(spacing: 8)` / `Row(spacing: 8)` pour un écart régulier ; `ListView.separated` |

Règle des espacements internes et externes (rappel de D04) : le padding d'une
carte (16) doit être **supérieur ou égal** aux écarts entre ses éléments (4-8).
Sinon, le contenu semble « s'échapper » de la carte.

## 4. Les formes : rayons de coins

Material 3 définit une **échelle de formes** :

| Token M3 | Rayon | Composants |
|---|---|---|
| none | 0 | Plein écran, barres |
| extra-small | 4 | Petits éléments, menus contextuels |
| small | 8 | Puces (chips), petits boutons |
| medium | 12 | **Cartes** |
| large | 16 | Bouton flottant (FAB), tiroir |
| extra-large | 28 | **Dialogues**, feuilles modales (haut) |
| full | demi-hauteur | **Boutons** M3 (pilule), champs de recherche, badges |

Ce que disent les coins :

- **arrondis généreux** : amical, doux (apps grand public, finance personnelle) ;
- **angles vifs / petits rayons** : sérieux, technique, dense (outils pro) ;
- **cohérence** : un même type de composant garde toujours le même rayon.

Règle des **rayons imbriqués** : un élément arrondi placé dans un autre
arrondi doit avoir un rayon plus petit.

```
rayon_intérieur = rayon_extérieur − padding
Carte rayon 16, padding 8  →  image intérieure : rayon 8
```

Sinon, l'espace entre les deux courbes n'est pas régulier et l'œil le remarque.

## 5. Séparer les éléments : 4 outils

Du plus léger au plus lourd :

| Outil | Effet | Quand |
|---|---|---|
| **Espace** | Sépare sans ajouter de bruit | À essayer **en premier** |
| **Couleur de fond** | Groupe dans une région commune | Cartes sur un fond légèrement différent |
| **Bordure / séparateur** | Délimite nettement | Listes denses, champs de saisie |
| **Ombre** | Détache du fond, indique la superposition | Éléments **au-dessus** du contenu (menus, FAB, feuilles) |

Erreur fréquente : tout en même temps (carte avec bordure **et** ombre **et**
fond coloré **et** séparateurs internes). Une seule technique suffit généralement.

## 6. L'élévation

L'**élévation** indique la distance d'un élément par rapport au fond, sur l'axe
Z. Elle communique : « je suis au-dessus », « je suis temporaire », « je suis
interactif ».

### Material 3 : élévation tonale

En Material 2, l'élévation = une ombre. En **Material 3**, l'élévation est
d'abord **tonale** : plus un élément est haut, plus son fond se rapproche de la
couleur primaire, grâce aux `surfaceContainer…`. L'ombre est réservée aux
éléments qui doivent vraiment se détacher (FAB, menus).

| Niveau | Élévation (dp) | Exemples |
|---|---|---|
| 0 | 0 | Fond, cartes « filled » et « outlined » |
| 1 | 1 | Cartes « elevated », feuilles modales |
| 2 | 3 | Barre de navigation, menus |
| 3 | 6 | FAB, dialogues, sélecteurs |
| 4 | 8 | (survol) |
| 5 | 12 | (survol) |

Avantage du tonal : il **fonctionne en mode sombre**, où les ombres sont invisibles.

Flutter propose trois variantes de cartes M3 :

```
Card(...)            → elevated : ombre légère
Card.filled(...)     → fond surfaceContainerHighest, sans ombre
Card.outlined(...)   → bordure outlineVariant, sans ombre
```

## 7. Les zones tactiles

| Plateforme | Minimum |
|---|---|
| Material (Android) | **48 × 48 dp** |
| Apple HIG (iOS) | **44 × 44 pt** |
| Écart entre deux cibles | **8 dp** minimum |

La zone tactile peut être **plus grande que l'élément visible**. Une icône de
24 dp reste dans une zone de 48 dp : c'est ce que fait `IconButton`
automatiquement. Avec un simple `GestureDetector` autour d'une `Icon`, on perd
cette garantie.

## 8. Exemple Flutter : tokens d'espacement et formes

```dart
import 'package:flutter/material.dart';

/// Tokens d'espacement : une seule source de vérité.
abstract final class Espace {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
}

/// Tokens de rayons.
abstract final class Rayon {
  static const double petit = 8;
  static const double moyen = 12;
  static const double grand = 16;
}

class CarteCommande extends StatelessWidget {
  const CarteCommande({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    return Card.outlined(
      margin: const EdgeInsets.symmetric(horizontal: Espace.m),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rayon.grand),
        side: BorderSide(color: c.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Espace.s),
        child: Row(
          children: [
            // Rayon imbriqué : 16 (carte) − 8 (padding) = 8
            ClipRRect(
              borderRadius: BorderRadius.circular(Rayon.grand - Espace.s),
              child: Container(
                width: 72,
                height: 72,
                color: c.primaryContainer,
                child: Icon(Icons.shopping_bag, color: c.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: Espace.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Espace.xs,
                children: [
                  Text('Commande n° 1042', style: t.titleMedium),
                  Text(
                    '3 articles · 37 500 Ar',
                    style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              tooltip: 'Plus d\'options',
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
```

À remarquer :

- `abstract final class` + `static const` : un regroupement de constantes qu'on
  ne peut ni instancier ni étendre. Les tokens deviennent `Espace.m`, lisibles et
  impossibles à mal taper ;
- `Column(spacing: Espace.xs)` : un écart régulier sans répéter `SizedBox` ;
- `IconButton` : garantit une zone tactile de 48 dp et un `tooltip`, lu par le
  lecteur d'écran (D15).

## 9. Erreurs fréquentes

- Des valeurs « magiques » (13, 17, 22) au lieu des tokens.
- Un padding de carte plus petit que l'écart entre ses éléments.
- Des rayons différents pour un même type de composant.
- Un rayon intérieur égal au rayon extérieur.
- Des ombres fortes partout, ou invisibles en mode sombre.
- Des cibles tactiles de 24 dp collées les unes aux autres.

## 10. Questions de révision

1. Pourquoi une grille de 8 ? Donne trois raisons.
2. Quelle est la différence entre padding, margin et gap ? Comment fait-on chacun en Flutter ?
3. Énonce la règle des rayons imbriqués et calcule le rayon intérieur pour une carte de rayon 20 avec un padding de 12.
4. Dans quel ordre essayer les outils de séparation ? Pourquoi l'espace en premier ?
5. Qu'est-ce que l'élévation tonale et pourquoi M3 la préfère-t-il ?
6. Pourquoi `IconButton` plutôt que `GestureDetector` + `Icon` ?

## Pour aller plus loin

- Material 3, *Shape* : https://m3.material.io/styles/shape/corner-radius-scale
- Material 3, *Elevation* : https://m3.material.io/styles/elevation/overview
- Material 3, *Spacing* : https://m3.material.io/foundations/layout/understanding-layout/spacing
