# Semaine 1 · Jour 5 : la boucle `for` et `range()`

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- parcourir une chaîne de caractères avec `for` ;
- générer des suites d'entiers avec `range()` et ses trois paramètres ;
- choisir entre `for` et `while` ;
- utiliser `break` et `continue` dans un `for` ;
- écrire des boucles imbriquées et compter leurs tours ;
- combiner boucles, conditions, compteurs et accumulateurs.

## 2. Prérequis

- Jour 4 : `while`, compteurs, accumulateurs, `break`, `continue`.

---

## 3. Cours

### 3.1 Le problème

Avec `while`, afficher les nombres de 1 à 10 demande trois lignes de gestion (initialiser, tester, incrémenter) et chacune peut contenir une erreur. Quand on sait à l'avance **sur quoi** on boucle, `for` s'occupe de tout.

**Analogie :** « Pour chaque invité de la liste, prépare une assiette. » On n'a pas à compter les invités soi-même.

### 3.2 `for` sur une chaîne

Une chaîne est une **séquence** de caractères. `for` prend chaque élément, dans l'ordre.

```python
mot = "Python"
for lettre in mot:
    print(lettre)
```

Résultat :

```
P
y
t
h
o
n
```

- `lettre` est la **variable de boucle** : à chaque tour, elle reçoit l'élément suivant. Tu choisis son nom.
- `in mot` désigne la séquence parcourue.
- La boucle s'arrête seule quand il n'y a plus d'éléments.

### 3.3 `range()`

`range` produit une suite d'entiers **sans les stocker tous en mémoire**.

| Appel | Valeurs produites | Règle |
|---|---|---|
| `range(5)` | 0, 1, 2, 3, 4 | de 0 jusqu'à 5 **exclu** |
| `range(2, 6)` | 2, 3, 4, 5 | de début inclus à fin exclue |
| `range(0, 10, 3)` | 0, 3, 6, 9 | avec un pas de 3 |
| `range(5, 0, -1)` | 5, 4, 3, 2, 1 | pas négatif : on descend |
| `range(5, 2)` | (rien) | début ≥ fin avec un pas positif |

Pourquoi la fin est-elle **exclue** ? Parce que `range(n)` produit alors exactement `n` valeurs, et `range(a, b)` produit `b - a` valeurs. Retiens-le, car c'est la même règle pour les tranches en semaine 2.

Pour **voir** les valeurs, on convertit en liste : `list(range(2, 6))` donne `[2, 3, 4, 5]`.

```python
for i in range(1, 11):
    print(f"7 x {i} = {7 * i}")
```

Si la variable de boucle ne sert à rien, la convention est de la nommer `_` :

```python
for _ in range(3):
    print("Bip")
```

### 3.4 `for` ou `while` ?

| Situation | Choix |
|---|---|
| Parcourir une séquence (texte, et bientôt une liste) | `for` |
| Répéter un nombre de fois **connu** | `for ... in range(...)` |
| Répéter jusqu'à un événement (saisie valide, nombre trouvé) | `while` |

### 3.5 `break` et `continue` dans un `for`

```python
# Chercher le premier chiffre dans un texte
texte = "Code postal : 101 Antananarivo"
for caractere in texte:
    if caractere.isdigit():
        print(f"Premier chiffre trouvé : {caractere}")
        break
```

```python
# Compter les voyelles en ignorant les espaces
phrase = "le python est clair"
nb_voyelles = 0
for c in phrase:
    if c == " ":
        continue
    if c in "aeiouy":
        nb_voyelles += 1
print(nb_voyelles)   # 6
```

`c in "aeiouy"` vérifie si le caractère apparaît dans la chaîne des voyelles. C'est plus court qu'une série de `or`.

### 3.6 La clause `else` d'une boucle

Une boucle peut avoir un `else`, exécuté **seulement si la boucle n'a pas été interrompue par `break`**. C'est pratique pour une recherche :

```python
n = 29
for diviseur in range(2, n):
    if n % diviseur == 0:
        print(f"{n} n'est pas premier (divisible par {diviseur})")
        break
else:
    print(f"{n} est premier")
```

C'est une construction peu connue, et donc parfois peu lisible. Tu dois savoir la lire. Tu peux aussi utiliser à la place une variable booléenne `trouve = False`.

### 3.7 Boucles imbriquées

```python
for ligne in range(1, 4):
    for colonne in range(1, 5):
        print(ligne * colonne, end="\t")
    print()   # retour à la ligne à la fin de chaque ligne
```

Résultat :

```
1	2	3	4
2	4	6	8
3	6	9	12
```

La boucle interne s'exécute **entièrement** à chaque tour de la boucle externe : 3 × 4 = 12 affichages. Avec deux boucles de `n` tours, on obtient `n × n` tours. Pour `n = 1000`, cela fait un million : c'est la notion de complexité que nous verrons en semaine 6.

`break` dans la boucle interne ne sort **que** de la boucle interne.

### 3.8 `enumerate()` : connaître la position

```python
for position, lettre in enumerate("abc"):
    print(position, lettre)
# 0 a
# 1 b
# 2 c
```

`enumerate` fournit à chaque tour un couple (position, élément). Nous le réutiliserons beaucoup avec les listes.

---

## 4. Exemples commentés

### Exemple A — Analyse d'un mot de passe

```python
mot_de_passe = input("Mot de passe : ")

nb_chiffres = 0
nb_majuscules = 0
for c in mot_de_passe:
    if c.isdigit():
        nb_chiffres += 1
    elif c.isupper():
        nb_majuscules += 1

assez_long = len(mot_de_passe) >= 8
robuste = assez_long and nb_chiffres >= 1 and nb_majuscules >= 1

print(f"Longueur : {len(mot_de_passe)}, chiffres : {nb_chiffres}, majuscules : {nb_majuscules}")
print("Robuste" if robuste else "Trop faible")
```

