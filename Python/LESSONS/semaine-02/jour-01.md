# Semaine 2 · Jour 1 : les listes

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- créer une liste et accéder à ses éléments par index (positif et négatif) ;
- extraire une partie de liste avec les **tranches** (*slices*) ;
- ajouter, modifier et supprimer des éléments ;
- parcourir une liste avec `for`, `enumerate` et `range(len(...))` ;
- utiliser `len`, `in`, `sum`, `min`, `max`, `sorted` et `.sort()` ;
- expliquer pourquoi `b = a` ne copie pas une liste.

## 2. Prérequis

- Semaine 1 complète, en particulier `for` et `range`.

---

## 3. Cours

### 3.1 Le problème

Pour mémoriser les notes de 30 étudiants, il faudrait 30 variables : `note1`, `note2`… Impossible de les parcourir avec une boucle ou d'en ajouter une 31ᵉ pendant l'exécution. Une **liste** range plusieurs valeurs **dans l'ordre**, sous un seul nom.

**Analogie :** une étagère avec des cases numérotées à partir de **0**. On peut ajouter des cases, en retirer, ou changer le contenu d'une case.

### 3.2 Créer une liste

```python
notes = [12, 15.5, 9, 18]
prenoms = ["Aina", "Rado", "Fara"]
vide = []
mixte = [1, "deux", 3.0, True]    # possible, mais rarement une bonne idée
```

- Les crochets `[ ]` délimitent la liste et les éléments sont séparés par des virgules.
- `len(notes)` vaut `4`.
- En pratique, une liste contient des éléments **du même genre** (que des notes, que des prénoms).

### 3.3 Indexation

```python
prenoms = ["Aina", "Rado", "Fara", "Tiana"]
#  index :    0       1       2       3
#  négatif : -4      -3      -2      -1

print(prenoms[0])     # Aina   (premier)
print(prenoms[2])     # Fara
print(prenoms[-1])    # Tiana  (dernier)
print(prenoms[-2])    # Fara   (avant-dernier)
print(prenoms[4])     # IndexError: list index out of range
```

Le premier élément a l'index 0, le dernier a l'index `len(liste) - 1`, ou plus simplement `-1`.

**Les chaînes s'indexent de la même façon** : `"Python"[0]` vaut `"P"` et `"Python"[-1]` vaut `"n"`.

### 3.4 Les tranches (slices)

`liste[debut:fin:pas]`, avec la même règle que `range` : `debut` est inclus, `fin` est exclue.

```python
n = [10, 20, 30, 40, 50, 60]
n[1:4]     # [20, 30, 40]
n[:3]      # [10, 20, 30]       depuis le début
n[3:]      # [40, 50, 60]       jusqu'à la fin
n[-2:]     # [50, 60]           les deux derniers
n[::2]     # [10, 30, 50]       un sur deux
n[::-1]    # [60, 50, 40, 30, 20, 10]   inversée
n[:]       # copie complète
```

Une tranche renvoie une **nouvelle liste**. Une tranche hors limites ne provoque pas d'erreur : `n[4:100]` donne `[50, 60]`.

Cela fonctionne aussi avec les chaînes : `"Bonjour"[:3]` vaut `"Bon"` et `"kayak"[::-1]` vaut `"kayak"`.

### 3.5 Modifier une liste

Une liste est **mutable** : on peut la modifier sur place.

```python
courses = ["riz", "lait"]

courses[1] = "lait entier"       # remplacer
courses.append("œufs")           # ajouter à la fin
courses.insert(0, "pain")        # insérer à l'index 0
courses.extend(["sel", "huile"]) # ajouter plusieurs éléments

print(courses)
# ['pain', 'riz', 'lait entier', 'œufs', 'sel', 'huile']
```

Suppression :

```python
courses.remove("sel")     # retire la PREMIÈRE occurrence de la valeur (ValueError si absente)
dernier = courses.pop()   # retire et RENVOIE le dernier élément : 'huile'
premier = courses.pop(0)  # retire et renvoie l'élément d'index 0 : 'pain'
del courses[0]            # supprime l'élément d'index 0 sans le renvoyer
courses.clear()           # vide la liste
```

| Je veux… | Je connais… | J'utilise |
|---|---|---|
| supprimer | la valeur | `.remove(valeur)` |
| supprimer et récupérer | la position | `.pop(index)` |
| supprimer | la position | `del liste[index]` |

### 3.6 Rechercher

