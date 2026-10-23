# D05 — La couleur

Durée : 3 h. Prérequis : D04. Flutter : `MaterialApp`, `ThemeData` (semaines 5-6).
Exercices : [`EXERCISES/D05.md`](../EXERCISES/D05.md)

## 1. Objectifs pédagogiques

- Décrire une couleur avec le modèle TSL (HSL) et la modifier volontairement.
- Construire une palette avec une harmonie et la règle 60-30-10.
- Distinguer couleurs de marque, neutres et sémantiques.
- Vérifier le contraste selon les normes WCAG.
- Comprendre les **rôles de couleur** de Material 3 et leur usage dans Flutter.
- Concevoir un mode sombre correct.
- Ne jamais transmettre une information par la couleur seule.

## 2. Décrire une couleur

L'hexadécimal (`#1E88E5`) est fait pour la machine. Pour **raisonner**, utilise
**TSL** (Teinte, Saturation, Luminosité), en anglais **HSL** :

| Composante | Valeurs | Effet |
|---|---|---|
| **Teinte** (Hue) | 0-360° sur le cercle chromatique | 0 = rouge, 120 = vert, 240 = bleu |
| **Saturation** | 0-100 % | 0 = gris, 100 = couleur pure |
| **Luminosité** | 0-100 % | 0 = noir, 50 = couleur, 100 = blanc |

Avantage : pour obtenir une version plus claire d'un bleu, on garde la teinte
et on monte la luminosité. On le **comprend**, au lieu de deviner un hexadécimal.

Material 3 utilise un modèle plus précis, **HCT** (Hue, Chroma, Tone). Le
*tone* (0 = noir, 100 = blanc) est calibré sur la **perception** humaine. Deux
couleurs de même *tone* paraissent aussi claires l'une que l'autre, ce qui n'est
pas vrai en HSL : un jaune et un bleu à 50 % de luminosité HSL n'ont pas du tout
la même clarté perçue. C'est pour ça que M3 garantit de bons contrastes automatiquement.

## 3. Le cercle chromatique et les harmonies

```
                 Jaune
          Orange   ●   Vert-jaune
       Rouge ●           ● Vert
     Magenta ●           ● Cyan
          Violet   ●   Bleu-cyan
                 Bleu
```

| Harmonie | Construction | Effet | Usage |
|---|---|---|---|
| **Monochrome** | Une teinte, plusieurs luminosités | Calme, élégant, sûr | Apps sobres, outils pro |
| **Analogue** | 2-3 teintes voisines (±30°) | Harmonieux, naturel | Apps douces, bien-être |
| **Complémentaire** | Teintes opposées (180°) | Fort contraste, énergique | Une couleur dominante + l'autre en accent rare |
| **Complémentaire divisée** | Une teinte + les deux voisines de son opposée | Contraste plus doux | Plus facile à équilibrer |
| **Triadique** | 3 teintes à 120° | Vif, ludique | Apps pour enfants, jeux. Difficile à maîtriser |

En pratique, pour une application : **une couleur de marque**, des **neutres**
(gris, éventuellement légèrement teintés de la couleur de marque), et des
**couleurs sémantiques**. On ajoute rarement plus.

## 4. La règle 60-30-10

| Part | Rôle | Dans une app M3 |
|---|---|---|
| **60 %** | Couleur dominante, le fond | `surface` et ses variantes |
| **30 %** | Couleur secondaire, les structures | Cartes, barres, conteneurs (`surfaceContainer…`, `secondaryContainer`) |
| **10 %** | Accent, ce qui doit attirer l'œil | `primary` : action principale, état actif |

Si l'accent est partout, il n'attire plus l'œil (loi de Von Restorff, D01).

## 5. Les couleurs sémantiques

Elles portent un **sens** et doivent être utilisées **uniquement** pour ce sens.

| Sens | Couleur habituelle | Exemple |
|---|---|---|
| Erreur, danger, destruction | Rouge | Champ invalide, « Supprimer » |
| Succès | Vert | « Commande validée » |
| Avertissement | Orange / ambre | « Stock faible » |
| Information | Bleu | « Nouvelle version disponible » |

Erreur fréquente : une marque rouge, donc tous les boutons sont rouges, et
l'utilisateur croit que chaque action est dangereuse. Dans ce cas, garde le
rouge de la marque pour le logo et les illustrations, et choisis une autre
couleur pour les actions.

Material 3 ne fournit que `error` en couleur sémantique. On ajoute succès et
avertissement via une **extension de thème** (module D08).

## 6. Le contraste (WCAG)