Avec `Secret2026` :

```
Longueur : 10, chiffres : 4, majuscules : 1
Robuste
```

- Deux compteurs sont initialisés **avant** la boucle.
- `.isupper()` est vrai pour une majuscule.
- L'évaluation se fait **après** la boucle, une fois tous les caractères comptés.

### Exemple B — Triangle d'étoiles

```python
hauteur = 4
for i in range(1, hauteur + 1):
    print("*" * i)
```

```
*
**
***
****
```

`hauteur + 1` est nécessaire, car la fin de `range` est exclue.

---

## 5. Erreurs courantes

| Problème | Exemple | Explication |
|---|---|---|
| Fin de `range` incluse par erreur | `range(1, 10)` pour aller de 1 à 10 | S'arrête à 9 : écrire `range(1, 11)` |
| Pas négatif oublié | `range(10, 0)` | Ne produit rien : écrire `range(10, 0, -1)` |
| `for i in 10:` | `TypeError: 'int' object is not iterable` | Un entier n'est pas une séquence : utiliser `range(10)` |
| Modifier la variable de boucle | `i += 2` dans le bloc | Sans effet sur le tour suivant : `for` réaffecte `i` |
| Accumulateur dans la boucle interne | Remis à zéro trop souvent | Bien choisir à quel niveau l'initialiser |
| `print()` mal indenté dans une boucle imbriquée | Affichage sur une seule ligne, ou une ligne par valeur | L'indentation indique à quelle boucle il appartient |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-01/jour-05/`

**Exercice 1 — `range` (`ex1_range.txt`).** Pour chaque appel, écris les valeurs produites sans exécuter, puis vérifie avec `list(...)` : `range(4)`, `range(3, 8)`, `range(1, 10, 2)`, `range(10, 0, -3)`, `range(0)`, `range(5, 5)`, `range(-3, 3)`.

**Exercice 2 — Somme et pairs (`ex2_somme.py`).** Avec `for`, calcule la somme des entiers de 1 à 100, puis la somme des nombres pairs de 1 à 100 **sans `if`**.

**Exercice 3 — Lettres (`ex3_lettres.py`).** Demande un mot et affiche chaque lettre avec sa position, à partir de 1 : `1 : P`, `2 : y`, etc.

## 7. Exercices intermédiaires

**Exercice 4 — Inverser (`ex4_inverse.py`).** Demande un mot et construis son inverse **avec une boucle**, sans `[::-1]` (que nous verrons en semaine 2). Indique ensuite si le mot est un palindrome (`kayak`, `radar`).

**Exercice 5 — FizzBuzz (`ex5_fizzbuzz.py`).** De 1 à 30 : affiche `Fizz` pour les multiples de 3, `Buzz` pour ceux de 5, `FizzBuzz` pour ceux de 15, et le nombre sinon. Réfléchis à l'ordre des conditions.

**Exercice 6 — Nombres premiers (`ex6_premiers.py`).** Affiche tous les nombres premiers entre 2 et 100. Combien y en a-t-il ? Combien de divisions ton programme effectue-t-il au total ? Ajoute un compteur pour le mesurer, puis essaie de réduire ce nombre. Indice : il est inutile de tester les diviseurs au-delà de la racine carrée.

## 8. Défi — Sapin (`defi_sapin.py`)

Demande une hauteur `h` (entier de 1 à 15, saisie validée) et affiche un sapin centré, avec un tronc :

```
Hauteur : 4
   *
  ***
 *****
*******
   |
```

Pour chaque ligne, cherche d'abord la **formule** du nombre d'espaces et d'étoiles en fonction du numéro de ligne. Écris-la sous forme de tableau avant de coder.

## 8 bis. Corriger un bug (`bug_05.py`)

Ce code doit compter le nombre de mots dans une phrase, les mots étant séparés par un seul espace. Il contient deux bugs : un qui empêche l'exécution et un qui donne un résultat faux. Pour quelles phrases le résultat est-il faux ?

```python
phrase = input("Phrase : ")
nb_mots = 0
for c in range(phrase):
    if c == " ":
        nb_mots += 1
print("Nombre de mots :", nb_mots)
```

Une fois le premier bug corrigé, pense aux cas limites : phrase vide, espace au début, deux espaces consécutifs. Ton code doit au moins gérer la phrase vide.

## 9. Critères de réussite

- [ ] Je prédis sans erreur les valeurs produites par n'importe quel `range`.
- [ ] Je choisis entre `for` et `while` et je sais justifier ce choix.
- [ ] Je sais combien de tours fait une double boucle.
- [ ] Mes compteurs sont initialisés au bon niveau d'imbrication.

## 10. Questions de révision

1. Pourquoi `range(1, 10)` ne contient-il pas 10 ? Quel avantage y a-t-il à exclure la borne de fin ?
2. Quand le `else` d'une boucle `for` s'exécute-t-il ?
3. Combien de fois `print` est-il appelé dans `for i in range(3): for j in range(i): print(i, j)` ? Trace-le.
4. Pourquoi `for i in 10:` provoque-t-il une erreur ?

## 11. Bilan et préparation du jour 6

Tu as maintenant les briques fondamentales de tout programme : **séquence** (les instructions l'une après l'autre), **choix** (`if`) et **répétition** (`while`, `for`). Le jour 6 est consacré à les assembler dans un projet complet, la calculatrice en ligne de commande, puis à une évaluation de la semaine. Relis tes notes des jours 1 à 5 et refais les exercices qui t'ont posé problème.