```python
notes = [12, 15, 9, 15, 18]
15 in notes          # True
7 not in notes       # True
notes.index(15)      # 1 : position de la première occurrence (ValueError si absente)
notes.count(15)      # 2
```

### 3.7 Fonctions utiles

```python
notes = [12, 15, 9, 18]
len(notes)       # 4
sum(notes)       # 54
min(notes)       # 9
max(notes)       # 18
sum(notes) / len(notes)   # 13.5 : la moyenne (attention si la liste est vide !)
```

**Trier :**

```python
notes = [12, 15, 9, 18]
triees = sorted(notes)           # NOUVELLE liste triée : [9, 12, 15, 18] ; notes est inchangée
notes.sort()                     # trie notes SUR PLACE et renvoie None
notes.sort(reverse=True)         # ordre décroissant
```

Piège classique : `notes = notes.sort()` remplace ta liste par `None`.

### 3.8 Parcourir une liste

```python
prenoms = ["Aina", "Rado", "Fara"]

# 1. Les valeurs seulement (le plus courant)
for prenom in prenoms:
    print(prenom)

# 2. Position et valeur
for i, prenom in enumerate(prenoms, start=1):
    print(f"{i}. {prenom}")

# 3. Par index : seulement si on a vraiment besoin de l'index pour modifier
for i in range(len(prenoms)):
    prenoms[i] = prenoms[i].upper()
```

**Ne supprime pas d'éléments d'une liste pendant que tu la parcours** : des éléments seraient sautés. Construis plutôt une nouvelle liste.

### 3.9 Les références : `b = a` ne copie pas

```python
a = [1, 2, 3]
b = a          # b est un AUTRE NOM pour la MÊME liste
b.append(4)
print(a)       # [1, 2, 3, 4] : a est modifiée aussi !

c = a.copy()   # ou a[:] ou list(a) : une vraie copie
c.append(5)
print(a)       # [1, 2, 3, 4] : a est inchangée
```

**Analogie :** `b = a` donne une deuxième clé de la même maison. `a.copy()` construit une deuxième maison identique.

Ce comportement ne posait pas problème avec les nombres et les chaînes, car ils sont **immuables** : on ne peut pas les modifier sur place, seulement réaffecter la variable.

---

## 4. Exemples commentés

### Exemple A — Saisir une liste de notes

```python
notes = []                                  # 1. on part d'une liste vide

while True:
    saisie = input("Note (vide pour finir) : ")
    if saisie == "":
        break
    notes.append(float(saisie))             # 2. on accumule dans la liste

if notes:                                   # 3. une liste vide est « fausse »
    print(f"{len(notes)} notes : {notes}")
    print(f"Moyenne : {sum(notes) / len(notes):.2f}")
    print(f"Meilleure : {max(notes)}, pire : {min(notes)}")
else:
    print("Aucune note saisie.")
```

- `notes = []` joue le rôle d'un accumulateur, mais pour plusieurs valeurs.
- `if notes:` vaut `False` si la liste est vide. On évite ainsi une division par zéro.

### Exemple B — Filtrer dans une nouvelle liste

```python
notes = [12, 8, 15, 9.5, 10, 17]
admis = []
for note in notes:
    if note >= 10:
        admis.append(note)
print(admis)    # [12, 15, 10, 17]
```

Ce schéma (« nouvelle liste vide, boucle, condition, `append` ») est fondamental. Au jour 5, nous l'écrirons en une ligne avec une compréhension de liste.

---

## 5. Erreurs courantes

