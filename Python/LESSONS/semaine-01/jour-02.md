# Semaine 1 · Jour 2 : `input()`, conversions de types et booléens

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- demander une information à l'utilisateur avec `input()` ;
- expliquer pourquoi `input()` renvoie **toujours** une chaîne ;
- convertir des valeurs avec `int()`, `float()`, `str()` et `bool()` ;
- reconnaître le type `bool` et ses deux valeurs, `True` et `False` ;
- comparer des valeurs avec `==`, `!=`, `<`, `<=`, `>`, `>=` ;
- comprendre l'erreur `ValueError` lors d'une conversion.

## 2. Prérequis

- Jour 1 : `print()`, `str`, `int`, `float`, variables, f-strings.
- Savoir lancer un script avec `python3 fichier.py`.

---

## 3. Cours

### 3.1 Pourquoi `input()` ?

Jusqu'ici, toutes les valeurs étaient écrites dans le code. Pour calculer le total d'un autre panier, il fallait modifier le fichier. Un vrai programme **dialogue** avec son utilisateur : il pose une question, attend la réponse, puis la traite.

**Analogie :** un guichetier demande ton nom et l'écrit sur un formulaire. Il écrit ce que tu dis, **sous forme de texte**, même si tu donnes un nombre.

```python
prenom = input("Quel est ton prénom ? ")
print(f"Bonjour {prenom} !")
```

Exécution :

```
Quel est ton prénom ? Aina
Bonjour Aina !
```

Ligne par ligne :
1. `input(...)` affiche le message, puis **met le programme en pause** jusqu'à ce que l'utilisateur appuie sur Entrée. Le texte tapé est **renvoyé** et rangé dans `prenom`.
2. On affiche un message avec la valeur reçue.

Astuce : termine le message de `input` par un espace, sinon la réponse est collée au texte de la question.

### 3.2 `input()` renvoie toujours un `str`

```python
age = input("Ton âge ? ")    # l'utilisateur tape 25
print(type(age))             # <class 'str'>
print(age + 1)               # TypeError: can only concatenate str (not "int") to str
```

Le texte `"25"` n'est pas le nombre `25`. Python ne devine pas : c'est à toi de **convertir**.

### 3.3 Les conversions de types

| Fonction | Rôle | Exemple | Résultat |
|---|---|---|---|
| `int(x)` | vers un entier | `int("25")` | `25` |
| `float(x)` | vers un décimal | `float("3.5")` | `3.5` |
| `str(x)` | vers du texte | `str(25)` | `"25"` |
| `bool(x)` | vers un booléen | `bool(0)` | `False` |

Ces conversions ne modifient pas la valeur d'origine : elles **créent une nouvelle valeur**.

```python
texte = "25"
nombre = int(texte)
print(texte, type(texte))     # 25 <class 'str'>
print(nombre, type(nombre))   # 25 <class 'int'>
```

Le schéma classique consiste à lire puis convertir immédiatement :

```python
age = int(input("Ton âge ? "))
print(f"Dans 10 ans, tu auras {age + 10} ans.")
```

Python évalue de l'intérieur vers l'extérieur : d'abord `input(...)` renvoie `"25"`, puis `int("25")` renvoie `25`.

**Cas particuliers à connaître :**

```python
int("3.5")       # ValueError : int() n'accepte pas un texte décimal
int(3.9)         # 3 : à partir d'un float, int() TRONQUE (il coupe, il n'arrondit pas)
float("3,5")     # ValueError : la virgule n'est pas acceptée
int(" 42 ")      # 42 : les espaces autour sont tolérés
int("abc")       # ValueError: invalid literal for int() with base 10: 'abc'
round(3.6)       # 4 : pour arrondir, on utilise round()
round(3.14159, 2)  # 3.14
```

Pour l'instant, si l'utilisateur tape n'importe quoi, le programme plante avec `ValueError`. Nous apprendrons à valider les saisies au jour 4 (avec `while`) et à gérer les erreurs en semaine 3 (avec `try`/`except`).

### 3.4 Le type `bool`

Un **booléen** représente une réponse à une question fermée : **vrai** ou **faux**. Il n'a que deux valeurs, `True` et `False`, avec une majuscule et sans guillemets.

