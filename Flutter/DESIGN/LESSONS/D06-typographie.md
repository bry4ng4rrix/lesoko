# D06 — La typographie

Durée : 2 h 30. Prérequis : D04, D05. Exercices : [`EXERCISES/D06.md`](../EXERCISES/D06.md)

## 1. Objectifs pédagogiques

- Connaître le vocabulaire typographique de base.
- Construire et utiliser une échelle typographique.
- Régler interlignage, longueur de ligne et graisse pour la lisibilité.
- Choisir et associer des polices.
- Utiliser l'échelle Material 3 dans Flutter et intégrer une police personnalisée.
- Respecter la taille de texte choisie par l'utilisateur.

## 2. Le vocabulaire

| Terme | Définition |
|---|---|
| **Police** (famille) | Ensemble cohérent de caractères : Roboto, Inter, Poppins |
| **Graisse** (weight) | Épaisseur : 100 (thin) … 400 (regular) … 700 (bold) … 900 (black) |
| **Corps** (taille) | Taille du texte, en pixels logiques (`fontSize`) |
| **Interlignage** (line height) | Hauteur d'une ligne de texte. En Flutter, `height` est un **multiplicateur** du corps |
| **Approche** (letter spacing) | Espace entre les lettres |
| **Empattement** (serif) | Petits traits au bout des lettres (Times). « Sans serif » : sans (Roboto) |
| **Hauteur d'x** | Hauteur des minuscules. Plus elle est grande, plus la police est lisible en petit |
| **Chasse fixe** (monospace) | Toutes les lettres ont la même largeur : code, ou chiffres alignés |

## 3. L'échelle typographique

Utiliser des tailles au hasard (13, 15, 17, 19…) produit une hiérarchie floue.
Une **échelle** fixe un nombre limité de tailles, chacune avec un **rôle**.

Material 3 définit 15 styles, en 5 rôles × 3 tailles :

| Style | Taille / interligne (px) | Graisse | Usage mobile |
|---|---|---|---|
| `displayLarge` | 57 / 64 | 400 | Chiffre clé géant, rare sur téléphone |
| `displayMedium` | 45 / 52 | 400 | |
| `displaySmall` | 36 / 44 | 400 | Montant total sur un écran de paiement |
| `headlineLarge` | 32 / 40 | 400 | |
| `headlineMedium` | 28 / 36 | 400 | Titre d'écran sans AppBar |
| `headlineSmall` | 24 / 32 | 400 | Titre de section importante |
| `titleLarge` | 22 / 28 | 400 | Titre de l'AppBar, de dialogue |
| `titleMedium` | 16 / 24 | 500 | Titre de carte, élément de liste |
| `titleSmall` | 14 / 20 | 500 | Sous-titre |
| `bodyLarge` | 16 / 24 | 400 | Texte principal, champs |
| `bodyMedium` | 14 / 20 | 400 | Texte par défaut de `Text` |
| `bodySmall` | 12 / 16 | 400 | Texte secondaire, légende |
| `labelLarge` | 14 / 20 | 500 | Texte des boutons |
| `labelMedium` | 12 / 16 | 500 | Puces, badges |
| `labelSmall` | 11 / 16 | 500 | Très petits libellés, à éviter pour lire |

**Sur un même écran, 3 ou 4 styles suffisent.** Par exemple : `titleLarge`
(AppBar), `titleMedium` (titres de cartes), `bodyMedium` (texte) et `labelLarge`
(boutons).

### Construire sa propre échelle

On part d'une taille de base (16) et on multiplie par un **ratio** :

| Ratio | Nom | Échelle obtenue depuis 16 | Caractère |
|---|---|---|---|
| 1,125 | Seconde majeure | 14 · **16** · 18 · 20 · 23 | Discret, dense : apps de données |
| 1,25 | Tierce majeure | 13 · **16** · 20 · 25 · 31 | Équilibré, très courant |
| 1,333 | Quarte juste | 12 · **16** · 21 · 28 · 38 | Contrasté : apps éditoriales |

Sur mobile, préfère un ratio modéré (1,2 ou 1,25). Un ratio trop fort donne des
titres énormes sur un petit écran.

## 4. La lisibilité

### 4.1 Interlignage

- Texte courant : **1,4 à 1,6 fois** le corps (16 px → 24 px, soit `height: 1.5`).
- Titres : plus serré, **1,1 à 1,3**. Les grands caractères paraissent déjà espacés.
- Un interlignage trop serré rend la lecture pénible ; trop large, les lignes
  semblent ne plus appartenir au même paragraphe.

### 4.2 Longueur de ligne

- Idéal : **45 à 75 caractères** par ligne. Sur téléphone, on est naturellement
  dans ces valeurs.
- Sur tablette ou en paysage, **limiter la largeur** du texte (par exemple
  600 px maximum) au lieu d'étirer les lignes sur tout l'écran (D12).

### 4.3 Graisse et casse

- 2 ou 3 graisses suffisent : 400, 500, 700.
- **ÉVITER LES PARAGRAPHES EN MAJUSCULES** : c'est moins lisible, car les mots
  perdent leur silhouette, et cela donne l'impression qu'on crie. Les majuscules
  sont réservées aux libellés très courts.
- L'italique est moins lisible sur écran. On l'utilise ponctuellement.

### 4.4 Alignement

- Texte aligné **à gauche** (en ferré à gauche, drapeau à droite).
- **Pas de justification** sur mobile : elle crée des « rivières » d'espaces
  irréguliers dans les colonnes étroites.

