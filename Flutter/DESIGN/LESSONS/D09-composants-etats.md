# D09 — Composants, variantes et états

Durée : 3 h. Prérequis : D08, `StatefulWidget` (semaine 5).
Exercices : [`EXERCISES/D09.md`](../EXERCISES/D09.md)

## 1. Objectifs pédagogiques

- Établir une hiérarchie de boutons claire.
- Concevoir les états d'un composant : normal, survolé, focalisé, pressé, désactivé, chargement, erreur.
- Choisir le bon composant Material 3 pour chaque besoin.
- Créer un composant réutilisable avec des variantes.
- Connaître les différences Material / Cupertino et utiliser les composants adaptatifs.

## 2. La hiérarchie des boutons

Sur un écran, l'utilisateur doit voir **immédiatement** l'action principale.

| Niveau | Composant M3 | Apparence | Règle |
|---|---|---|---|
| **Principal** | `FilledButton` | Rempli, couleur `primary` | **Un seul par écran** (ou par zone) |
| **Principal atténué** | `FilledButton.tonal` | Rempli, `secondaryContainer` | Action importante mais pas principale |
| **Secondaire** | `OutlinedButton` | Bordure, sans fond | Alternative à l'action principale (« Annuler ») |
| **Tertiaire** | `TextButton` | Texte seul | Actions mineures, dialogues, liens |
| **Élevé** | `ElevatedButton` | Ombre | Seulement sur fond chargé (image) où le rempli se perd |
| **Icône** | `IconButton` (+ `.filled`, `.outlined`…) | Icône seule | Actions universelles (♡, ⋮, ✕) avec `tooltip` |
| **Flottant** | `FloatingActionButton` | Gros, en bas à droite | L'action **la plus fréquente** de l'écran (créer) |

**Bouton destructif** : il n'existe pas de variante dédiée en M3. On utilise un
`FilledButton` ou un `TextButton` avec les couleurs `error` / `onError`. On le
place à l'écart, et on demande confirmation si l'action est irréversible.

**Ordre de deux boutons côte à côte** :

- Material (dialogues) : `[Annuler] [Confirmer]`, le principal **à droite** ;
- en bas d'écran mobile : souvent empilés, **principal en haut** ou pleine
  largeur, secondaire en `TextButton` en dessous.

**Libellés** : un **verbe** qui dit ce qui va se passer. « Enregistrer le
produit », « Payer 37 500 Ar ». Pas de « OK », « Valider », « Oui », qui
obligent à relire la question.

## 3. Les états d'un composant

Chaque composant interactif doit avoir un aspect pour chaque état :

| État | Signification | Signal visuel M3 |
|---|---|---|
| **Normal** (enabled) | Disponible | Couleurs de base |
| **Survolé** (hovered) | Pointeur au-dessus (souris, tablette) | Calque `onSurface` à 8 % |
| **Focalisé** (focused) | Sélectionné au clavier / lecteur d'écran | Calque 10 % + anneau de focus |
| **Pressé** (pressed) | En train d'être touché | Ripple, calque 10 % |
| **Glissé** (dragged) | En déplacement | Calque 16 % + élévation |
| **Désactivé** (disabled) | Non disponible maintenant | Contenu à 38 % d'opacité, fond à 12 % |
| **Chargement** | Action en cours | Indicateur à la place ou à côté du libellé, interaction bloquée |
| **Erreur** | Valeur invalide (champs) | Couleur `error` + message |
| **Sélectionné** (selected) | Choisi parmi d'autres (puces, onglets) | Fond `secondaryContainer`, coche |

Les composants Material de Flutter gèrent automatiquement survolé, focalisé,
pressé et désactivé. **Chargement** et **erreur** sont de ta responsabilité.

### Désactivé : à utiliser avec prudence

Un bouton désactivé ne dit pas **pourquoi** il l'est. Deux alternatives :

- laisser le bouton actif, puis afficher les erreurs au clic (D14) ;
- le désactiver **et** expliquer à côté (« Ajoutez au moins un article »).

## 4. Les autres composants essentiels

| Besoin | Composant M3 | Ne pas confondre avec |
|---|---|---|
| Saisir du texte | `TextField` / `TextFormField` | — |
| Choisir 1 option parmi 2 à 5 visibles | `SegmentedButton` ou `RadioListTile` | Menu déroulant (cache les options) |
| Choisir 1 option parmi beaucoup | `DropdownMenu` | |
| Filtrer (plusieurs choix) | `FilterChip` | Boutons |
| Activer / désactiver immédiatement | `Switch` | `Checkbox` (validation différée, ex. formulaire) |
| Contenu groupé et actionnable | `Card` | |
| Élément de liste | `ListTile` | Carte personnalisée (si ListTile suffit) |
| Message temporaire | `SnackBar` | Dialogue (bloque) |
| Décision bloquante | `AlertDialog` | |
| Options contextuelles | `MenuAnchor`, `PopupMenuButton`, bottom sheet | |
| Progression | `LinearProgressIndicator`, `CircularProgressIndicator` | |
| Badge de compteur | `Badge` | |

## 5. Créer un composant réutilisable

### Quand extraire un composant ?

- Il apparaît **au moins 2 fois**, ou
- il porte une **règle** du design system (ex. bouton avec chargement), ou
- il rend un écran plus lisible en lui donnant un **nom** métier.

### Exemple : bouton principal avec état de chargement

