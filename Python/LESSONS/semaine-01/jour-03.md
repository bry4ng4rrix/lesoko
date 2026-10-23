# Semaine 1 · Jour 3 : conditions et opérateurs logiques

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- exécuter du code seulement si une condition est vraie, avec `if` ;
- prévoir une alternative avec `else` et plusieurs cas avec `elif` ;
- expliquer le rôle de l'**indentation** en Python ;
- combiner des conditions avec `and`, `or` et `not` ;
- ordonner correctement des `elif` ;
- tester un programme avec des **cas limites**.

## 2. Prérequis

- Jour 2 : `input()`, conversions, booléens, comparaisons.

---

## 3. Cours

### 3.1 Le problème : un programme qui décide

Un distributeur de billets ne donne pas d'argent si le solde est insuffisant. Un site refuse un mot de passe trop court. Ces programmes **choisissent** quelles instructions exécuter selon la situation. C'est le rôle des **structures conditionnelles**.

### 3.2 `if`

```python
age = int(input("Âge : "))

if age >= 18:
    print("Accès autorisé.")
    print("Bienvenue.")

print("Fin du programme.")
```

- `if` est suivi d'une **condition** (une expression qui vaut `True` ou `False`), puis de **deux-points** `:`.
- Les lignes **indentées** de 4 espaces forment le **bloc** : elles ne s'exécutent que si la condition est vraie.
- La dernière ligne n'est pas indentée : elle s'exécute toujours.

Avec `20` :

```
Accès autorisé.
Bienvenue.
Fin du programme.
```

Avec `15` :

```
Fin du programme.
```

**L'indentation a un sens.** Dans beaucoup de langages, on délimite les blocs avec `{ }`. En Python, c'est l'indentation qui le fait. La convention (PEP 8) est de **4 espaces**. VS Code insère 4 espaces quand tu appuies sur Tab dans un fichier `.py`.

### 3.3 `else`

```python
if age >= 18:
    print("Majeur")
else:
    print("Mineur")
```

`else` n'a **pas de condition** : il s'exécute quand la condition du `if` est fausse. Exactement **un** des deux blocs s'exécute.

### 3.4 `elif` : plusieurs cas

```python
note = float(input("Note sur 20 : "))

if note >= 16:
    mention = "Très bien"
elif note >= 14:
    mention = "Bien"
elif note >= 12:
    mention = "Assez bien"
elif note >= 10:
    mention = "Passable"
else:
    mention = "Ajourné"

print(f"Mention : {mention}")
```

Python teste les conditions **de haut en bas** et exécute **le premier bloc dont la condition est vraie**, puis il saute à la fin de la structure. Avec `15`, `note >= 16` est faux et `note >= 14` est vrai : la mention est `"Bien"` et les autres tests ne sont **même pas évalués**.

C'est pour cela que l'ordre compte. Si on commençait par `note >= 10`, une note de 18 obtiendrait « Passable ».

### 3.5 Opérateurs logiques

| Opérateur | Vrai quand… | Exemple |
|---|---|---|
| `and` | les **deux** conditions sont vraies | `age >= 18 and a_billet` |
| `or` | **au moins une** condition est vraie | `jour == "samedi" or jour == "dimanche"` |
| `not` | la condition est fausse | `not est_bloque` |

Tables de vérité :

| A | B | A and B | A or B |
|---|---|---|---|
| True | True | True | True |
| True | False | False | True |
| False | True | False | True |
| False | False | False | False |

**Priorité :** `not` est évalué en premier, puis `and`, puis `or`. Utilise des parenthèses dès qu'il y a un doute.

```python
age = 25
a_permis = True
alcoolemie = 0.0

peut_conduire = age >= 18 and a_permis and alcoolemie == 0
print(peut_conduire)   # True
```

**Évaluation paresseuse (court-circuit) :** avec `and`, si la première condition est fausse, Python n'évalue pas la seconde, car le résultat est déjà connu. Avec `or`, il s'arrête dès qu'une condition est vraie. C'est utile pour éviter une erreur :

