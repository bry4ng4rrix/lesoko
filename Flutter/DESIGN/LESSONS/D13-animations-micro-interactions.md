# D13 — Animations et micro-interactions

Durée : 3 h. Prérequis : D09, `StatefulWidget`, `setState`.
Exercices : [`EXERCISES/D13.md`](../EXERCISES/D13.md)

## 1. Objectifs pédagogiques

- Expliquer à quoi sert une animation, et quand elle nuit.
- Choisir une durée et une courbe adaptées.
- Utiliser les animations implicites de Flutter.
- Savoir quand passer aux animations explicites.
- Créer des transitions entre écrans (dont `Hero`).
- Respecter la préférence « réduire les animations ».

## 2. À quoi sert une animation ?

Une animation n'est pas une décoration : elle doit **communiquer** quelque chose.

| Rôle | Exemple |
|---|---|
| **Feedback** : « ton action est prise en compte » | Ripple au toucher, cœur qui se remplit |
| **Relation spatiale** : « d'où vient cet élément, où va-t-il » | La carte produit qui s'agrandit en écran de détail |
| **Changement d'état** : « quelque chose a changé ici » | Le badge du panier qui pulse quand on ajoute un article |
| **Attente** : « le système travaille » | Squelette animé, indicateur de progression |
| **Guidage** : « regarde ici » | Un champ en erreur qui tremble une fois |

Si tu ne peux pas dire **ce qu'elle communique**, supprime-la.

## 3. Durées

