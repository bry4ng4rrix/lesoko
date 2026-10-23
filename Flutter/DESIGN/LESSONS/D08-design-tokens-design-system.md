# D08 — Design tokens et design system

Durée : 3 h. Prérequis : D05 à D07, classes Dart (semaine 3).
Exercices : [`EXERCISES/D08.md`](../EXERCISES/D08.md)

## 1. Objectifs pédagogiques

- Expliquer ce qu'est un design system et ce qu'il apporte.
- Distinguer les trois niveaux de tokens : primitifs, sémantiques, de composant.
- Construire un thème Flutter complet à partir de tokens.
- Ajouter des tokens personnalisés avec `ThemeExtension` (succès, avertissement, espacements).
- Documenter un design system.

## 2. Le design system

Un **design system** est l'ensemble des **règles**, **tokens**, **composants**
et **documentation** qui garantissent que tous les écrans d'un produit sont
cohérents, et que les nouveaux se conçoivent vite.

```
          ┌───────────────────────────────┐
          │       Documentation           │  quand et pourquoi utiliser chaque élément
          ├───────────────────────────────┤
          │  Modèles d'écran (patterns)   │  liste, détail, formulaire, vide…
          ├───────────────────────────────┤
          │  Composants                   │  BoutonPrincipal, CarteProduit, ChampPrix…
          ├───────────────────────────────┤
          │  Tokens                       │  couleurs, typo, espaces, rayons, durées
          ├───────────────────────────────┤
          │  Principes                    │  « Clair avant beau », « Une action par écran »
          └───────────────────────────────┘
```

Ce qu'il apporte :

- **cohérence** : le même bouton partout ;
- **vitesse** : on assemble au lieu de redessiner ;
- **maintenance** : changer la couleur primaire = modifier **une** ligne ;
- **communication** : designer et développeur parlent le même langage
  (« utilise `space.m` », pas « mets environ 15 pixels »).

Exemples publics à étudier : Material Design 3 (Google), Human Interface
Guidelines (Apple), Carbon (IBM), Polaris (Shopify), Atlassian Design System.

## 3. Les design tokens

Un **token** est une décision de design nommée et stockée comme une donnée.

### Les trois niveaux

```
PRIMITIF (la valeur brute)        SÉMANTIQUE (le rôle)              COMPOSANT (l'usage précis)
teal-600   = #00897B      ──►     color.primary    = teal-600  ──►  button.primary.bg = color.primary
red-600    = #E53935      ──►     color.error      = red-600   ──►  field.error.border = color.error
space-4    = 16           ──►     space.m          = space-4   ──►  card.padding = space.m
radius-3   = 12           ──►     radius.card      = radius-3
```

Pourquoi trois niveaux ?

- Les écrans n'utilisent **jamais** les primitifs. Si on veut passer du teal au
  bleu, on change `color.primary`, et rien d'autre ne bouge.
- Le mode sombre = **un autre jeu de valeurs** pour les **mêmes tokens sémantiques**.
- Les tokens de composant ne sont utiles que dans un gros système. Dans une
  petite app, primitifs + sémantiques suffisent.

### Nommer les tokens

Nommer par **rôle**, jamais par **apparence** :

| ❌ Mauvais | ✅ Bon | Pourquoi |
|---|---|---|
| `vertClair` | `succesContainer` | Si le succès devient bleu, « vertClair » ment |
| `gros` | `titreSection` | « Gros » ne dit pas quand l'utiliser |
| `padding15` | `espace.m` | 15 sort de la grille ; le nom fige la valeur |

## 4. Le design system dans Flutter

Flutter possède déjà un système de tokens : **`ThemeData`**.

| Tokens | Dans Flutter |
|---|---|
| Couleurs sémantiques | `ColorScheme` (rôles M3) |
| Typographie | `TextTheme` |
| Composants | `filledButtonTheme`, `cardTheme`, `inputDecorationTheme`… |
| Tokens manquants (succès, espacements…) | **`ThemeExtension`** |