```python
diviseur = 0
if diviseur != 0 and 10 / diviseur > 2:
    print("Grand quotient")
# Pas de ZeroDivisionError : la division n'est jamais calculée
```

### 3.6 Conditions imbriquées

On peut placer un `if` dans un autre bloc :

```python
a_compte = True
solde = 3000
montant = 5000

if a_compte:
    if solde >= montant:
        print("Retrait accepté")
    else:
        print("Solde insuffisant")
else:
    print("Aucun compte")
```

Au-delà de deux niveaux, le code devient difficile à lire. On peut souvent **aplatir** avec `and` ou avec des `elif`.

### 3.7 Opérateur `in` pour une chaîne

```python
reponse = input("Continuer ? (o/n) ").lower()
if reponse in ("o", "oui"):
    print("On continue")
```

`.lower()` met le texte en minuscules (nous verrons les méthodes de chaînes en semaine 2). `in` teste si la valeur fait partie d'une collection. C'est plus lisible que `reponse == "o" or reponse == "oui"`.

### 3.8 L'expression conditionnelle (ternaire)

Pour choisir **une valeur** entre deux, il existe une forme courte :

```python
statut = "majeur" if age >= 18 else "mineur"
```

Réserve-la aux cas simples. Pour toute logique plus longue, utilise un vrai `if`.

---

## 4. Exemples commentés

### Exemple A — Prix d'entrée selon l'âge

```python
# Tarif d'un musée
age = int(input("Âge : "))
est_etudiant = input("Étudiant ? (o/n) ").lower() == "o"

if age < 6:
    prix = 0
elif age < 18 or est_etudiant:
    prix = 2000
elif age >= 65:
    prix = 2500
else:
    prix = 5000

print(f"Prix : {prix}")
```

- Ligne 3 : la comparaison `== "o"` produit directement un booléen. On n'a pas besoin d'un `if` pour le calculer.
- Un enfant de 4 ans paie 0 : la première branche l'attrape et les suivantes ne sont pas testées.
- Un étudiant de 30 ans : `30 < 6` est faux, puis `30 < 18 or True` est vrai. Prix : 2000.
- Un retraité étudiant de 70 ans paie 2000, pas 2500, car la branche étudiant vient avant. Est-ce le comportement voulu ? C'est une **décision métier**, et l'ordre des `elif` la traduit.

### Exemple B — Année bissextile

Règle : une année est bissextile si elle est divisible par 4 mais pas par 100, **ou** si elle est divisible par 400.

```python
annee = int(input("Année : "))
bissextile = (annee % 4 == 0 and annee % 100 != 0) or annee % 400 == 0

if bissextile:
    print(f"{annee} est bissextile")
else:
    print(f"{annee} n'est pas bissextile")
```

Cas de test : `2024` (oui), `2023` (non), `1900` (non), `2000` (oui). Ces quatre années couvrent **chaque branche** de la règle. C'est ainsi qu'on choisit des tests.

---

## 5. Erreurs courantes

