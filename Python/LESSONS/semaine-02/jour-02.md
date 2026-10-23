# Semaine 2 · Jour 2 : tuples, ensembles et dictionnaires

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- utiliser un **tuple** pour un groupe de valeurs fixe, et le décomposer ;
- utiliser un **ensemble** (`set`) pour éliminer les doublons et tester l'appartenance ;
- créer, lire, modifier et parcourir un **dictionnaire** ;
- utiliser `.get()`, `.items()`, `.keys()` et `.values()` ;
- choisir la bonne collection selon le problème ;
- représenter des données réelles en combinant listes et dictionnaires.

## 2. Prérequis

- Jour 1 : listes, index, mutabilité.

---

## 3. Cours

### 3.1 Les tuples

**Le problème :** certaines valeurs vont ensemble et ne doivent pas changer, comme les coordonnées GPS d'une ville ou une date (jour, mois, année).

Un **tuple** est une séquence **immuable** : une fois créé, on ne peut ni le modifier, ni lui ajouter, ni lui retirer d'éléments.

```python
point = (3, 7)
date = (23, 10, 2026)
singleton = (5,)          # la virgule est obligatoire pour un tuple d'un seul élément
print(point[0])           # 3 : indexation comme une liste
point[0] = 10             # TypeError: 'tuple' object does not support item assignment
```

**Décomposition** (*unpacking*) : on affecte chaque élément à une variable.

```python
jour, mois, annee = date
print(mois)               # 10

a, b = 1, 2
a, b = b, a               # échange de deux variables en une ligne
print(a, b)               # 2 1
```

Le nombre de variables doit correspondre au nombre d'éléments, sinon on obtient une `ValueError: too many values to unpack`.

**Liste ou tuple ?**
- Une **liste** contient une collection d'éléments **du même genre**, de taille variable (des notes).
- Un **tuple** contient un enregistrement fixe **d'éléments de nature différente** (nom, âge, ville).

Tu en as déjà utilisé : `enumerate` produit des tuples `(index, valeur)`.

### 3.2 Les ensembles (`set`)

**Le problème :** savoir quels visiteurs **distincts** sont venus sur un site, ou vérifier très rapidement si un élément est présent.

Un **ensemble** est une collection **sans doublons** et **sans ordre**.

```python
visiteurs = {"aina", "rado", "aina", "fara"}
print(visiteurs)          # {'rado', 'aina', 'fara'} : l'ordre d'affichage peut varier
print(len(visiteurs))     # 3

vide = set()              # ATTENTION : {} crée un dictionnaire vide, pas un ensemble

visiteurs.add("tiana")
visiteurs.discard("rado") # retire sans erreur si absent (remove lève une KeyError)
print("aina" in visiteurs)   # True, et très rapide même avec un million d'éléments
```

Pas d'indexation : `visiteurs[0]` provoque une `TypeError`, puisqu'il n'y a pas d'ordre.

**Opérations d'ensembles :**

```python
python = {"aina", "rado", "fara"}
sql = {"rado", "tiana"}

python | sql     # union : {'aina', 'rado', 'fara', 'tiana'}
python & sql     # intersection : {'rado'}
python - sql     # différence : {'aina', 'fara'}
python ^ sql     # différence symétrique : {'aina', 'fara', 'tiana'}
```

Éliminer les doublons d'une liste : `list(set(ma_liste))`. **L'ordre est perdu.** Si l'ordre compte, garde la méthode de l'exercice 5 du jour 1.

### 3.3 Les dictionnaires

**Le problème :** retrouver une valeur par son **nom** plutôt que par sa position. Avec deux listes `prenoms` et `notes`, il faut chercher l'index de « Fara » puis lire `notes` au même index. C'est lent et fragile.

**Analogie :** un vrai dictionnaire. On cherche un **mot** (la clé) et on obtient sa **définition** (la valeur).

```python
notes = {
    "Aina": 15,
    "Rado": 12,
    "Fara": 17,
}
```

- Les accolades délimitent le dictionnaire, et chaque entrée a la forme `cle: valeur`.
- Les **clés sont uniques** et doivent être immuables (`str`, `int`, `tuple`…). Une liste ne peut pas servir de clé.
- Les valeurs peuvent être de n'importe quel type.
- Depuis Python 3.7, l'ordre d'insertion est conservé.

**Lire :**

```python
notes["Fara"]               # 17
notes["Zo"]                 # KeyError: 'Zo'
notes.get("Zo")             # None : pas d'erreur
notes.get("Zo", 0)          # 0 : valeur par défaut
"Aina" in notes             # True : in teste les CLÉS
```

**Ajouter, modifier, supprimer :**