| Code | Erreur | Explication |
|---|---|---|
| `liste[len(liste)]` | `IndexError` | Le dernier index est `len - 1` |
| `liste = liste.sort()` | `liste` vaut `None` | `.sort()` modifie sur place et renvoie `None` |
| `liste.append(1, 2)` | `TypeError` | `append` prend un seul élément : utiliser `extend([1, 2])` |
| `liste.append([4, 5])` | Liste imbriquée `[..., [4, 5]]` | Utiliser `extend` pour ajouter plusieurs éléments |
| `liste.remove(x)` alors que x est absent | `ValueError` | Tester `if x in liste:` avant |
| `b = a` puis modification de `b` | `a` est modifiée aussi | Copier avec `a.copy()` |
| `sum(l) / len(l)` sur une liste vide | `ZeroDivisionError` | Tester `if l:` avant |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-02/jour-01/`

**Exercice 1 — Prédictions (`ex1_predictions.txt`).** Avec `L = [3, 1, 4, 1, 5, 9, 2, 6]`, prédis puis vérifie : `L[2]`, `L[-3]`, `L[2:5]`, `L[:2]`, `L[5:]`, `L[::3]`, `L[::-2]`, `L.count(1)`, `L.index(1)`, `sorted(L)[-2]`, `len(L[3:3])`.

**Exercice 2 — Manipulations (`ex2_manip.py`).** Pars de `fruits = ["mangue", "litchi", "banane"]`. En affichant la liste après **chaque** étape :
1. ajoute `"ananas"` à la fin ;
2. insère `"papaye"` en deuxième position ;
3. remplace `"banane"` par `"goyave"` sans écrire son index à la main (utilise `.index`) ;
4. retire le dernier élément en le récupérant dans une variable, et affiche-le ;
5. affiche la liste triée **sans modifier** la liste d'origine.

**Exercice 3 — Statistiques (`ex3_stats.py`).** Avec `temperatures = [28.5, 31.2, 27.8, 33.1, 30.0, 29.4, 26.9]` (une semaine), affiche la moyenne, le maximum et le jour où il a été atteint (de 1 à 7), ainsi que le nombre de jours au-dessus de 30.

## 7. Exercices intermédiaires

**Exercice 4 — Sans les fonctions intégrées (`ex4_manuel.py`).** Pour `nombres = [7, -3, 12, 0, 12, -8, 5]`, calcule **avec une boucle**, sans `sum`, `min`, `max`, `sorted` ni `.count` : la somme, le minimum, la position du maximum (premier en cas d'égalité), et le nombre d'éléments négatifs. Vérifie ensuite tes résultats avec les fonctions intégrées.

**Exercice 5 — Doublons (`ex5_doublons.py`).** À partir de `codes = ["A3", "B1", "A3", "C7", "B1", "A3", "D2"]`, construis une nouvelle liste sans doublons qui **conserve l'ordre** de première apparition : `["A3", "B1", "C7", "D2"]`.

**Exercice 6 — Rotation (`ex6_rotation.py`).** Demande un entier `k` et affiche la liste `[1, 2, 3, 4, 5, 6]` décalée de `k` positions vers la droite, à l'aide de tranches. Avec `k = 2`, on obtient `[5, 6, 1, 2, 3, 4]`. Que faire si `k` vaut 8 ? Et s'il est négatif ?

## 8. Défi — Liste de tâches (`defi_taches.py`)

Programme interactif avec un menu en boucle :

```
1. Afficher les tâches
2. Ajouter une tâche
3. Terminer une tâche (par numéro)
4. Monter une tâche en priorité (l'échanger avec celle du dessus)
5. Quitter
```

- Les tâches sont affichées numérotées à partir de 1.
- Les tâches terminées sont déplacées dans une seconde liste, `terminees`, affichée à part.
- Les numéros saisis sont validés : ce doit être un entier existant.
- Une tâche vide ou déjà présente est refusée.

## 8 bis. Corriger un bug (`bug_s2j1.py`)

Ce programme doit retirer toutes les notes inférieures à 10. Exécute-le : le résultat est faux. Explique **précisément** pourquoi en traçant la boucle, puis corrige-le de deux manières différentes.

```python
notes = [8, 9, 12, 7, 15, 5, 11]
for note in notes:
    if note < 10:
        notes.remove(note)
print(notes)
```

## 9. Critères de réussite

- [ ] Je prédis sans erreur les index négatifs et les tranches.
- [ ] Je choisis entre `append`, `extend` et `insert` sans hésiter.
- [ ] Je ne confonds plus `sorted()` et `.sort()`.
- [ ] Je sais expliquer pourquoi `b = a` ne copie pas une liste.
- [ ] Je protège mes calculs contre la liste vide.

## 10. Questions de révision

1. Pourquoi `liste[-1]` est-il préférable à `liste[len(liste) - 1]` ?
2. Quelle est la différence entre `liste.pop()` et `liste.remove(x)` ?
3. Après `a = [1, 2]`, `b = a`, puis `b = b + [3]`, que vaut `a` ? Et après `b.append(3)` ? (Teste, puis explique.)
4. Pourquoi ne faut-il pas supprimer d'éléments d'une liste pendant qu'on la parcourt ?

## 11. Bilan et préparation du jour 2

Les listes rangent des éléments **par position**. Mais comment stocker le numéro de téléphone **de chaque** contact, ou la note **de chaque** étudiant ? Retrouver « la note de Fara » dans deux listes parallèles est fragile. Au jour 2, nous verrons les **dictionnaires** (accès par clé), ainsi que les **tuples** et les **ensembles**.
