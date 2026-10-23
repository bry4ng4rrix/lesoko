# Semaine 1 — Séance 1, partie 2 : première application Flutter

Durée prévue : 1 h 30 à 2 h. À faire **après** la partie 1 (bases de Dart).

> Cette partie est un **premier aperçu**. Le but n'est pas encore de maîtriser
> Flutter (ce sera le travail des semaines 5 et 6), mais de comprendre comment
> une application est structurée et de voir tout de suite à quoi sert le Dart
> appris en partie 1.

## 1. Objectifs pédagogiques

À la fin de cette partie, tu sais :

- créer un projet Flutter et lancer l'application sur ton poste Linux ;
- reconnaître les dossiers importants d'un projet ;
- expliquer le rôle de `runApp`, `MaterialApp`, `Scaffold` et `build` ;
- expliquer ce qu'est un widget et ce qu'est l'arbre des widgets ;
- utiliser le hot reload ;
- **définir ce qu'un écran doit accomplir avant de le coder**.

## 2. Concepts théoriques

### 2.1 Rappel : le rôle du SDK Flutter

Le SDK Flutter regroupe :

- **le framework**, c'est-à-dire les widgets (`Text`, `Column`, `Scaffold`…) écrits en Dart ;
- **le moteur**, qui dessine chaque pixel de l'écran. Flutter n'utilise pas
  les boutons natifs d'Android ou d'iOS : il dessine ses propres composants. C'est
  pour ça qu'une app Flutter a le même rendu partout ;
- **l'outil `flutter`**, qui crée, lance, teste et compile les projets ;
- **les « embedders »** : le code natif minimal (dossiers `android/`, `ios/`,
  `linux/`…) qui ouvre une fenêtre ou une activité et y affiche le moteur ;
- **son propre SDK Dart**.

### 2.2 Vérifier l'environnement

```bash
flutter doctor        # diagnostic complet
flutter doctor -v     # même chose, avec les détails
flutter devices       # appareils sur lesquels on peut lancer une app
flutter emulators     # émulateurs Android disponibles
```

Résultat sur ta machine (le 23/10/2026) :

- un seul appareil, **Linux (desktop)** ;
- **aucun émulateur Android** : le SDK Android est présent, mais aucune image
  système n'est téléchargée.

Pour cette partie, on lance l'application **sur le bureau Linux**. Elle s'ouvre
dans une fenêtre que tu peux redimensionner à une taille de téléphone. On créera
l'émulateur Android en semaine 5 (voir l'annexe si tu veux le faire avant).

### 2.3 Créer et lancer une application

```bash
cd PROJECTS
flutter create --org mg.formation --platforms=android,linux s01_premiere_page
cd s01_premiere_page
flutter run -d linux
```

- `--org` sert à construire l'identifiant unique de l'app
  (`mg.formation.s01_premiere_page`). Il est utilisé par Android et par le Play Store.
- `--platforms` limite les dossiers générés aux plateformes utiles.
- `-d linux` choisit l'appareil cible.

Pendant que `flutter run` tourne, le terminal accepte des touches :

| Touche | Effet |
|---|---|
| `r` | **Hot reload** : injecte le code modifié et garde l'état de l'app. En moins d'une seconde. |
| `R` | **Hot restart** : relance l'app depuis `main()` et perd l'état. |
| `q` | Quitte l'application. |

Dans VS Code, la touche F5 (ou « Run and Debug ») fait la même chose, et la
sauvegarde du fichier déclenche le hot reload automatiquement.

> Piège : le hot reload ne réexécute **pas** `main()`. Si tu modifies `main()`
> ou si tu renommes la classe passée à `runApp`, fais un hot restart (`R`).

### 2.4 La structure d'un projet

```
s01_premiere_page/
├── lib/
│   └── main.dart          ← TON code. 95 % du travail se fait dans lib/
├── test/
│   └── widget_test.dart   ← tests (semaine 19)
├── pubspec.yaml           ← nom, version, dépendances, polices, images
├── analysis_options.yaml  ← règles de l'analyseur (flutter analyze)
├── android/               ← projet Android natif (permissions, icône, signature)
└── linux/                 ← projet Linux natif
```

### 2.5 Ce qu'est un widget

En Flutter, **tout ce qui est affiché est un widget** : un texte, une icône, un
espacement, une marge, une colonne, l'écran entier, l'application elle-même.

Un widget est une **description** de ce qu'une partie de l'interface doit être.
Ce n'est pas l'élément dessiné lui-même. Flutter lit cette description et
s'occupe de dessiner.

Les widgets s'**emboîtent** : chacun en contient un (`child`) ou plusieurs
(`children`). On obtient un **arbre de widgets** :