```python
notes["Tiana"] = 14         # la clé n'existe pas : ajout
notes["Rado"] = 13          # la clé existe : modification (pas de doublon)
del notes["Aina"]           # suppression (KeyError si absente)
note_fara = notes.pop("Fara")   # supprime et renvoie la valeur
```

**Parcourir :**

```python
notes = {"Aina": 15, "Rado": 12, "Fara": 17}

for prenom in notes:                    # parcourt les CLÉS
    print(prenom)

for note in notes.values():             # les valeurs
    print(note)

for prenom, note in notes.items():      # les couples (clé, valeur) : le plus utile
    print(f"{prenom} : {note}")
```

**Compter avec un dictionnaire**, un schéma essentiel :

```python
texte = "abracadabra"
compte = {}
for lettre in texte:
    compte[lettre] = compte.get(lettre, 0) + 1
print(compte)    # {'a': 5, 'b': 2, 'r': 2, 'c': 1, 'd': 1}
```

À chaque lettre, on lit le compteur actuel (0 s'il n'existe pas encore), on ajoute 1, puis on réécrit.

### 3.4 Structures imbriquées

Les données réelles combinent les collections. Une **liste de dictionnaires** représente une table d'enregistrements :

```python
etudiants = [
    {"nom": "Aina", "age": 21, "notes": [15, 12, 18]},
    {"nom": "Rado", "age": 23, "notes": [11, 14]},
]

print(etudiants[1]["nom"])          # Rado
print(etudiants[0]["notes"][-1])    # 18

for e in etudiants:
    moyenne = sum(e["notes"]) / len(e["notes"])
    print(f"{e['nom']} : {moyenne:.1f}")
```

Lis de gauche à droite : `etudiants[0]` est un dictionnaire, `["notes"]` donne une liste, `[-1]` donne son dernier élément.

Dans une f-string délimitée par `"`, utilise `'` pour les clés : `f"{e['nom']}"`.

C'est exactement la forme des données **JSON** que tu manipuleras en semaine 3 et dans les API.

### 3.5 Choisir la bonne collection

| Besoin | Collection |
|---|---|
| Une suite ordonnée et modifiable | `list` |
| Un enregistrement fixe, ou une clé composée | `tuple` |
| Des éléments uniques, un test d'appartenance rapide | `set` |
| Associer une clé à une valeur | `dict` |

---

## 4. Exemples commentés

### Exemple A — Répertoire téléphonique

```python
repertoire = {}

while True:
    action = input("(a)jouter, (c)hercher, (l)ister, (q)uitter : ").lower()
    if action == "a":
        nom = input("Nom : ").strip().title()
        tel = input("Téléphone : ").strip()
        if nom in repertoire:
            print(f"{nom} existe déjà ({repertoire[nom]}), numéro remplacé.")
        repertoire[nom] = tel
    elif action == "c":
        nom = input("Nom : ").strip().title()
        print(repertoire.get(nom, "Inconnu"))
    elif action == "l":
        for nom, tel in sorted(repertoire.items()):
            print(f"{nom:<15}{tel}")
    elif action == "q":
        break
```

- `.strip()` retire les espaces autour et `.title()` met une majuscule à chaque mot. Ainsi, « fara » et « Fara » donnent la même clé.
- `sorted(repertoire.items())` trie les couples par clé, c'est-à-dire par nom.
- `{nom:<15}` aligne le nom à gauche sur 15 caractères.

### Exemple B — Mots communs à deux textes

```python
texte1 = "le chat mange le poisson"
texte2 = "le chien mange la viande"
communs = set(texte1.split()) & set(texte2.split())
print(sorted(communs))    # ['le', 'mange']
```

`.split()` découpe une chaîne en liste de mots. Nous le reverrons au jour 3.

---

## 5. Erreurs courantes