### Organisation de fichiers proposée

```
lib/
└── core/
    └── design_system/
        ├── tokens.dart          ← primitifs + espacements + rayons
        ├── couleurs_app.dart    ← ThemeExtension des couleurs sémantiques
        ├── theme.dart           ← construit ThemeData clair et sombre
        └── composants/          ← BoutonPrincipal, EtatVide… (D09)
```

## 5. Exemple complet

### 5.1 Tokens et extension de thème

```dart
// Fichier : lib/core/design_system/tokens.dart
import 'package:flutter/material.dart';

// ---------- Tokens primitifs ----------
abstract final class Palette {
  static const teal600 = Color(0xFF00897B);
  static const vert600 = Color(0xFF2E7D32);
  static const vert100 = Color(0xFFC8E6C9);
  static const vert900 = Color(0xFF1B5E20);
  static const ambre700 = Color(0xFFFFA000);
  static const ambre100 = Color(0xFFFFECB3);
  static const ambre900 = Color(0xFFFF6F00);
}

abstract final class Espace {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
}

abstract final class Rayon {
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
}

// ---------- Tokens sémantiques absents de ColorScheme ----------
@immutable
class CouleursApp extends ThemeExtension<CouleursApp> {
  const CouleursApp({
    required this.succes,
    required this.surSucces,
    required this.succesContainer,
    required this.surSuccesContainer,
    required this.avertissement,
    required this.avertissementContainer,
    required this.surAvertissementContainer,
  });

  final Color succes;
  final Color surSucces;
  final Color succesContainer;
  final Color surSuccesContainer;
  final Color avertissement;
  final Color avertissementContainer;
  final Color surAvertissementContainer;

  static const clair = CouleursApp(
    succes: Palette.vert600,
    surSucces: Colors.white,
    succesContainer: Palette.vert100,
    surSuccesContainer: Palette.vert900,
    avertissement: Palette.ambre900,
    avertissementContainer: Palette.ambre100,
    surAvertissementContainer: Color(0xFF4E2600),
  );

  static const sombre = CouleursApp(
    succes: Color(0xFF81C784),
    surSucces: Color(0xFF003909),
    succesContainer: Color(0xFF1B5E20),
    surSuccesContainer: Palette.vert100,
    avertissement: Palette.ambre700,
    avertissementContainer: Color(0xFF5C3D00),
    surAvertissementContainer: Palette.ambre100,
  );

  // Obligatoire : permet de créer une variante en modifiant quelques valeurs.
  @override
  CouleursApp copyWith({Color? succes, Color? avertissement}) {
    return CouleursApp(
      succes: succes ?? this.succes,
      surSucces: surSucces,
      succesContainer: succesContainer,
      surSuccesContainer: surSuccesContainer,
      avertissement: avertissement ?? this.avertissement,
      avertissementContainer: avertissementContainer,
      surAvertissementContainer: surAvertissementContainer,
    );
  }

  // Obligatoire : permet l'animation fluide entre thème clair et sombre.
  @override
  CouleursApp lerp(CouleursApp? other, double t) {
    if (other == null) return this;
    return CouleursApp(
      succes: Color.lerp(succes, other.succes, t)!,
      surSucces: Color.lerp(surSucces, other.surSucces, t)!,
      succesContainer: Color.lerp(succesContainer, other.succesContainer, t)!,
      surSuccesContainer:
          Color.lerp(surSuccesContainer, other.surSuccesContainer, t)!,
      avertissement: Color.lerp(avertissement, other.avertissement, t)!,
      avertissementContainer:
          Color.lerp(avertissementContainer, other.avertissementContainer, t)!,
      surAvertissementContainer: Color.lerp(
        surAvertissementContainer,
        other.surAvertissementContainer,
        t,
      )!,
    );
  }
}

/// Raccourci : `context.couleursApp.succes` au lieu de
/// `Theme.of(context).extension<CouleursApp>()!.succes`.
extension AccesCouleursApp on BuildContext {
  CouleursApp get couleursApp => Theme.of(this).extension<CouleursApp>()!;
}
```