| Type de mouvement | Durée | Token M3 (`Durations`) |
|---|---|---|
| Petits changements (couleur d'un bouton, case cochée) | 50 – 150 ms | `short1` … `short3` |
| Éléments moyens (ouverture d'une carte, badge) | 200 – 300 ms | `short4`, `medium1`, `medium2` |
| Grands éléments, transitions d'écran | 300 – 500 ms | `medium2` … `long2` |
| Au-delà de 500 ms | ⚠ Rare | Paraît lent |

Règles :

- **Plus l'élément parcourt de distance ou est grand, plus c'est long.**
- **Disparition plus rapide qu'apparition** : l'utilisateur a déjà décidé de passer à autre chose.
- Une animation fréquente (à chaque toucher) doit être **très courte**. Au
  dixième usage, 400 ms deviennent insupportables.

## 4. Courbes (easing)

Dans le monde réel, rien ne démarre ni ne s'arrête instantanément.

| Courbe | Comportement | Usage |
|---|---|---|
| `linear` | Vitesse constante | Rotation continue, progression. Sinon « mécanique » |
| **Décélération** (ease-out) | Rapide puis ralentit | Élément qui **entre** à l'écran |
| **Accélération** (ease-in) | Lent puis accélère | Élément qui **sort** de l'écran |
| **Standard** (ease-in-out) | Accélère puis ralentit | Élément qui **se déplace** d'un point à un autre |
| **Emphasized** (M3) | Expressif, décélération marquée | Transitions principales M3 |

Flutter fournit `Curves` (`Curves.easeOut`…) et les courbes M3 dans `Easing` :
`Easing.standard`, `Easing.emphasizedDecelerate`, `Easing.emphasizedAccelerate`.

## 5. Animations implicites

Le plus simple : un widget `Animated…` anime **automatiquement** le passage
d'une valeur à une autre quand elle change (via `setState`).

| Widget | Anime |
|---|---|
| `AnimatedContainer` | Taille, couleur, padding, rayon, décoration |
| `AnimatedOpacity` | Opacité |
| `AnimatedAlign`, `AnimatedPadding` | Position, padding |
| `AnimatedScale`, `AnimatedRotation`, `AnimatedSlide` | Échelle, rotation, glissement |
| `AnimatedSwitcher` | Remplacement d'un widget par un autre (fondu par défaut) |
| `AnimatedCrossFade` | Fondu entre deux widgets précis |
| `AnimatedSize` | Changement de taille d'un enfant |
| `TweenAnimationBuilder` | **N'importe quelle** valeur (le joker) |

### Exemple : bouton favori

```dart
import 'package:flutter/material.dart';

class BoutonFavori extends StatefulWidget {
  const BoutonFavori({super.key});

  @override
  State<BoutonFavori> createState() => _BoutonFavoriState();
}

class _BoutonFavoriState extends State<BoutonFavori> {
  bool _favori = false;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    // Respecte la préférence système « réduire les animations ».
    final sansAnimation = MediaQuery.disableAnimationsOf(context);

    return IconButton(
      tooltip: _favori ? 'Retirer des favoris' : 'Ajouter aux favoris',
      onPressed: () => setState(() => _favori = !_favori),
      icon: AnimatedScale(
        scale: _favori ? 1.15 : 1.0,
        duration: sansAnimation ? Duration.zero : Durations.short4,
        curve: Easing.emphasizedDecelerate,
        child: AnimatedSwitcher(
          duration: sansAnimation ? Duration.zero : Durations.short3,
          child: Icon(
            _favori ? Icons.favorite : Icons.favorite_border,
            // La clé dit à AnimatedSwitcher que l'enfant a changé.
            key: ValueKey(_favori),
            color: _favori ? c.error : c.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
```

À remarquer :

- **aucun contrôleur** : on change `_favori`, Flutter anime ;
- `ValueKey(_favori)` : sans clé, `AnimatedSwitcher` croit que c'est le même
  widget (même type `Icon`) et n'anime rien ;
- `MediaQuery.disableAnimationsOf(context)` : si l'utilisateur a activé
  « Supprimer les animations » dans l'accessibilité, on passe à une durée nulle.

## 6. Animations explicites

Quand l'animation doit **boucler**, être **pilotée** (geste, progression),
**enchaîner** plusieurs étapes ou démarrer **sans changement d'état**, on
utilise un `AnimationController`.

```dart
import 'package:flutter/material.dart';

/// Squelette de chargement : pulsation continue.
class BlocSquelette extends StatefulWidget {
  const BlocSquelette({super.key, this.hauteur = 16, this.largeur});

  final double hauteur;
  final double? largeur;

  @override
  State<BlocSquelette> createState() => _BlocSqueletteState();
}

class _BlocSqueletteState extends State<BlocSquelette>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controleur = AnimationController(
    vsync: this, // synchronise avec l'écran, s'arrête si invisible
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controleur.dispose(); // OBLIGATOIRE : sinon fuite de ressources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couleur = Theme.of(context).colorScheme.surfaceContainerHighest;
    return FadeTransition(
      opacity: Tween<double>(begin: 0.4, end: 1).animate(_controleur),
      child: Container(
        height: widget.hauteur,
        width: widget.largeur,
        decoration: BoxDecoration(
          color: couleur,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
```

Points clés :

- `SingleTickerProviderStateMixin` fournit le `vsync` ;
- **toujours** appeler `dispose()` sur le contrôleur ;
- les widgets `…Transition` (`FadeTransition`, `SlideTransition`,
  `ScaleTransition`) écoutent l'animation **sans `setState`**, ce qui est performant.

Règle de choix : **implicite d'abord**. On passe à l'explicite seulement si
l'implicite ne suffit pas.

## 7. Transitions entre écrans

- Les transitions par défaut de `MaterialPageRoute` suivent la plateforme
  (zoom/fondu sur Android, glissement sur iOS). **Garde-les** dans la plupart des cas.
- **`Hero`** : un élément partagé « vole » d'un écran à l'autre. Exemple :
  l'image de la carte produit devient l'image du détail. Même `tag` sur les deux
  écrans.

```dart
import 'package:flutter/material.dart';

// Écran liste
Widget vignette(String id) => Hero(
      tag: 'produit-$id',
      child: const Icon(Icons.image, size: 64),
    );

// Écran détail
Widget imageDetail(String id) => Hero(
      tag: 'produit-$id',
      child: const Icon(Icons.image, size: 200),
    );
```

- Le package `animations` (équipe Flutter) fournit les transitions M3 :
  `OpenContainer` (une carte qui s'ouvre en écran), shared axis, fade through.
  Vérifie sa version sur pub.dev.

## 8. Les micro-interactions

Une micro-interaction est un petit moment centré sur **une** tâche. Elle a 4 parties :

1. **Déclencheur** : l'utilisateur touche « Ajouter au panier » ;
2. **Règles** : l'article est ajouté, et la quantité incrémentée s'il existe déjà ;
3. **Feedback** : le badge du panier passe de 2 à 3 avec une petite pulsation,
   et une SnackBar « Ajouté · VOIR » apparaît ;
4. **Boucles et modes** : au 2ᵉ ajout du même produit, la SnackBar dit « Quantité : 2 ».

Les meilleures sont **à peine remarquées** : on s'en rend compte seulement quand elles manquent.

## 9. Accessibilité et performance

- **Réduire les animations** : `MediaQuery.disableAnimationsOf(context)`. Les
  mouvements amples peuvent provoquer des nausées (troubles vestibulaires).
- Pas de **clignotement** de plus de 3 fois par seconde (risque d'épilepsie).
- Aucune information essentielle **uniquement** dans une animation.
- Performance : animer `opacity` et `transform` (échelle, translation) est peu
  coûteux. Animer la **taille** d'un grand arbre de widgets l'est beaucoup plus.
  Vérifie avec DevTools → Performance (en mode profile, pas debug).

## 10. Erreurs fréquentes

- Des animations longues sur des actions répétées.
- La même animation spectaculaire partout.
- Oublier `dispose()` sur un `AnimationController`.
- `AnimatedSwitcher` sans `key`, donc aucune animation.
- Ignorer la préférence « réduire les animations ».
- Juger la fluidité en mode **debug** (toujours plus lent) : teste avec `flutter run --profile`.

## 11. Questions de révision

1. Cite 4 rôles d'une animation, avec un exemple chacun.
2. Quelle courbe pour un élément qui entre ? Qui sort ? Pourquoi ?
3. Pourquoi une animation fréquente doit-elle être courte ?
4. Quand passer d'une animation implicite à une animation explicite ?
5. Pourquoi `AnimatedSwitcher` a-t-il besoin d'une `key` ?
6. Comment respecter la préférence « réduire les animations » ?

## Pour aller plus loin

- Flutter, *Animations* : https://docs.flutter.dev/ui/animations
- Material 3, *Motion* : https://m3.material.io/styles/motion/overview
- Package `animations` : https://pub.dev/packages/animations