| Code | Erreur | Explication |
|---|---|---|
| `d["absente"]` | `KeyError` | Utiliser `.get()` ou tester `in` |
| `vide = {}` utilisé comme un ensemble | C'est un `dict` | Écrire `set()` |
| `t = (5)` | C'est un `int` | Écrire `(5,)` |
| `{[1, 2]: "x"}` | `TypeError: unhashable type: 'list'` | Une clé doit être immuable : utiliser un tuple |
| `for k, v in d:` | `ValueError` ou résultat étrange | Écrire `d.items()` |
| Modifier un dict pendant qu'on le parcourt | `RuntimeError: dictionary changed size during iteration` | Parcourir `list(d)` ou construire un nouveau dict |
| `ensemble[0]` | `TypeError` | Un ensemble n'a pas d'ordre |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-02/jour-02/`

**Exercice 1 — Choisir (`ex1_choix.txt`).** Pour chaque besoin, indique la collection adaptée et justifie : les jours de la semaine ; le panier d'un client ; les pays visités par un voyageur ; le prix de chaque produit ; une position (ligne, colonne) sur un plateau d'échecs ; l'historique des commandes tapées dans un terminal ; les mots déjà proposés au jeu du pendu.

**Exercice 2 — Stock (`ex2_stock.py`).** Avec `stock = {"riz": 50, "sucre": 20, "huile": 0, "sel": 35}` :
1. affiche chaque produit et sa quantité ;
2. ajoute `"farine": 15` ;
3. retire 5 unités de riz ;
4. affiche les produits en rupture (quantité 0) ;
5. affiche la quantité totale en stock ;
6. demande un produit à l'utilisateur et affiche sa quantité, ou « produit inconnu », **sans `if`** (indice : `.get`).

**Exercice 3 — Ensembles (`ex3_ensembles.py`).** Deux classes ont choisi des options : `classe_a = {"maths", "info", "anglais", "physique"}` et `classe_b = {"info", "chimie", "anglais", "bio"}`. Affiche les options communes, toutes les options proposées, et celles propres à chaque classe.

## 7. Exercices intermédiaires

**Exercice 4 — Fréquence des mots (`ex4_frequence.py`).** Demande un texte. Compte la fréquence de chaque mot sans tenir compte de la casse et affiche les 3 mots les plus fréquents, avec leur nombre d'occurrences. Indice pour le tri : `sorted(compte.items(), key=lambda couple: couple[1], reverse=True)` trie selon la valeur. Nous expliquerons `lambda` plus tard ; pour l'instant, lis-le comme « trier selon l'élément 1 du couple ».

**Exercice 5 — Inverser un dictionnaire (`ex5_inverse.py`).** À partir de `capitales = {"Madagascar": "Antananarivo", "France": "Paris", "Japon": "Tokyo"}`, construis le dictionnaire inverse (capitale → pays). Puis, avec `notes = {"Aina": 15, "Rado": 12, "Fara": 15}`, construis le dictionnaire note → **liste** d'étudiants : `{15: ["Aina", "Fara"], 12: ["Rado"]}`.

**Exercice 6 — Bulletin (`ex6_bulletin.py`).** Avec la liste `etudiants` de la section 3.4, enrichie de deux étudiants, affiche pour chacun la moyenne, la meilleure note et la mention. Affiche enfin le nom du major de promotion.

## 8. Défi — Carnet de commandes (`defi_commandes.py`)

```python
catalogue = {"P01": ("Stylo", 800), "P02": ("Cahier", 2500), "P03": ("Sac", 35000)}
```

Le programme gère un **panier**, sous forme de dictionnaire code → quantité :
- ajouter un produit par son code (le code doit exister ; on cumule les quantités si le produit est déjà dans le panier) ;
- retirer une quantité, et supprimer la ligne si la quantité tombe à 0 ;
- afficher le panier comme une facture : désignation, quantité, prix unitaire, sous-total, total ;
- appliquer une remise de 10 % si le total dépasse 50 000.

Explique en commentaire pourquoi le catalogue utilise des tuples, et le panier un dictionnaire.

## 8 bis. Corriger un bug (`bug_s2j2.py`)

Ce code doit compter les votes et afficher le gagnant. Il contient trois bugs. Trouve-les.

```python
votes = ["oui", "non", "oui", "blanc", "oui", "non"]
resultats = {}
for vote in votes:
    resultats[vote] = resultats[vote] + 1

gagnant = ""
max_voix = 0
for option, voix in resultats:
    if voix > max_voix:
        gagnant = option
print("Gagnant :", gagnant)
```

## 9. Critères de réussite

- [ ] Je choisis la collection adaptée et je sais justifier ce choix.
- [ ] J'utilise `.get()` quand une clé peut être absente.
- [ ] Je parcours un dictionnaire avec `.items()`.
- [ ] Je sais naviguer dans une liste de dictionnaires.
- [ ] Je maîtrise le schéma « compter avec un dictionnaire ».

## 10. Questions de révision

1. Pourquoi une liste ne peut-elle pas servir de clé de dictionnaire, alors qu'un tuple le peut ?
2. Que fait `d[cle] = valeur` si la clé existe déjà ? Et si elle n'existe pas ?
3. Pourquoi `x in mon_set` est-il plus rapide que `x in ma_liste` sur de grosses collections ? (Intuition seulement ; on y reviendra en semaine 6.)
4. Comment obtenir une liste sans doublons qui **conserve l'ordre** ?

## 11. Bilan et préparation du jour 3

Tu disposes des quatre collections de base. Beaucoup de données arrivent sous forme de **texte** (saisies, fichiers, API), qu'il faut nettoyer, découper et reformater. Au jour 3, nous étudierons en détail les chaînes de caractères et leurs méthodes.