```
MonApplication
└── MaterialApp            thème, titre, page d'accueil
    └── PageAccueil
        └── Scaffold       structure d'un écran Material
            ├── AppBar
            │   └── Text "Accueil"
            └── Center     centre son enfant
                └── Column empile ses enfants verticalement
                    ├── Icon
                    ├── SizedBox   espace vide de 16
                    └── Text "Bienvenue…"
```

Idée clé : **on compose** de petits widgets simples pour obtenir une interface.
`Center` ne fait que centrer, `SizedBox` ne fait qu'un espace, `Padding` ne fait
qu'une marge. Ce n'est pas comme en CSS où une même boîte porte toutes les propriétés.

Deux familles (détaillées en semaine 5) :

- **`StatelessWidget`** : son affichage dépend uniquement de ce qu'on lui donne.
  Il ne change pas tout seul.
- **`StatefulWidget`** : il garde un état qui peut évoluer (un compteur, une case
  cochée…) et se redessine quand cet état change.

## 3. Description de la maquette de l'exemple

Avant le code, voici **ce que l'écran doit accomplir**, comme le ferait un designer :

- **Utilisateur** : une personne qui ouvre l'app de stock pour la première fois.
- **But de l'écran** : confirmer qu'elle est au bon endroit.
- **Hiérarchie** : 1) une icône qui évoque le stock, reconnue en un coup d'œil,
  2) un message de bienvenue, 3) le titre de l'écran dans la barre du haut.

Wireframe textuel :

```
┌──────────────────────────┐
│ Accueil                  │  ← AppBar : où suis-je ?
├──────────────────────────┤
│                          │
│                          │
│          [📦]            │  ← icône : grande, attire l'œil en premier
│                          │  ← 16 px d'air : sépare sans éloigner
│  Bienvenue dans StockFacile │  ← message
│                          │
│                          │
└──────────────────────────┘
```

Pourquoi centrer ? Il y a un seul message et aucune action : le centre est
l'endroit où l'œil se pose naturellement. Dès qu'un écran contient une liste ou
plusieurs actions, on alignera plutôt à gauche, parce qu'on lit de gauche à droite et de haut en bas.

## 4. Exemple Flutter commenté

Remplace le contenu de `lib/main.dart` par :

```dart
import 'package:flutter/material.dart';

/// 1. Point d'entrée, comme en Dart pur.
void main() {
  // runApp prend un widget et en fait la racine de l'écran.
  runApp(const MonApplication());
}

/// 2. La racine de l'application : configure le thème et la page d'accueil.
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ma première app',
      debugShowCheckedModeBanner: false, // retire le bandeau "DEBUG"
      theme: ThemeData(
        // Material 3 génère toute une palette à partir d'une seule couleur.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const PageAccueil(),
    );
  }
}

/// 3. Un écran : décrit CE QU'IL FAUT AFFICHER, pas comment le dessiner.
class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold = la structure standard d'un écran Material.
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // la colonne prend juste sa taille
          children: [
            Icon(Icons.inventory_2, size: 64),
            SizedBox(height: 16), // espace vertical de 16 pixels logiques
            Text('Bienvenue dans StockFacile'),
          ],
        ),
      ),
    );
  }
}
```

Code vérifié : `flutter analyze` ne signale rien, le test de widget passe et le
build Linux réussit (Flutter 3.44.8).

### Explication

- `import 'package:flutter/material.dart';` : donne accès à tous les widgets Material.
  Sans cette ligne, `Text`, `Scaffold`, etc. sont inconnus.
- `class MonApplication extends StatelessWidget` : on crée **notre propre widget**
  en héritant de `StatelessWidget`. On n'a pas encore vu les classes (semaine 3),
  donc retiens pour l'instant la forme : *une classe = un widget réutilisable*.
- `const MonApplication({super.key});` : le **constructeur**. `const` permet à
  Flutter de réutiliser le widget sans le reconstruire. Tu retrouves le `const`
  de la partie 1.
- `Widget build(BuildContext context)` : la méthode que Flutter appelle pour
  savoir quoi afficher. Elle **renvoie** un arbre de widgets.
  `context` indique où se trouve le widget dans l'arbre. Il sert par exemple à
  lire le thème : `Theme.of(context)`.
- `@override` : on redéfinit la méthode `build` héritée de `StatelessWidget`.
- `MaterialApp` : configure toute l'application (thème, langue, navigation).
  On n'en met **qu'un seul**, à la racine.
- `ColorScheme.fromSeed(seedColor: ...)` : Material 3 calcule une palette
  complète et harmonieuse (couleur primaire, de surface, d'erreur, de texte sur
  chaque fond…) à partir d'une seule couleur. On étudiera cela en semaine 9.
- `Scaffold` : fournit les emplacements standard d'un écran (`appBar`, `body`,
  `floatingActionButton`, `bottomNavigationBar`…).
- `child:` / `children: [...]` : un seul enfant ou une liste d'enfants.
- Les **virgules finales** (`,` après le dernier argument) permettent à
  `dart format` de bien indenter l'arbre. Ajoute-les systématiquement.