```python
est_majeur = True
a_paye = False
print(type(est_majeur))   # <class 'bool'>
```

Les booléens sont indispensables pour prendre des décisions (jour 3) et contrôler les boucles (jour 4).

### 3.5 Les opérateurs de comparaison

Une comparaison **produit un booléen** :

| Opérateur | Signification | Exemple | Résultat |
|---|---|---|---|
| `==` | égal à | `5 == 5` | `True` |
| `!=` | différent de | `5 != 3` | `True` |
| `<` | inférieur | `2 < 1` | `False` |
| `<=` | inférieur ou égal | `3 <= 3` | `True` |
| `>` | supérieur | `10 > 2` | `True` |
| `>=` | supérieur ou égal | `1 >= 4` | `False` |

**Attention :** `=` **affecte** une valeur, `==` **compare** deux valeurs.

```python
age = 17
majeur = age >= 18
print(majeur)            # False
print("5" == 5)          # False : un str n'est jamais égal à un int
print("abc" == "ABC")    # False : la casse compte
print(0.1 + 0.2 == 0.3)  # False ! (approximation des float, voir jour 1)
```

On peut aussi comparer des chaînes. L'ordre est celui des codes des caractères (en gros, alphabétique, mais les majuscules viennent avant les minuscules) :

```python
print("abc" < "abd")       # True
print("Zèbre" < "abeille") # True : les majuscules passent avant les minuscules
print("pomme" < "poire")   # False : pourquoi ? (question de révision 3)
```

Vérifie ces trois lignes dans le REPL et cherche à comprendre le dernier résultat.

Python permet aussi d'**enchaîner** les comparaisons, comme en mathématiques :

```python
note = 14
print(10 <= note <= 20)   # True : équivaut à 10 <= note et note <= 20
```

### 3.6 Valeurs « vraies » et « fausses »

`bool()` convertit n'importe quelle valeur en booléen. Retiens que les valeurs **vides ou nulles** sont fausses :

```python
bool(0)       # False
bool(0.0)     # False
bool("")      # False (chaîne vide)
bool(42)      # True
bool("0")     # True ! La chaîne "0" n'est pas vide
bool(" ")     # True : un espace est un caractère
```

---

## 4. Exemples commentés

### Exemple A — Calcul d'aire

```python
# Aire d'un rectangle à partir des saisies de l'utilisateur
longueur = float(input("Longueur (m) : "))
largeur = float(input("Largeur (m) : "))

aire = longueur * largeur
print(f"Aire : {aire} m²")
print(f"Grande pièce ? {aire >= 20}")
```

Avec `5` et `4.5`, on obtient :

```
Longueur (m) : 5
Largeur (m) : 4.5
Aire : 22.5 m²
Grande pièce ? True
```

- On utilise `float` et non `int`, car une longueur peut être décimale.
- `aire >= 20` est une comparaison : elle vaut `True` ou `False`, et la f-string l'affiche.

### Exemple B — Contrôler un format d'affichage

```python
prix = 19.999
print(f"{prix:.2f}")   # 20.00 : 2 chiffres après la virgule, avec arrondi
print(round(prix, 2))  # 20.0
```

`:.2f` dans une f-string est un **format** : il change l'affichage, pas la valeur stockée.

---

## 5. Erreurs courantes