Le **rapport de contraste** va de 1:1 (même couleur) à 21:1 (noir sur blanc).

| Élément | Minimum WCAG AA | Recommandé (AAA) |
|---|---|---|
| Texte normal | **4,5:1** | 7:1 |
| Grand texte (≥ 24 px, ou ≥ 18,5 px en gras) | **3:1** | 4,5:1 |
| Composants d'interface (bordure de champ, icône seule) | **3:1** | — |
| Texte désactivé, décoratif | aucune exigence | — |

Formule (pour comprendre ; les outils la calculent) :

```
contraste = (L_clair + 0,05) / (L_foncé + 0,05)
où L = luminance relative (0 = noir, 1 = blanc)
```

Pièges classiques :

- **Gris clair sur blanc** (« c'est plus élégant ») : souvent sous 3:1, donc
  illisible au soleil, sur un écran bas de gamme ou pour une personne âgée.
- **Texte blanc sur jaune ou vert clair** : contraste très faible.
- **Texte sur une photo** : le contraste varie selon l'endroit de l'image. Il
  faut ajouter un dégradé sombre ou un fond derrière le texte.

Outils : WebAIM Contrast Checker (https://webaim.org/resources/contrastchecker/),
le plugin Figma « Stark », ou le petit programme Dart de la section 9.

## 7. Le daltonisme

Environ 8 % des hommes et 0,5 % des femmes ont une forme de daltonisme. La plus
fréquente confond **le rouge et le vert**.

Règle absolue : **la couleur ne doit jamais être le seul porteur d'information.**
Il faut l'accompagner d'une icône, d'un texte, d'une forme ou d'un motif.

```
MAUVAIS                     BON
● Stock          (vert)     ✓ En stock         (vert)
● Stock          (rouge)    ⚠ Rupture          (rouge)
```

## 8. Les rôles de couleur Material 3

Au lieu de choisir une couleur pour chaque widget, M3 définit des **rôles**.
Chaque rôle a son partenaire `on…`, à utiliser pour ce qui est posé dessus
(texte, icône). Le contraste entre les deux est garanti.

| Rôle | Usage | Partenaire |
|---|---|---|
| `primary` | Action principale, éléments actifs | `onPrimary` |
| `primaryContainer` | Fond d'élément mis en avant mais moins fort | `onPrimaryContainer` |
| `secondary` / `secondaryContainer` | Éléments moins importants (filtres, puces) | `onSecondary…` |
| `tertiary` / `tertiaryContainer` | Accent contrastant, à utiliser avec parcimonie | `onTertiary…` |
| `error` / `errorContainer` | Erreurs | `onError…` |
| `surface` | Fond principal | `onSurface` (texte principal) |
| `surfaceContainerLowest` → `surfaceContainerHighest` | 5 niveaux de fonds pour cartes, barres, feuilles | `onSurface` |
| — | Texte et icônes secondaires | `onSurfaceVariant` |
| `outline` | Bordures importantes (champs) | — |
| `outlineVariant` | Séparateurs, bordures décoratives | — |

Règle pratique : **toujours utiliser une paire**. Du texte posé sur
`primaryContainer` utilise `onPrimaryContainer`, jamais `onPrimary` ni une
couleur choisie à la main.

## 9. Couleur dans Flutter

### 9.1 Générer un thème clair et sombre à partir d'une couleur

```dart
import 'package:flutter/material.dart';

const couleurMarque = Color(0xFF00897B); // vert-bleu « Tsena »

void main() => runApp(const AppCouleurs());

class AppCouleurs extends StatelessWidget {
  const AppCouleurs({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Thème clair
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: couleurMarque),
      ),
      // Thème sombre : même graine, luminosité inversée
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: couleurMarque,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system, // suit le réglage du téléphone
      home: const PageRoles(),
    );
  }
}

/// Affiche les principaux rôles pour les visualiser.
class PageRoles extends StatelessWidget {
  const PageRoles({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final roles = <(String, Color, Color)>[
      ('primary', c.primary, c.onPrimary),
      ('primaryContainer', c.primaryContainer, c.onPrimaryContainer),
      ('secondaryContainer', c.secondaryContainer, c.onSecondaryContainer),
      ('tertiaryContainer', c.tertiaryContainer, c.onTertiaryContainer),
      ('error', c.error, c.onError),
      ('surfaceContainerHighest', c.surfaceContainerHighest, c.onSurface),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Rôles de couleur')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (nom, fond, texte) in roles)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              color: fond,
              child: Text(nom, style: TextStyle(color: texte)),
            ),
        ],
      ),
    );
  }
}
```

Ce qu'il faut comprendre :

- `fromSeed` génère **toute** la palette (environ 45 rôles) à partir d'une
  couleur, avec des contrastes vérifiés ;
- la couleur générée pour `primary` **n'est pas exactement** la couleur de
  marque, mais une version ajustée pour le contraste. Si la marque exige sa
  couleur exacte, utilise `dynamicSchemeVariant: DynamicSchemeVariant.fidelity`,
  ou fixe `primary` à la main, en vérifiant le contraste toi-même ;
- `(String, Color, Color)` est un **record** Dart, un petit groupe de valeurs
  sans classe. On le décompose dans la boucle `for (final (nom, fond, texte) in roles)`.

### 9.2 Utiliser les couleurs dans un widget

```dart
import 'package:flutter/material.dart';

class BadgeStock extends StatelessWidget {
  const BadgeStock({super.key, required this.enRupture});

  final bool enRupture;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    // Couleur ET icône ET texte : lisible même pour un daltonien.
    final fond = enRupture ? c.errorContainer : c.secondaryContainer;
    final texte = enRupture ? c.onErrorContainer : c.onSecondaryContainer;
    final icone = enRupture ? Icons.warning_amber : Icons.check_circle_outline;
    final libelle = enRupture ? 'Rupture' : 'En stock';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fond,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 16, color: texte),
          const SizedBox(width: 4),
          Text(libelle, style: TextStyle(color: texte)),
        ],
      ),
    );
  }
}
```

### 9.3 Calculer un contraste en Dart

Un bon exercice pour relier Dart et design :

```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Rapport de contraste WCAG entre deux couleurs (de 1 à 21).
double contraste(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final clair = math.max(la, lb);
  final fonce = math.min(la, lb);
  return (clair + 0.05) / (fonce + 0.05);
}

void main() {
  const blanc = Color(0xFFFFFFFF);
  const grisClair = Color(0xFFBDBDBD);
  const grisMoyen = Color(0xFF757575);
  debugPrint(contraste(grisClair, blanc).toStringAsFixed(2)); // 1.88 : illisible
  debugPrint(contraste(grisMoyen, blanc).toStringAsFixed(2)); // 4.61 : conforme AA
}
```

## 10. Le mode sombre

Le mode sombre n'est **pas** une simple inversion des couleurs :

- le fond n'est **pas noir pur** (`#000`) mais gris très foncé, souvent teinté.
  Le noir pur crée un contraste trop dur et des traînées sur certains écrans OLED ;
- le texte n'est **pas blanc pur** : blanc légèrement atténué, pour réduire l'éblouissement ;
- les couleurs saturées **vibrent** sur un fond sombre. On utilise des versions
  plus claires et moins saturées (M3 le fait automatiquement) ;
- l'**élévation** s'exprime par des fonds légèrement plus clairs, pas par des
  ombres, car on ne voit pas une ombre sur du noir (D07).

Avec `ColorScheme.fromSeed(brightness: Brightness.dark)`, M3 applique tout cela.
Ton travail : **ne jamais écrire de couleur en dur** (`Colors.white`,
`Colors.black`) dans un widget. Sinon, le mode sombre casse.

**Couleur dynamique (Material You)** : depuis Android 12, le système peut
fournir une palette tirée du fond d'écran. Le package `dynamic_color` permet de
l'utiliser. C'est un choix à faire : plus personnel, mais moins de contrôle sur
l'identité de marque.

## 11. Erreurs fréquentes

- Des couleurs en dur dans les widgets, ce qui casse le mode sombre et la cohérence.
- Du texte gris clair sur fond blanc.
- Trop de couleurs d'accent.
- Des couleurs sémantiques utilisées pour décorer.
- Une information portée par la couleur seule.
- Associer `onPrimary` à un autre fond que `primary`.

## 12. Questions de révision

1. Pourquoi raisonner en TSL plutôt qu'en hexadécimal ? Qu'apporte HCT ?
2. Explique la règle 60-30-10 avec les rôles M3.
3. Quel contraste minimum pour un texte de 14 px ? Et pour l'icône seule d'un bouton ?
4. Pourquoi le mode sombre n'utilise-t-il pas `#000000` ?
5. Que signifie la paire `primaryContainer` / `onPrimaryContainer` ?
6. Comment rendre un indicateur rouge/vert lisible pour un daltonien ?

## Pour aller plus loin

- Material 3, *Color roles* : https://m3.material.io/styles/color/roles
- Material Theme Builder (générer et exporter un thème) : https://material-foundation.github.io/material-theme-builder/
- WCAG 2.2, *Contrast (Minimum)* : https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum
