# Semaine 1 — Séance 1 : Dart, Flutter et premières variables

Durée prévue : 2 h à 2 h 30.

## 1. Objectifs pédagogiques

À la fin de cette séance, tu sais :

- expliquer la différence entre Dart et Flutter ;
- dire à quoi servent le SDK Dart et le SDK Flutter ;
- écrire et exécuter un programme Dart depuis le terminal ;
- utiliser `main()`, `print()` et les commentaires ;
- déclarer des variables avec un type explicite, `var`, `final` et `const`, et choisir le bon ;
- utiliser les types `int`, `double`, `String` et `bool` ;
- construire des chaînes avec l'interpolation `$x` et `${expression}`.

## 2. Prérequis

- Savoir ouvrir un terminal et naviguer dans les dossiers (`cd`, `ls`).
- VS Code avec l'extension **Dart** (et **Flutter**, utile plus tard).
- Aucun prérequis en Dart.

---

## 3. Cours

### 3.1 Dart et Flutter : qui fait quoi ?

**Dart** est un **langage de programmation** créé par Google. Comme Python ou
JavaScript, il sert à écrire des programmes : scripts dans le terminal, serveurs,
outils en ligne de commande… et applications.

**Flutter** est un **framework** (une boîte à outils) écrit **en Dart**. Il
fournit tout ce qu'il faut pour dessiner des interfaces (boutons, listes,
formulaires, animations) et les faire tourner sur Android, iOS, le web, Linux,
Windows et macOS à partir d'un seul code.

Analogie : Dart est la **langue**, Flutter est un **kit de construction** dont le
mode d'emploi est écrit dans cette langue. Sans connaître la langue, tu peux
recopier les instructions, mais tu ne sauras pas les adapter ni comprendre une
erreur. C'est pour cela qu'on passe 4 semaines sur Dart avant Flutter.

| | Dart | Flutter |
|---|---|---|
| Nature | Langage | Framework d'interface |
| Sert à | Écrire toute la logique | Dessiner l'interface et l'animer |
| Fonctionne seul ? | Oui (terminal, serveur) | Non : a besoin de Dart |
| Exemple de commande | `dart run fichier.dart` | `flutter run` |

### 3.2 Le rôle des SDK

Un **SDK** (Software Development Kit) est l'ensemble des outils pour développer
avec une technologie.

- **SDK Dart** : le compilateur, la machine virtuelle qui exécute le code,
  la bibliothèque standard (`dart:core`, `dart:math`…), et l'outil `dart`
  (`dart run`, `dart analyze`, `dart format`, `dart test`, `dart pub`).
- **SDK Flutter** : les bibliothèques de widgets, le moteur de rendu, l'outil
  `flutter` (`flutter run`, `flutter doctor`, `flutter build`…) **et il embarque
  son propre SDK Dart**.

Conséquence pratique : en installant Flutter, tu as déjà Dart. Sur ta machine,
`which dart` renvoie `/home/garrix/.flutter/bin/dart`, donc le Dart utilisé est
celui de Flutter. C'est la bonne configuration : un seul Dart, toujours compatible
avec ta version de Flutter.

### 3.3 Ton environnement (vérifié le 23/10/2026)

| Élément | Résultat |
|---|---|
| Dart | 3.12.2 (stable) |
| Flutter | 3.44.8 |
| Android toolchain | OK (SDK 36.0.0) |
| Linux desktop | OK |
| Chrome | absent (pas gênant : on ne vise pas le web) |
| Canal Flutter | `[user-branch]` — Flutter est sur un tag git, pas sur le canal `stable` |

Le point « canal inconnu » n'empêche pas de travailler. Il deviendra gênant pour
mettre à jour Flutter (`flutter upgrade`). On le corrigera en semaine 5, avant
de créer la première application.

Commandes de vérification à connaître :

```bash
dart --version      # version de Dart
flutter --version   # version de Flutter et du Dart embarqué
flutter doctor      # diagnostic complet de l'environnement
which dart          # quel exécutable dart est utilisé
```

### 3.4 Le programme Dart minimal

```dart
void main() {
  print('Bonjour Dart');
}
```

- `void main()` : la **fonction principale**. Quand tu lances le programme, Dart
  cherche `main` et exécute son contenu, de haut en bas. Sans `main`, rien ne
  s'exécute (erreur).
- `void` : `main` ne renvoie aucune valeur.
- `{ ... }` : le **bloc** de la fonction.
- `print(...)` : affiche une valeur dans le terminal puis passe à la ligne.
- `;` : **chaque instruction se termine par un point-virgule**.

Exécution :

```bash
dart run bonjour.dart
```

> `dart run` compile puis exécute. Pour un seul fichier, `dart bonjour.dart`
> fonctionne aussi.

