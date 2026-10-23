# Exercice Flutter — Page de profil

Prérequis : avoir fait l'**exercice de design** (`DESIGN/TRAVAUX/s01_page_profil.md`).
Code sans wireframe = exercice non validé.

## 1. Créer le projet

```bash
cd PROJECTS
flutter create --org mg.formation --platforms=android,linux s01_premiere_page
cd s01_premiere_page
flutter run -d linux
```

Vérifie que l'application de démonstration (le compteur) s'affiche, puis
quitte avec `q`.

## 2. Énoncé

Dans `lib/main.dart`, remplace l'application de démonstration par ta **page de
profil**, conforme à ton wireframe :

- `MaterialApp` → `Scaffold` avec un `AppBar` titré « Profil » ;
- un avatar : `Icon(Icons.account_circle)` en grand ;
- ton nom, ton métier, ta ville, une présentation courte ;
- un bouton « Me contacter » (`FilledButton`). Pour l'instant, au clic, il
  affiche simplement un message dans le terminal avec `debugPrint`
  (pas `print` : dans un projet Flutter, l'analyseur le signale avec la règle
  `avoid_print`).

## 3. Widgets autorisés

`MaterialApp`, `Scaffold`, `AppBar`, `Center`, `Column`, `Padding`, `SizedBox`,
`Icon`, `Text`, `FilledButton`.

Cherche dans la documentation comment s'utilisent ceux que tu ne connais pas
encore (`Padding`, `FilledButton`) :
https://api.flutter.dev/flutter/widgets/Padding-class.html
https://api.flutter.dev/flutter/material/FilledButton-class.html

## 4. La hiérarchie vient du thème, pas de tailles écrites en dur

Pour donner de l'importance à un texte, n'écris **pas** `fontSize: 24`. Utilise
les styles du thème Material 3 :

```dart
Text(
  'Mon titre',
  style: Theme.of(context).textTheme.headlineSmall,
)
```

Styles disponibles, du plus grand au plus petit :
`displayLarge…Small`, `headlineLarge…Small`, `titleLarge…Small`,
`bodyLarge…Small`, `labelLarge…Small`.

Pour une couleur plus discrète (texte secondaire) :
`Theme.of(context).colorScheme.onSurfaceVariant`.

Pourquoi ? Si la typographie ou la palette change un jour, tout l'écran suit
automatiquement. C'est le début d'un **design system** (semaines 9 et 10).

Attention : `Theme.of(context)` n'est pas une valeur constante. Un widget qui
l'utilise ne peut pas être `const`.

## 5. Résultat attendu

- L'écran ressemble à ton wireframe : même ordre, même alignement.
- Le nom se remarque en premier, puis le métier. Le reste est plus discret.
- Les espacements sont réguliers : choisis des multiples de 8 (8, 16, 24, 32).
- Redimensionne la fenêtre à une taille de téléphone (environ 400 × 800) : rien
  ne doit déborder (pas de bandes jaunes et noires).
- `flutter analyze` → `No issues found!`
- Le clic sur le bouton affiche ton message dans le terminal.

## 6. À me rendre

1. Le contenu de `DESIGN/TRAVAUX/s01_page_profil.md`.
2. Le contenu de `lib/main.dart`.
3. Une capture d'écran (facultatif, mais utile pour comparer au wireframe).
4. Les difficultés rencontrées, même résolues.