| Code | Message ou résultat | Explication |
|---|---|---|
| `age = input("Âge ? ")` puis `age + 1` | `TypeError` | `input` renvoie un `str` |
| `int("3.5")` | `ValueError: invalid literal for int()` | Passer par `float("3.5")` |
| `int(input())` avec la saisie `douze` | `ValueError` | Saisie non numérique (validation au jour 4) |
| `if age = 18` | `SyntaxError` | `=` affecte, `==` compare |
| `true` | `NameError` | C'est `True`, avec une majuscule |
| `"10" > "9"` | `False` | Comparaison de **textes**, caractère par caractère : `"1" < "9"` |
| `int(9.99)` | `9` | Troncature, pas arrondi |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-01/jour-02/`

**Exercice 1 — Prédictions (`ex1_predictions.txt`).** Sans exécuter, écris le résultat ou l'erreur de chaque ligne, puis vérifie dans le REPL :

```python
int("7") + 3
"7" + "3"
int(7.8)
float("2")
str(5) * 3
bool("")
bool("False")
3 == 3.0
"a" != "A"
int("12a")
```

**Exercice 2 — Salutation (`ex2_salut.py`).** Demande le prénom et l'année de naissance. Affiche : `Bonjour Fara, tu auras 30 ans en 2026.` L'année courante est une constante `ANNEE_COURANTE = 2026`.

**Exercice 3 — Conversion de température (`ex3_temperature.py`).** Demande une température en degrés Celsius (elle peut être décimale) et affiche la valeur en Fahrenheit avec une décimale. Formule : `F = C × 9/5 + 32`. Exemple : `37` donne `98.6 °F`.

## 7. Exercices intermédiaires

**Exercice 4 — Comparateur (`ex4_comparateur.py`).** Demande deux nombres entiers et affiche, **sans utiliser `if`** :

```
a = 7, b = 12
a == b : False
a < b  : True
a est pair : False
b est un multiple de 3 : True
```

Indice : un nombre est pair si le reste de sa division par 2 vaut 0.

**Exercice 5 — Monnaie (`ex5_monnaie.py`).** Demande un montant entier, par exemple `8750`. Calcule le nombre de billets de 5000, de 2000, de 1000 et de 500 qu'il faut, en prenant toujours le plus gros billet possible, ainsi que le reste. Utilise uniquement `//` et `%`.

```
8750 = 1 x 5000 + 1 x 2000 + 1 x 1000 + 1 x 500 + reste 250
```

## 8. Défi — Facture d'électricité (`defi_facture.py`)

Demande l'index du compteur précédent et l'index actuel (des entiers), puis le prix du kWh (un décimal). Affiche :
- la consommation en kWh ;
- le montant HT, avec 2 décimales ;
- le montant TTC (TVA en constante, 20 %) ;
- un booléen indiquant si la consommation dépasse 200 kWh ;
- un booléen indiquant si l'index actuel est **incohérent** (inférieur au précédent).

Teste ton programme avec au moins trois jeux de valeurs différents, dont un incohérent, et note les résultats en commentaire à la fin du fichier.

## 8 bis. Corriger un bug (`bug_02.py`)

Recopie ce code, exécute-le avec les saisies `3` et `2.5`, puis trouve et explique **chaque** problème. Il y a des erreurs qui plantent et une erreur de logique silencieuse.

```python
# Prix d'un trajet en taxi
distance = input("Distance en km : ")
prix_km = int(input("Prix par km : "))
PRISE_EN_CHARGE = 2000

total = PRISE_EN_CHARGE + distance * prix_km
print("Total : " + total)
print("Trajet long ?", distance > 10)
```

## 9. Critères de réussite

- [ ] Je convertis toujours une saisie numérique **immédiatement** après `input()`.
- [ ] Je choisis entre `int` et `float` en fonction de la donnée.
- [ ] Je sais distinguer `=` et `==`.
- [ ] Je sais expliquer `ValueError` et `TypeError` avec mes mots.
- [ ] Mes prédictions de l'exercice 1 sont justes à 8/10 au moins (après réflexion, pas au hasard).

## 10. Questions de révision

1. Pourquoi `input()` ne renvoie-t-il pas directement un nombre quand l'utilisateur tape `42` ?
2. Quelle est la différence entre `int(7.9)` et `round(7.9)` ?
3. Pourquoi `"pomme" < "poire"` vaut-il `False` ? Explique comment Python compare deux chaînes.
4. Donne trois valeurs pour lesquelles `bool(valeur)` vaut `False`.

## 11. Bilan et préparation du jour 3

Aujourd'hui, ton programme a appris à **écouter** (`input`) et à **évaluer** (comparaisons). Mais il fait toujours la même chose, quelle que soit la réponse. Au jour 3, il apprendra à **décider** : `if`, `elif`, `else` et les opérateurs logiques `and`, `or`, `not`.

Avant le jour 3, assure-toi que tu peux prédire sans hésiter le résultat de `10 <= x <= 20` pour plusieurs valeurs de `x`.