| Code | Problème |
|---|---|
| `if age >= 18` (sans `:`) | `SyntaxError: expected ':'` |
| Bloc non indenté après `if` | `IndentationError: expected an indented block` |
| Mélange de tabulations et d'espaces | `TabError` : configure ton éditeur sur 4 espaces |
| `if note >= 10:` placé avant `if note >= 16:` | Logique fausse : le premier cas vrai gagne |
| `if x == 1 or 2:` | Toujours vrai ! Python lit `(x == 1) or 2`, et `2` est vrai. Écris `x == 1 or x == 2` ou `x in (1, 2)` |
| `else age < 18:` | `SyntaxError` : `else` ne prend pas de condition |
| `if est_valide == True:` | Fonctionne, mais redondant : écris `if est_valide:` |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-01/jour-03/`

**Exercice 1 — Pair ou impair (`ex1_parite.py`).** Demande un entier et affiche `pair` ou `impair`. Teste avec `0`, `7` et `-4`.

**Exercice 2 — Signe (`ex2_signe.py`).** Demande un nombre décimal et affiche `positif`, `négatif` ou `nul`.

**Exercice 3 — Prédiction (`ex3_logique.txt`).** Avec `a = 5`, `b = 0` et `c = "oui"`, prédis puis vérifie :

```python
a > 3 and b > 3
a > 3 or b > 3
not a > 3
b == 0 or a / b > 1
a / b > 1 or b == 0
c == "oui" and not b
a == 5 or 6
```

Une de ces lignes provoque une erreur. Laquelle, et pourquoi pas sa voisine ?

## 7. Exercices intermédiaires

**Exercice 4 — Indice de masse corporelle (`ex4_imc.py`).** Demande le poids (kg) et la taille (m). Calcule `IMC = poids / taille²` et affiche la valeur avec une décimale, ainsi que la catégorie :
- moins de 18.5 : insuffisance pondérale ;
- de 18.5 à moins de 25 : normal ;
- de 25 à moins de 30 : surpoids ;
- 30 ou plus : obésité.

Si la taille est inférieure ou égale à 0, ou si le poids est inférieur ou égal à 0, affiche un message d'erreur **au lieu** du calcul.

**Exercice 5 — Plus grand des trois (`ex5_max.py`).** Demande trois entiers et affiche le plus grand **sans utiliser `max()`**. Tes tests doivent inclure le cas où deux nombres sont égaux et le plus grand, ainsi que des nombres négatifs.

**Exercice 6 — Triangle (`ex6_triangle.py`).** Demande trois longueurs. Affiche d'abord si un triangle est possible : chaque côté doit être strictement inférieur à la somme des deux autres. Si c'est le cas, indique s'il est équilatéral, isocèle ou quelconque.

## 8. Défi — Tarification de livraison (`defi_livraison.py`)

Une boutique calcule ses frais de livraison ainsi :
- commande de 100 000 ou plus : livraison gratuite ;
- sinon, la base dépend de la zone : `A` = 3000, `B` = 5000, `C` = 8000 ;
- livraison express (o/n) : +50 % sur la base, y compris quand la livraison est gratuite (dans ce cas, seul ce supplément est facturé, calculé sur la base de la zone) ;
- zone inconnue : message d'erreur, aucun calcul.

Avant de coder :
1. écris en commentaire au moins **6 cas de test**, avec les saisies et le résultat attendu, calculé à la main ;
2. fais valider ta logique en pseudocode (en français, ligne par ligne).

Code ensuite, puis vérifie chacun de tes cas.

## 8 bis. Corriger un bug (`bug_03.py`)

Ce programme doit afficher `Fièvre` au-dessus de 38, `Normal` de 36 à 38 inclus, et `Hypothermie` en dessous de 36. Il contient trois problèmes. Trouve-les, explique-les, puis corrige.

```python
temperature = float(input("Température : "))

if temperature >= 36:
    print("Normal")
elif temperature > 38:
    print("Fièvre")
elif temperature < 36
    print("Hypothermie")
  print("Mesure enregistrée")
```

## 9. Critères de réussite

- [ ] Mon indentation est toujours de 4 espaces.
- [ ] Je sais justifier l'ordre de mes `elif`.
- [ ] Je teste au moins une valeur **à chaque frontière** (exemple : 18.5, 25, 30 pour l'IMC).
- [ ] Je n'écris jamais `x == 1 or 2`.
- [ ] Je rédige mes cas de test **avant** de coder pour le défi.

## 10. Questions de révision

1. Dans une suite `if`/`elif`/`elif`/`else`, combien de blocs peuvent s'exécuter au maximum ? Au minimum ?
2. Pourquoi `if x == 1 or 2:` est-il toujours vrai ?
3. Qu'est-ce que l'évaluation en court-circuit ? Donne un exemple où elle évite une erreur.
4. Réécris `if not (age < 18 or not a_permis):` sous une forme plus lisible, sans `not`.

## 11. Bilan et préparation du jour 4

Ton programme sait maintenant décider. Mais il ne fait qu'**un seul passage** : si l'utilisateur se trompe de saisie, il faut relancer tout le programme. Au jour 4, nous verrons la boucle `while`, qui permet de **répéter** une action tant qu'une condition est vraie. C'est l'outil pour redemander une saisie invalide.