### 3.5 Les commentaires

```dart
// Commentaire sur une ligne

/* Commentaire
   sur plusieurs lignes */

/// Commentaire de documentation : placé au-dessus d'une fonction ou d'une classe,
/// il apparaît au survol dans VS Code.
```

Un bon commentaire explique **pourquoi**, pas ce que le code dit déjà.

### 3.6 Les variables

Une variable est une **boîte nommée** qui contient une valeur.

**Type explicite :**

```dart
String nom = 'Rija';
int age = 28;
```

**`var` (inférence de type) :** Dart déduit le type à partir de la valeur initiale.
Le type est ensuite **fixé**.

```dart
var ville = 'Antsirabe'; // ville est un String
ville = 'Mahajanga';     // OK
ville = 12;              // ERREUR : on ne peut pas mettre un int dans un String
```

**`final` :** la variable reçoit une valeur **une seule fois**, éventuellement
calculée pendant l'exécution.

```dart
final dateConnexion = DateTime.now(); // calculée à l'exécution
dateConnexion = DateTime.now();       // ERREUR : déjà affectée
```

**`const` :** la valeur doit être connue **au moment de la compilation**, avant
même que le programme tourne.

```dart
const tauxTva = 0.20;            // OK : littéral
const maintenant = DateTime.now(); // ERREUR : l'heure n'est connue qu'à l'exécution
```

**Comment choisir ?** Règle pratique, dans cet ordre :

1. La valeur est fixe et écrite en dur dans le code → `const`.
2. La valeur ne change plus une fois obtenue → `final`.
3. La valeur va changer → `var` (ou un type explicite).

Cette règle compte énormément en Flutter : `const` permet au framework de ne pas
reconstruire certains widgets, et `final` évite des modifications accidentelles.

### 3.7 Les types de base

| Type | Contient | Exemples |
|---|---|---|
| `int` | entiers | `0`, `-7`, `1500` |
| `double` | nombres à virgule | `3.14`, `-0.5`, `2.0` |
| `num` | `int` **ou** `double` | parent des deux |
| `String` | texte | `'Bonjour'`, `"Salut"` |
| `bool` | vrai ou faux | `true`, `false` |

Points importants :

- `double prix = 10;` est accepté (Dart convertit le littéral `10` en `10.0`).
- `int quantite = 2.5;` est **refusé** : un `int` ne peut pas contenir de virgule.
- L'opérateur `/` renvoie **toujours** un `double` : `10 / 2` vaut `5.0`.
- `valeur.runtimeType` affiche le type réel d'une valeur pendant l'exécution.

Null safety (vu en détail semaine 3) : par défaut, une variable **ne peut pas
contenir `null`**. `int age;` puis `print(age);` provoque une erreur : la variable
doit être initialisée avant d'être lue.

### 3.8 Les chaînes de caractères

**Guillemets** : simples ou doubles, c'est équivalent. Convention Dart :
guillemets **simples**.

```dart
var a = 'Bonjour';
var b = "L'application";  // doubles pour éviter d'échapper l'apostrophe
var c = 'L\'application'; // ou échapper avec \
```

**Interpolation** : insérer une valeur dans une chaîne.

```dart
var produit = 'Riz';
var stock = 40;
print('Produit : $produit, stock : $stock');          // nom simple → $
print('Stock après vente : ${stock - 5}');            // expression → ${}
print('Nom en majuscules : ${produit.toUpperCase()}'); // appel → ${}
```

Piège classique : `'$produit.length'` affiche `Riz.length` ! Dart n'interpole que
`produit`, puis écrit `.length` comme du texte. Il faut `'${produit.length}'`.

**Concaténation** avec `+` : possible entre deux `String` seulement.

```dart
print('Stock : ' + stock);            // ERREUR : String + int
print('Stock : ' + stock.toString()); // OK mais lourd
print('Stock : $stock');              // préférable
```

**Chaîne multiligne** : trois guillemets.

```dart
var fiche = '''
Produit : $produit
Stock   : $stock
''';
```

**Méthodes utiles** :

```dart
var texte = '  Flutter  ';
texte.length          // 11 (les espaces comptent)
texte.trim()          // 'Flutter'
texte.toUpperCase()   // '  FLUTTER  '
texte.toLowerCase()   // '  flutter  '
texte.contains('lut') // true
texte.trim().padRight(10, '.') // 'Flutter...'
```

Une `String` est **immuable** : `texte.trim()` ne modifie pas `texte`, elle
**renvoie une nouvelle chaîne**. Il faut l'utiliser ou la stocker :
`texte = texte.trim();`.

**Afficher un nombre avec 2 décimales** : `prix.toStringAsFixed(2)` renvoie
une `String` (`12.5` → `'12.50'`).

