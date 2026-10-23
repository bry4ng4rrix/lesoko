# Semaine 1 · Jour 4 : la boucle `while`, `break` et `continue`

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- répéter des instructions tant qu'une condition est vraie, avec `while` ;
- utiliser un **compteur** et un **accumulateur** ;
- éviter et interrompre une boucle infinie ;
- redemander une saisie tant qu'elle est invalide ;
- sortir d'une boucle avec `break` et passer au tour suivant avec `continue` ;
- suivre l'exécution d'une boucle **à la main**, dans un tableau.

## 2. Prérequis

- Jour 3 : conditions, `and`, `or`, `not`.

---

## 3. Cours

### 3.1 Le problème : répéter

Pour afficher les nombres de 1 à 5, on peut écrire cinq `print`. Pour 1 à 1000, ou pour « tant que l'utilisateur n'a pas tapé un nombre valide », c'est impossible. Une **boucle** répète un bloc d'instructions.

**Analogie :** « Tant que la casserole n'est pas pleine, ajoute un verre d'eau. » Avant chaque verre, on regarde la casserole.

### 3.2 Syntaxe de `while`

```python
compteur = 1                # 1. initialisation

while compteur <= 5:        # 2. condition, testée AVANT chaque tour
    print(compteur)
    compteur = compteur + 1 # 3. mise à jour : sans elle, boucle infinie

print("Terminé")
```

Résultat :

```
1
2
3
4
5
Terminé
```

**Trace d'exécution** : la méthode pour comprendre une boucle consiste à remplir un tableau tour par tour.

| Tour | `compteur` avant | `compteur <= 5` | Affiche | `compteur` après |
|---|---|---|---|---|
| 1 | 1 | True | 1 | 2 |
| 2 | 2 | True | 2 | 3 |
| 3 | 3 | True | 3 | 4 |
| 4 | 4 | True | 4 | 5 |
| 5 | 5 | True | 5 | 6 |
| — | 6 | **False** | (sortie) | — |

Toute boucle `while` correcte a besoin de trois éléments : une **initialisation**, une **condition** et une **mise à jour** qui finit par rendre la condition fausse.

### 3.3 Affectation augmentée

`compteur = compteur + 1` est si fréquent qu'il existe un raccourci :

```python
compteur += 1     # compteur = compteur + 1
total -= 500      # total = total - 500
prix *= 2         # prix = prix * 2
```

### 3.4 Compteur et accumulateur

- Un **compteur** compte des événements (`nb_essais += 1`).
- Un **accumulateur** additionne des valeurs (`total += montant`).

```python
# Somme des nombres de 1 à 100
total = 0          # l'accumulateur commence à l'élément neutre de l'addition
n = 1
while n <= 100:
    total += n
    n += 1
print(total)       # 5050
```

Pour un produit, l'accumulateur commence à `1`, pas à `0`. Pourquoi ? Teste avec `0` pour voir.

### 3.5 Boucle infinie

```python
n = 1
while n <= 5:
    print(n)
    # oubli de n += 1 → affiche 1 à l'infini
```

Pour arrêter un programme bloqué dans le terminal : **Ctrl+C**. Python affiche alors `KeyboardInterrupt`.

### 3.6 Boucle pilotée par l'utilisateur : la valeur sentinelle

On ne sait pas combien de tours seront nécessaires. On s'arrête quand l'utilisateur tape une valeur spéciale, la **sentinelle**.

```python
total = 0
saisie = input("Montant (vide pour finir) : ")

while saisie != "":
    total += float(saisie)
    saisie = input("Montant (vide pour finir) : ")

print(f"Total : {total}")
```

La saisie est lue **une première fois avant** la boucle, puis **à la fin** de chaque tour.

### 3.7 `break` : sortir immédiatement

`while True` crée une boucle volontairement infinie, dont on sort avec `break`. Ce schéma évite de dupliquer le `input` :

```python
total = 0
while True:
    saisie = input("Montant (vide pour finir) : ")
    if saisie == "":
        break           # sort de la boucle, on passe directement après
    total += float(saisie)

print(f"Total : {total}")
```

### 3.8 `continue` : passer au tour suivant

`continue` saute la fin du bloc et revient au test de la condition.

```python
n = 0
while n < 10:
    n += 1
    if n % 3 == 0:
        continue        # on ignore les multiples de 3
    print(n, end=" ")
# 1 2 4 5 7 8 10
```

Attention : si `n += 1` était placé **après** le `continue`, on aurait une boucle infinie dès `n == 3`. Vérifie-le en traçant à la main.

### 3.9 Valider une saisie

`int("abc")` plante. Avant de convertir, on peut vérifier que la chaîne ne contient que des chiffres avec la méthode `.isdigit()` :

```python
"42".isdigit()    # True
"4a".isdigit()    # False
"-5".isdigit()    # False : le signe n'est pas un chiffre
"".isdigit()      # False
"3.5".isdigit()   # False
```

Schéma de validation :

```python
while True:
    saisie = input("Âge (entier positif) : ")
    if saisie.isdigit():
        age = int(saisie)
        break
    print("Saisie invalide, recommence.")

print(f"Âge enregistré : {age}")
```

`.isdigit()` ne gère ni les négatifs ni les décimaux. En semaine 3, nous verrons `try`/`except`, plus général. Pour l'instant, ce schéma suffit pour les entiers positifs.

---

## 4. Exemples commentés

### Exemple A — Deviner un nombre

```python
# Le programme connaît le nombre secret, l'utilisateur doit le trouver
SECRET = 42
essais = 0

while True:
    proposition = int(input("Ta proposition : "))
    essais += 1

    if proposition < SECRET:
        print("Plus grand !")
    elif proposition > SECRET:
        print("Plus petit !")
    else:
        print(f"Bravo, trouvé en {essais} essais.")
        break
```