## 5. Erreurs fréquentes

| Erreur | Symptôme | Correction |
|---|---|---|
| Oubli de l'import | `Undefined name 'Text'` / `The method 'Scaffold' isn't defined` | `import 'package:flutter/material.dart';` |
| Parenthèses ou crochets mal fermés | Cascade d'erreurs incompréhensibles | Virgules finales + `dart format .` (ou Ctrl+Shift+I) |
| Modifier `main()` puis faire `r` | Aucun changement visible | Hot restart avec `R` |
| `flutter run` sans `-d` avec plusieurs appareils | Flutter demande de choisir | `flutter run -d linux` |
| `const` devant un widget qui contient une valeur non constante | `Invalid constant value` | Retirer `const` à ce niveau |
| Deux `MaterialApp` imbriqués | Thème ou navigation incohérents | Un seul `MaterialApp`, à la racine |
| `print(...)` dans une app Flutter | `flutter analyze` : `Don't invoke 'print' in production code` (`avoid_print`) | `debugPrint(...)` |

---

## 6. Exercice de design (à faire AVANT de coder)

Tu vas créer une **page de profil** : ta carte de visite de développeur, sur mobile.

Crée le fichier `DESIGN/TRAVAUX/s01_page_profil.md` et réponds à ces questions :

1. **Qui** regarde cet écran ? (une phrase)
2. **Que doit-il comprendre** en moins de 5 secondes ? (une phrase)
3. **Quelle action** peut-il faire ? (une seule)
4. **Contenu** : liste les informations affichées, **classées de la plus
   importante à la moins importante**.
5. **Wireframe textuel** : dessine l'écran avec des caractères, comme dans la
   section 3, et annote chaque élément.
6. **Justifie** en 2 ou 3 phrases : pourquoi cet ordre ? centré ou aligné à gauche ?

Contraintes de contenu : un avatar (une icône suffit), ton nom, ton métier
(ou celui que tu vises), ta ville, une courte présentation (2 lignes maximum)
et un bouton.

## 7. Exercice de programmation

Énoncé détaillé : [`EXERCISES/semaine-01/seance-01/flutter_page_profil.md`](../../EXERCISES/semaine-01/seance-01/flutter_page_profil.md)

En résumé : crée le projet `PROJECTS/s01_premiere_page`, puis code la page de
profil **conforme à ton wireframe**.

## 8. Défi sans solution immédiate

Une fois la page faite :

1. Change `seedColor` pour 3 couleurs différentes. Note ce qui change et ce
   qui ne change pas. Fais une capture pour chaque version.
2. Fais en sorte que l'app suive le **mode sombre** du système.
   Indice de recherche : dans `MaterialApp`, regarde les paramètres `darkTheme`
   et `themeMode`, et le paramètre `brightness` de `ColorScheme.fromSeed`.
   Documentation : https://api.flutter.dev/flutter/material/MaterialApp-class.html
3. Explique en 2 phrases pourquoi le texte reste lisible dans les deux modes
   alors que tu n'as choisi aucune couleur de texte.

## 9. Critères de réussite

- `DESIGN/TRAVAUX/s01_page_profil.md` existe et chaque choix est justifié.
- L'application se lance avec `flutter run -d linux`.
- L'écran respecte l'ordre défini dans ton wireframe.
- `flutter analyze` affiche `No issues found!`.
- Aucune couleur ni taille de police écrite en dur : tout vient du thème.
- Tu sais expliquer chaque widget de ton arbre.

## 10. Questions de révision

1. Que fait `runApp`, et que se passe-t-il si on ne l'appelle pas ?
2. Quelle est la différence entre hot reload et hot restart ? Donne un cas où le hot reload ne suffit pas.
3. Pourquoi dit-on qu'un widget est une « description » ?
4. Dessine l'arbre de widgets de ta page de profil.
5. Pourquoi faut-il définir le but d'un écran avant d'écrire ses widgets ?

---

## Annexe — Créer un émulateur Android (facultatif, prévu en semaine 5)

Commandes **non exécutées sur ta machine**. Le téléchargement fait environ 1,5 Go.
L'émulateur a besoin de la virtualisation KVM.

```bash
# Vérifier KVM (doit afficher /dev/kvm)
ls /dev/kvm

# Télécharger une image système (Android 16 / API 36)
~/Android/Sdk/cmdline-tools/latest/bin/sdkmanager "emulator" "system-images;android-36;google_apis;x86_64"

# Créer un appareil virtuel
~/Android/Sdk/cmdline-tools/latest/bin/avdmanager create avd -n pixel -k "system-images;android-36;google_apis;x86_64" -d pixel_7

# Vérifier puis lancer
flutter emulators
flutter emulators --launch pixel
flutter run          # choisir l'émulateur
```

Autre solution : un téléphone Android réel, avec le **débogage USB** activé dans
les options pour développeurs.
