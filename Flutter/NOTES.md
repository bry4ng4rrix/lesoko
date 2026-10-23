# Notes — notions et erreurs à retenir

## Dart — bases

- Dart = langage ; Flutter = framework d'interface écrit en Dart. Flutter embarque son SDK Dart.
- Le programme démarre dans `void main()`. Chaque instruction finit par `;`.
- Choix du mot-clé : `const` (fixe, connu à la compilation) > `final` (affecté une fois) > `var` (change).
- `/` renvoie toujours un `double`.
- Interpolation : `$nom` pour une variable seule, `${...}` pour toute expression (`${nom.length}`).
- Les `String` sont immuables : `trim()`, `toUpperCase()`… renvoient une nouvelle chaîne.
- `toStringAsFixed(2)` : affichage avec 2 décimales (renvoie une `String`).

## Flutter — premiers repères

- Tout ce qui s'affiche est un widget ; un widget est une *description*, on compose de petits widgets.
- `main()` → `runApp(widget racine)` → un seul `MaterialApp` → un `Scaffold` par écran.
- `r` = hot reload (garde l'état), `R` = hot restart (repart de `main()`).
- Tailles de texte et couleurs : depuis le thème (`Theme.of(context).textTheme`, `.colorScheme`), jamais en dur.
- Dans une app Flutter : `debugPrint`, pas `print` (lint `avoid_print`).

## Design — premiers repères

- Avant de coder un écran : qui le regarde, que doit-il comprendre, quelle action ?
- Classer le contenu par importance, puis le placer dans cet ordre.
- Espacements en multiples de 8.

## Erreurs à retenir

_Complété au fil des corrections._