- `essais` est un compteur, incrémenté **à chaque** proposition.
- Le `break` est placé dans la branche de victoire : c'est la **seule** sortie de la boucle.
- Pour que le nombre soit aléatoire, on peut utiliser `import random` puis `SECRET = random.randint(1, 100)`. Les imports seront détaillés en semaine 5.

### Exemple B — Nombre de chiffres d'un entier

```python
n = 75012
nb_chiffres = 0
while n > 0:
    n //= 10          # on retire le dernier chiffre
    nb_chiffres += 1
print(nb_chiffres)    # 5
```

Trace : 75012 → 7501 → 750 → 75 → 7 → 0, soit 5 tours. Cas limite : avec `n = 0`, on obtient 0 chiffre, ce qui est faux (0 a 1 chiffre). C'est typiquement le genre de cas qu'il faut tester.

---

## 5. Erreurs courantes

| Problème | Symptôme | Correction |
|---|---|---|
| Oubli de la mise à jour | Boucle infinie | Vérifier que la condition peut devenir fausse |
| Condition mal bornée (`<` au lieu de `<=`) | Un tour de trop ou de moins | Tracer le premier et le dernier tour |
| Accumulateur initialisé **dans** la boucle | Il est remis à zéro à chaque tour | Initialiser **avant** la boucle |
| `continue` avant la mise à jour | Boucle infinie | Mettre à jour avant le `continue` |
| `int(input())` sans validation | `ValueError` sur saisie invalide | Valider avec `.isdigit()` |
| Variable créée seulement dans la boucle, utilisée après | `NameError` si la boucle ne tourne jamais | Initialiser avant la boucle |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-01/jour-04/`

**Exercice 1 — Compte à rebours (`ex1_rebours.py`).** Avec `while`, affiche `10 9 8 … 1 Décollage !` sur une seule ligne.

**Exercice 2 — Trace (`ex2_trace.txt`).** Sans exécuter, remplis le tableau de trace (valeurs de `a` et `b` à chaque tour) et donne l'affichage final :

```python
a = 1
b = 0
while a < 20:
    b += a
    a *= 3
print(a, b)
```

**Exercice 3 — Table de multiplication (`ex3_table.py`).** Demande un entier et affiche sa table de 1 à 10 au format `7 x 3 = 21`.

## 7. Exercices intermédiaires

**Exercice 4 — Saisie robuste (`ex4_saisie.py`).** Demande une note entière entre 0 et 20. Tant que la saisie n'est pas un entier **ou** sort de l'intervalle, affiche un message d'erreur **précis** (« ce n'est pas un nombre » ou « hors de l'intervalle ») et redemande.

**Exercice 5 — Statistiques (`ex5_stats.py`).** L'utilisateur saisit des notes entières positives, une par une, et termine avec `fin`. Les saisies invalides sont ignorées avec un message. À la fin, affiche le nombre de notes, la somme, la moyenne avec 2 décimales, la plus petite et la plus grande **sans `min()`, `max()` ni liste**. Que se passe-t-il si l'utilisateur tape `fin` immédiatement ? Gère ce cas.

**Exercice 6 — Somme des chiffres (`ex6_chiffres.py`).** Pour un entier positif saisi, calcule la somme de ses chiffres **sans le convertir en `str`** : `1234` donne `10`. Indice : `% 10` donne le dernier chiffre.

## 8. Défi — Distributeur de billets (`defi_distributeur.py`)

Le solde initial est une constante `SOLDE_INITIAL = 50000`. Le programme affiche un menu en boucle :

```
1. Consulter le solde
2. Retirer
3. Déposer
4. Quitter
```

Règles :
- un retrait doit être un multiple de 1000, strictement positif et inférieur ou égal au solde ;
- un dépôt doit être strictement positif ;
- au maximum **3 saisies de montant invalides consécutives** : à la troisième, le programme affiche « Carte bloquée » et s'arrête ;
- à la sortie, affiche le nombre d'opérations réussies.

Prépare d'abord un pseudocode et une liste de scénarios de test.

## 8 bis. Corriger un bug (`bug_04.py`)

Ce programme doit calculer la moyenne des nombres saisis jusqu'à ce que l'utilisateur tape `0`. Exécute-le et trouve ses trois défauts. L'un d'eux n'apparaît que dans un cas particulier.

```python
nombre = int(input("Nombre (0 pour finir) : "))
while nombre != 0:
    somme = 0
    compte = 0
    somme += nombre
    compte += 1
nombre = int(input("Nombre (0 pour finir) : "))
print("Moyenne :", somme / compte)
```

## 9. Critères de réussite

- [ ] Chacune de mes boucles a une initialisation, une condition et une mise à jour clairement identifiables.
- [ ] Je sais tracer une boucle sur papier, tour par tour.
- [ ] Je sais arrêter un programme bloqué (Ctrl+C).
- [ ] Mes saisies ne font plus planter le programme.
- [ ] J'ai testé le cas « aucune donnée saisie ».

## 10. Questions de révision

1. Quels sont les trois éléments nécessaires à une boucle `while` qui se termine ?
2. Quelle est la différence entre `break` et `continue` ?
3. Pourquoi initialiser un accumulateur de produit à `1` et non à `0` ?
4. Quand préférer `while True` avec `break` plutôt qu'une condition dans le `while` ?

## 11. Bilan et préparation du jour 5

`while` répète tant qu'une condition est vraie : idéal quand on **ne connaît pas** le nombre de tours. Quand on le connaît (« 10 fois », « pour chaque lettre »), la boucle `for` est plus simple et plus sûre, car elle gère seule l'initialisation et la mise à jour. Ce sera le sujet du jour 5.