### 5.2 Le thème qui assemble tout

```dart
// Fichier : lib/core/design_system/theme.dart
import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData construireTheme(Brightness luminosite) {
  final schema = ColorScheme.fromSeed(
    seedColor: Palette.teal600,
    brightness: luminosite,
  );
  final estClair = luminosite == Brightness.light;

  return ThemeData(
    colorScheme: schema,
    extensions: [estClair ? CouleursApp.clair : CouleursApp.sombre],

    // Tokens de composant : définis UNE fois ici, pas dans chaque écran.
    cardTheme: CardThemeData(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rayon.m),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48), // pleine largeur, 48 dp
        padding: const EdgeInsets.symmetric(horizontal: Espace.l),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rayon.s),
      ),
    ),
  );
}
```

### 5.3 Utilisation dans un écran

```dart
// Fichier : lib/core/design_system/composants/bandeau_succes.dart
import 'package:flutter/material.dart';

import '../tokens.dart';

class BandeauSucces extends StatelessWidget {
  const BandeauSucces({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final couleurs = context.couleursApp;

    return Container(
      padding: const EdgeInsets.all(Espace.m),
      decoration: BoxDecoration(
        color: couleurs.succesContainer,
        borderRadius: BorderRadius.circular(Rayon.m),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: couleurs.surSuccesContainer),
          const SizedBox(width: Espace.s),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: couleurs.surSuccesContainer),
            ),
          ),
        ],
      ),
    );
  }
}
```

Le résultat : **aucune** couleur, taille ou rayon en dur dans les écrans. Pour
changer l'identité de l'app, on ne touche que `tokens.dart` et `theme.dart`.

## 6. Documenter le design system

Pour chaque token et chaque composant, la documentation répond à :

- **Quoi** : nom, aperçu, valeurs ;
- **Quand** l'utiliser, et surtout **quand ne pas** l'utiliser ;
- **Variantes et états** (D09) ;
- **Accessibilité** : contraste, taille de cible, libellé ;
- **Exemple de code**.

Le modèle [`RESSOURCES/modele-tokens.md`](../RESSOURCES/modele-tokens.md) sert
de point de départ.

Bonne pratique Flutter : un écran **« catalogue »** (ou galerie) dans l'app de
développement, qui affiche tous les composants et toutes leurs variantes. Le
package `widgetbook` industrialise cette idée (vérifie sa version sur pub.dev).

## 7. Erreurs fréquentes

- Créer un design system **avant** d'avoir 2 ou 3 écrans : on fige des
  décisions prématurées. On l'extrait des écrans existants.
- Des tokens nommés par apparence.
- Contourner le système « juste cette fois » avec une couleur en dur.
- Oublier `lerp` et `copyWith` dans `ThemeExtension`, ce qui produit une erreur
  de compilation, ou une transition clair/sombre brutale.
- Dupliquer ce que `ColorScheme` fournit déjà (une couleur « primaire » dans l'extension).

## 8. Questions de révision

1. Quelles sont les couches d'un design system ?
2. Différencie token primitif, sémantique et de composant avec un exemple chacun.
3. Pourquoi les écrans ne doivent-ils jamais utiliser les tokens primitifs ?
4. Que permet `ThemeExtension` ? Pourquoi `lerp` est-il nécessaire ?
5. Où définir le style par défaut de tous les `FilledButton` de l'app ?
6. Pourquoi ne pas créer le design system dès le premier jour ?

## Pour aller plus loin

- Flutter, *Use themes to share colors and font styles* : https://docs.flutter.dev/cookbook/design/themes
- API `ThemeExtension` : https://api.flutter.dev/flutter/material/ThemeExtension-class.html
- Design Tokens Community Group (format standard) : https://www.designtokens.org/