### 4.5 Les chiffres

- Pour des colonnes de prix, utilise des **chiffres tabulaires** (même largeur) :
  `FontFeature.tabularFigures()` en Flutter.
- Formate les nombres pour qu'ils soient lisibles : `12 500 Ar` et non `12500`.
  Le package `intl` (`NumberFormat`) gère les séparateurs selon la langue.

## 5. Choisir une police

| Famille | Caractère | Exemples (Google Fonts, gratuites) |
|---|---|---|
| Sans serif géométrique | Moderne, amical | Poppins, Montserrat, Outfit |
| Sans serif humaniste / néo-grotesque | Neutre, très lisible | **Roboto** (Android), Inter, Noto Sans, Source Sans 3 |
| Serif | Classique, éditorial, confiance | Merriweather, Lora, Playfair Display (titres) |
| Monospace | Technique, chiffres alignés | Roboto Mono, JetBrains Mono |

Règles :

1. **Une police suffit** dans la plupart des apps : utilise ses graisses pour la hiérarchie.
2. Pour **deux** polices, une pour les titres et une pour le texte, qui
   **contrastent** (serif + sans serif). Deux polices très proches donnent
   l'impression d'une erreur.
3. Vérifie les **caractères accentués** (é, è, à, ç, ô) et les chiffres.
4. Teste en **petite taille** sur un vrai téléphone.
5. La police système (Roboto sur Android, SF Pro sur iOS) est toujours un choix
   valable : c'est le plus lisible et le plus familier, et il n'y a rien à
   télécharger.

## 6. Le texte agrandi par l'utilisateur

Dans les réglages du téléphone, on peut agrandir le texte (jusqu'à 200 % sur
Android récent). Flutter applique ce facteur via `MediaQuery.textScalerOf(context)`.

**Il ne faut pas bloquer ce réglage.** C'est un besoin réel : malvoyance,
fatigue, âge. Il faut donc concevoir des interfaces qui **tiennent** quand le
texte grossit :

- pas de hauteur fixe sur un conteneur de texte ;
- des lignes qui peuvent passer à la ligne (`Row` → `Wrap` si nécessaire) ;
- `maxLines` + `overflow: TextOverflow.ellipsis` pour les titres de liste.

On testera cela en D12 et D15.

## 7. Typographie dans Flutter

### 7.1 Utiliser l'échelle du thème

```dart
import 'package:flutter/material.dart';

class ExempleTypo extends StatelessWidget {
  const ExempleTypo({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Riz blanc 5 kg', style: t.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Vakinankaratra · Récolte 2026',
            style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Text(
            '12 500 Ar',
            style: t.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Riz blanc de qualité supérieure, cultivé sur les hautes terres. '
            'Grain long, cuisson rapide.',
            style: t.bodyLarge,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
```

### 7.2 Intégrer une police dans le projet (méthode recommandée)

1. Télécharge les fichiers `.ttf` (par exemple Inter : Regular, Medium, Bold)
   depuis https://fonts.google.com et place-les dans `assets/fonts/`.
2. Déclare-les dans `pubspec.yaml` :

```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

3. Applique-la à tout le thème :

```dart
import 'package:flutter/material.dart';

final themeClair = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00897B)),
  fontFamily: 'Inter', // toute l'échelle M3 utilise désormais Inter
);
```

Alternative : le package `google_fonts` télécharge les polices à l'exécution.
C'est pratique pour essayer, mais il faut du réseau au premier lancement.
Pour une app en production, **embarque les fichiers** (méthode ci-dessus), ou
configure `google_fonts` pour utiliser les fichiers locaux. Vérifie la version
actuelle du package sur https://pub.dev/packages/google_fonts avant de l'ajouter.

### 7.3 Modifier l'échelle globalement

```dart
import 'package:flutter/material.dart';

ThemeData themeAvecTitresSerres() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00897B)),
  );
  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    ),
  );
}
```

On modifie l'échelle **dans le thème**, une seule fois. Les écrans continuent
d'écrire `t.headlineSmall` et récupèrent la modification automatiquement.

## 8. Erreurs fréquentes

- `fontSize: 17` écrit en dur dans les widgets.
- Plus de 2 polices dans l'app.
- Texte courant en dessous de 14 px.
- Gris clair + petite taille + graisse légère : illisible.
- Bloquer l'agrandissement du texte (`textScaler: TextScaler.noScaling`) pour
  « protéger » la mise en page.
- Paragraphes justifiés ou centrés.
- Oublier de déclarer les graisses dans `pubspec.yaml`, ce qui produit un faux
  gras généré par le moteur.

## 9. Questions de révision

1. Quels sont les 5 rôles de l'échelle M3 ? Lequel utiliser pour le titre d'une carte ?
2. Quel interlignage pour un paragraphe ? Pour un titre ? Pourquoi la différence ?
3. Pourquoi éviter la justification sur mobile ?
4. Qu'apportent les chiffres tabulaires ?
5. Pourquoi ne faut-il pas désactiver l'agrandissement du texte ?
6. Pourquoi embarquer les polices plutôt que les télécharger à l'exécution ?

## Pour aller plus loin

- Material 3, *Typography* : https://m3.material.io/styles/typography/type-scale-tokens
- Flutter, *Use a custom font* : https://docs.flutter.dev/cookbook/design/fonts
- *Practical Typography* de Matthew Butterick : https://practicaltypography.com/