---

## 4. Exemple commenté complet

Fichier : [`exemples/s01_bases.dart`](exemples/s01_bases.dart)

```bash
dart run LESSONS/semaine-01/exemples/s01_bases.dart
```

Lis-le en entier, prédis la sortie de chaque `print`, puis exécute-le pour
vérifier. Ensuite, décommente une ligne marquée `ERREUR` et lis le message
d'erreur de Dart avant de la recommenter.

## 5. Parties importantes du code

- `final demarrage = DateTime.now();` → `final` et non `const`, car l'heure n'est
  connue qu'à l'exécution.
- `${prixMoyen * (1 + tauxTva)}` → accolades obligatoires dès qu'il y a un calcul.
- `brut.trim().toUpperCase()` → les méthodes s'**enchaînent** : chaque appel
  renvoie une nouvelle `String` sur laquelle on appelle la suivante.
- `(nombreProduits / 2).runtimeType` → `double`, même si 42 / 2 tombe juste.
- Observe `Démarrage : 15h5` si les minutes sont inférieures à 10 : c'est un
  défaut d'affichage. On saura le corriger en fin de séance (indice : `padLeft`).

## 6. Erreurs fréquentes

| Erreur | Symptôme | Correction |
|---|---|---|
| Oubli du `;` | `Expected to find ';'` | Ajouter `;` en fin d'instruction |
| Réaffecter une `final` | `The final variable 'x' can only be set once` | Utiliser `var` si la valeur doit changer |
| `const` avec une valeur d'exécution | `Const variables must be initialized with a constant value` | Utiliser `final` |
| `int x = 2.5;` | `A value of type 'double' can't be assigned to a variable of type 'int'` | Choisir `double` |
| `'Total : ' + 5` | `The argument type 'int' can't be assigned to the parameter type 'String'` | Interpolation `'Total : $total'` |
| `'$nom.length'` | Affiche `Rija.length` | `'${nom.length}'` |
| `'L'application'` | Chaîne coupée, erreur de syntaxe | `"L'application"` ou `'L\'application'` |
| `texte.trim();` sans stocker | Le texte n'a pas changé | `texte = texte.trim();` |
| `var x;` sans valeur | `x` devient `dynamic` : plus de vérification de type | Toujours initialiser ou typer |

Réflexe à prendre : **lire le message d'erreur en entier**. Dart indique le
fichier, la ligne, la colonne et presque toujours la cause.

---

## 7 à 9. Exercices

Les énoncés sont dans [`EXERCISES/semaine-01/seance-01/`](../../EXERCISES/semaine-01/seance-01/).
Chaque fichier contient l'énoncé et le résultat attendu. **Pas de solution.**

| # | Fichier | Niveau |
|---|---|---|
| 1 | `ex01_presentation.dart` | Facile |
| 2 | `ex02_final_const.dart` | Facile |
| 3 | `ex03_chaines.dart` | Facile |
| 4 | `ex04_fiche_produit.dart` | Intermédiaire |
| 5 | `ex05_prediction_types.dart` | Intermédiaire |
| D | `defi_carte_visite.dart` | Défi |
| B | `debug_01.dart` | Débogage |

Méthode de travail :

1. Lis l'énoncé.
2. Écris ta solution **sans copier-coller** depuis le cours.
3. Exécute : `dart run EXERCISES/semaine-01/seance-01/<fichier>.dart`.
4. Compare avec le résultat attendu.
5. Lance `dart analyze EXERCISES/` et corrige les avertissements.
6. Envoie-moi ton code (même s'il ne marche pas).

## 10. Critères de réussite

- Les 5 exercices s'exécutent et produisent la sortie attendue.
- `dart analyze EXERCISES/semaine-01/seance-01/` ne signale aucun problème
  (sauf `debug_01.dart` avant correction).
- Tu justifies chaque choix `var` / `final` / `const` en une phrase.
- Tu expliques chaque erreur de `debug_01.dart` avec tes propres mots.

## 11. Questions de révision

1. Quelle est la différence entre Dart et Flutter ? Peut-on utiliser Dart sans Flutter ? Et l'inverse ?
2. Quelle est la différence entre `final` et `const` ? Donne un exemple où seul `final` fonctionne.
3. Que vaut `10 / 4` et quel est son type ? Et `10 / 5` ?
4. Pourquoi `'$prenom.length'` n'affiche-t-il pas la longueur du prénom ?
5. Après `var nom = '  Ana  '; nom.trim(); print(nom.length);`, qu'est-ce qui s'affiche, et pourquoi ?

## 12. Bilan

À compléter après correction de tes réponses, dans `PROGRESSION.md`.