```dart
import 'package:flutter/material.dart';

/// Variantes du bouton principal.
enum VarianteBouton { principal, tonal, destructif }

/// Bouton d'action du design system : pleine largeur, état de chargement,
/// et protection contre la double soumission.
class BoutonAction extends StatelessWidget {
  const BoutonAction({
    super.key,
    required this.libelle,
    required this.onPressed,
    this.variante = VarianteBouton.principal,
    this.enChargement = false,
    this.icone,
  });

  final String libelle;
  final VoidCallback? onPressed; // null = désactivé
  final VarianteBouton variante;
  final bool enChargement;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    // Pendant le chargement, on bloque l'action (pas de double soumission).
    final action = enChargement ? null : onPressed;

    final contenu = enChargement
        ? SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variante == VarianteBouton.tonal
                  ? c.onSecondaryContainer
                  : c.onPrimary,
            ),
          )
        : Text(libelle);

    final iconeWidget = icone != null && !enChargement ? Icon(icone) : null;

    return switch (variante) {
      VarianteBouton.principal => FilledButton.icon(
          onPressed: action,
          icon: iconeWidget,
          label: contenu,
        ),
      VarianteBouton.tonal => FilledButton.tonalIcon(
          onPressed: action,
          icon: iconeWidget,
          label: contenu,
        ),
      VarianteBouton.destructif => FilledButton.icon(
          onPressed: action,
          icon: iconeWidget,
          label: contenu,
          style: FilledButton.styleFrom(
            backgroundColor: c.error,
            foregroundColor: c.onError,
          ),
        ),
    };
  }
}
```

À remarquer :

- `onPressed` nullable : `null` = désactivé. C'est la convention de Flutter ;
- `enChargement` remplace le libellé par un indicateur **et** bloque l'action ;
- un `enum` pour les variantes : impossible de passer une variante qui n'existe pas ;
- l'expression `switch` (Dart 3) renvoie directement le bon widget ;
- la taille (pleine largeur, 48 dp) vient du `filledButtonTheme` (D08), pas du composant.

### Personnaliser un état précis avec `WidgetStateProperty`

```dart
import 'package:flutter/material.dart';

ButtonStyle styleAvecEtats(ColorScheme c) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((etats) {
      if (etats.contains(WidgetState.disabled)) {
        return c.onSurface.withValues(alpha: 0.12);
      }
      if (etats.contains(WidgetState.pressed)) {
        return c.primary.withValues(alpha: 0.85);
      }
      return c.primary;
    }),
  );
}
```

`WidgetStateProperty.resolveWith` reçoit l'**ensemble des états actuels** et
renvoie la valeur à utiliser. L'ancien nom, `MaterialStateProperty`, est
**obsolète** : si tu le vois dans un tutoriel, c'est que le tutoriel date.

## 6. Material et Cupertino

| Élément | Material (Android) | Cupertino (iOS) |
|---|---|---|
| Interrupteur | `Switch` | `CupertinoSwitch` |
| Dialogue | `AlertDialog` | `CupertinoAlertDialog` |
| Indicateur | `CircularProgressIndicator` | `CupertinoActivityIndicator` |
| Sélecteur de date | `showDatePicker` (calendrier) | `CupertinoDatePicker` (roue) |
| Feuille d'actions | `showModalBottomSheet` | `CupertinoActionSheet` |
| Défilement | Effet de brillance au bout | Rebond |

Trois stratégies :

1. **Material partout** : le plus simple, l'app a la même identité sur les deux
   plateformes. Choix raisonnable pour la plupart des apps métier.
2. **Adaptatif** : les **petits contrôles** suivent la plateforme. Flutter
   propose `Switch.adaptive`, `Slider.adaptive`, `CircularProgressIndicator.adaptive`,
   `showAdaptiveDialog`, `AlertDialog.adaptive`.
3. **Deux interfaces** : coûteux, rarement justifié.

Recommandation pour ce parcours : **Material 3 + composants adaptatifs** pour
les contrôles système (interrupteurs, dialogues, indicateurs). Les utilisateurs
iOS retrouvent leurs repères sans que tu maintiennes deux interfaces.

## 7. Erreurs fréquentes

- Deux `FilledButton` côte à côte : lequel est le principal ?
- Des libellés « OK » / « Oui ».
- Aucun état de chargement : l'utilisateur appuie trois fois et crée trois commandes.
- Un bouton désactivé sans explication.
- Créer `MonBouton` alors que le thème suffisait (`filledButtonTheme`).
- Utiliser `MaterialStateProperty` (obsolète) ou `withOpacity` (obsolète :
  utiliser `withValues(alpha: …)`).

## 8. Questions de révision

1. Combien de `FilledButton` par écran ? Pourquoi ?
2. Cite 6 états d'un composant interactif. Lesquels Flutter gère-t-il seul ?
3. Pourquoi faut-il se méfier du bouton désactivé ?
4. `Switch` ou `Checkbox` pour « Recevoir les notifications » dans les réglages ? Et dans un formulaire d'inscription ?
5. Comment `BoutonAction` empêche-t-il la double soumission ?
6. Quelle stratégie Material/Cupertino recommandes-tu pour une app de commerce ? Justifie.

## Pour aller plus loin

- Material 3, *Buttons* : https://m3.material.io/components/all-buttons
- Material 3, *States* : https://m3.material.io/foundations/interaction/states/overview
- Flutter, *Automatic platform adaptations* : https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations
