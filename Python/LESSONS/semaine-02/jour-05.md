# Semaine 2 · Jour 5 : portée, mutabilité, compréhensions et décomposition

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- distinguer variables **locales** et **globales** ;
- expliquer pourquoi `global` est à éviter ;
- prévoir l'effet d'une fonction sur une liste qu'on lui passe ;
- éviter le piège de la liste comme valeur par défaut ;
- écrire des **compréhensions** de listes, d'ensembles et de dictionnaires ;
- décomposer un problème en petites fonctions testables.

## 2. Prérequis

- Jour 4 : fonctions, `return`, `assert`.

---

## 3. Cours

### 3.1 La portée des variables

**Le problème :** si toutes les variables étaient visibles partout, une fonction pourrait écraser par accident une variable du reste du programme. Python isole donc les variables de chaque fonction.

```python
def calculer():
    resultat = 42          # variable LOCALE : n'existe que pendant l'appel
    return resultat

calculer()
print(resultat)            # NameError: name 'resultat' is not defined
```

Les **paramètres** sont aussi des variables locales.

Une variable définie hors de toute fonction est **globale**. Une fonction peut la **lire** :

```python
TAUX_TVA = 0.20            # constante globale : la lire est acceptable

def ttc(prix):
    return prix * (1 + TAUX_TVA)
```

Mais une **affectation** dans une fonction crée une variable locale :

```python
compteur = 0

def incrementer():
    compteur = compteur + 1    # UnboundLocalError: cannot access local variable 'compteur'...

incrementer()
```

Comme `compteur` est affecté dans la fonction, Python le considère comme local **dans toute la fonction**. À droite du `=`, ce compteur local n'a pas encore de valeur.

**Analogie :** chaque appel de fonction travaille dans une pièce fermée. Il voit à travers la fenêtre ce qu'il y a dehors (lecture des globales), mais tout ce qu'il pose sur la table reste dans la pièce.

**Règle LEGB :** pour trouver un nom, Python cherche dans cet ordre : **L**ocal (la fonction), **E**nglobant (fonction parente), **G**lobal (le module), **B**uilt-in (`print`, `len`…).

Corollaire : n'appelle **jamais** une variable `list`, `str`, `sum`, `max` ou `input`. Tu masquerais la fonction intégrée :

```python
list = [1, 2]
list("abc")      # TypeError: 'list' object is not callable
```

### 3.2 `global` : à éviter

```python
compteur = 0
def incrementer():
    global compteur
    compteur += 1
```

Cela fonctionne, mais la fonction dépend alors d'un état caché. Elle devient difficile à tester et à comprendre. La bonne pratique est de **passer en paramètre et renvoyer** :

```python
def incrementer(compteur):
    return compteur + 1

compteur = incrementer(compteur)
```

Une fonction qui ne dépend que de ses paramètres et ne modifie rien à l'extérieur est une **fonction pure** : avec les mêmes entrées, elle donne toujours la même sortie. C'est la plus facile à tester.

### 3.3 Passer une liste à une fonction

Le paramètre reçoit **une référence vers le même objet**, comme pour `b = a` (jour 1).

```python
def ajouter_bonus(notes):
    notes.append(20)           # modifie la liste D'ORIGINE

mes_notes = [12, 15]
ajouter_bonus(mes_notes)
print(mes_notes)               # [12, 15, 20]
```

```python
def ajouter_bonus(notes):
    notes = notes + [20]       # crée une NOUVELLE liste, locale
    return notes

mes_notes = [12, 15]
nouvelles = ajouter_bonus(mes_notes)
print(mes_notes, nouvelles)    # [12, 15] [12, 15, 20]
```

- `.append`, `.sort`, `.remove` et `liste[i] = ...` **modifient** l'objet partagé.
- `=` **réattache** le nom local à un autre objet, sans effet à l'extérieur.

Choisis consciemment :
- soit la fonction **modifie** son argument et renvoie `None`, comme `list.sort()` ;
- soit elle renvoie un **nouvel** objet sans toucher à l'original, comme `sorted()`.

**Ne mélange pas les deux.** Indique ce choix dans le nom et la docstring.

### 3.4 Piège : liste comme valeur par défaut

```python
def ajouter(element, liste=[]):
    liste.append(element)
    return liste

print(ajouter("a"))    # ['a']
print(ajouter("b"))    # ['a', 'b']  ← surprise !
```

La valeur par défaut est créée **une seule fois**, au moment de la définition, puis partagée entre tous les appels. Solution standard :

```python
def ajouter(element, liste=None):
    if liste is None:
        liste = []
    liste.append(element)
    return liste
```

### 3.5 Compréhensions de listes

Le schéma « liste vide, boucle, `append` » est si courant qu'il existe une syntaxe dédiée :

```python
# Version boucle
carres = []
for n in range(1, 6):
    carres.append(n ** 2)

# Compréhension équivalente
carres = [n ** 2 for n in range(1, 6)]     # [1, 4, 9, 16, 25]
```

Lis-la comme : « la liste des `n ** 2` pour chaque `n` dans `range(1, 6)` ».

Avec un **filtre** :

```python
notes = [12, 8, 15, 9.5, 17]
admis = [n for n in notes if n >= 10]               # [12, 15, 17]
```

Avec une **transformation conditionnelle** : le `if ... else` se place **avant** le `for`.

```python
statuts = ["admis" if n >= 10 else "ajourné" for n in notes]
```

| Forme | Rôle |
|---|---|
| `[expr for x in seq]` | transformer chaque élément |
| `[expr for x in seq if cond]` | filtrer, puis transformer |
| `[a if cond else b for x in seq]` | choisir une valeur pour chaque élément |

**Compréhensions d'ensembles et de dictionnaires :**

```python
mots = ["Riz", "riz", "Sel", "SEL", "huile"]
uniques = {m.lower() for m in mots}                 # {'riz', 'sel', 'huile'}
longueurs = {m: len(m) for m in ["riz", "huile"]}   # {'riz': 3, 'huile': 5}

prix = {"riz": 2800, "sel": 600, "huile": 9500}
chers = {p: v for p, v in prix.items() if v > 1000} # {'riz': 2800, 'huile': 9500}
```

**Lisibilité d'abord :** si la compréhension dépasse une ligne ou contient plusieurs `for` et `if`, une boucle classique est préférable.

### 3.6 Décomposer un problème

Face à un problème, ne commence pas par le code. Procède ainsi :
1. **Reformule** le problème avec tes mots, avec un exemple d'entrée et de sortie.
2. **Liste les étapes** en français.
3. Chaque étape devient une **fonction** dont tu connais l'entrée et la sortie.
4. **Teste** chaque fonction isolément.
5. **Assemble** dans une fonction `main()`.

Exemple : « Afficher le classement des étudiants par moyenne, à partir de lignes `"Nom:12,15,9"`. »

| Étape | Fonction | Entrée → sortie |
|---|---|---|
| Découper une ligne | `analyser_ligne(ligne)` | `"Aina:12,15"` → `("Aina", [12.0, 15.0])` |
| Calculer la moyenne | `moyenne(notes)` | `[12.0, 15.0]` → `13.5` |
| Construire le classement | `classer(etudiants)` | dict → liste triée de `(nom, moyenne)` |
| Afficher | `afficher_classement(classement)` | liste → affichage (seule fonction avec `print`) |

### 3.7 La structure `main()`

```python
def main():
    ...

if __name__ == "__main__":
    main()
```

`__name__` vaut `"__main__"` quand le fichier est exécuté directement. Quand il est **importé** depuis un autre fichier (semaine 5), ce bloc n'est pas exécuté : on peut alors réutiliser les fonctions sans lancer le programme. Prends cette habitude dès maintenant.

---

## 4. Exemples commentés

### Exemple — Classement complet

```python
def analyser_ligne(ligne):
    """Transforme 'Nom:12,15' en ('Nom', [12.0, 15.0])."""
    nom, notes_texte = ligne.split(":")
    notes = [float(n) for n in notes_texte.split(",")]
    return nom.strip(), notes


def moyenne(notes):
    """Moyenne d'une liste non vide."""
    return sum(notes) / len(notes)


def classer(etudiants):
    """Renvoie une liste de (nom, moyenne) triée par moyenne décroissante."""
    moyennes = [(nom, moyenne(notes)) for nom, notes in etudiants.items()]
    return sorted(moyennes, key=lambda couple: couple[1], reverse=True)


def afficher_classement(classement):
    for rang, (nom, moy) in enumerate(classement, start=1):
        print(f"{rang}. {nom:<8} {moy:5.2f}")


def main():
    lignes = ["Aina:15,12,18", "Rado:11,14", "Fara:17,16,15"]
    etudiants = dict(analyser_ligne(l) for l in lignes)
    afficher_classement(classer(etudiants))


# Tests unitaires minimaux
assert analyser_ligne("Zo: 10,20") == ("Zo", [10.0, 20.0])
assert moyenne([10, 20]) == 15
assert classer({"A": [10], "B": [20]}) == [("B", 20), ("A", 10)]

if __name__ == "__main__":
    main()
```

Résultat :

```
1. Fara     16.00
2. Aina     15.00
3. Rado     12.50
```

- `for rang, (nom, moy) in enumerate(...)` : `enumerate` donne `(rang, (nom, moy))`, et on décompose les deux niveaux.
- `dict(...)` construit un dictionnaire à partir de couples `(clé, valeur)`.
- `key=lambda couple: couple[1]` indique à `sorted` de comparer selon la moyenne. Une `lambda` est une petite fonction anonyme d'une ligne, équivalente à `def cle(couple): return couple[1]`.
- **Seule** `afficher_classement` fait des `print` : les autres fonctions sont pures et donc testables.

---

## 5. Erreurs courantes

| Problème | Symptôme | Correction |
|---|---|---|
| Lire une variable locale hors de sa fonction | `NameError` | La renvoyer avec `return` |
| Affecter une globale dans une fonction | `UnboundLocalError` | Paramètre plus `return` |
| Variable nommée `list`, `sum`, `str` | `TypeError: ... is not callable` | Renommer |
| Fonction qui modifie une liste sans le dire | Effets de bord surprenants | Renvoyer une nouvelle liste, ou documenter |
| `def f(x, l=[])` | État partagé entre les appels | `l=None` puis création dans le corps |
| `[x for x in l if c else y]` | `SyntaxError` | `[x if c else y for x in l]` |
| Compréhension illisible sur 3 lignes | Code incompréhensible | Revenir à une boucle |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-02/jour-05/`

**Exercice 1 — Portée (`ex1_portee.txt`).** Prédis l'affichage ou l'erreur de chaque bloc, séparément :

```python
# Bloc A
x = 10
def f():
    x = 5
    return x
print(f(), x)

# Bloc B
def g():
    y = 1
g()
print(y)

# Bloc C
def h(liste):
    liste.append(99)
    liste = [0]
    liste.append(1)
    return liste
L = [5]
print(h(L), L)
```

**Exercice 2 — Compréhensions (`ex2_comprehensions.py`).** Avec des compréhensions uniquement :
1. les cubes des nombres impairs de 1 à 15 ;
2. à partir de `mots = ["Python", "est", "un", "langage", "clair"]`, les mots de plus de 3 lettres, en majuscules ;
3. la longueur de chaque mot dans un dictionnaire `{mot: longueur}` ;
4. l'ensemble des premières lettres, en minuscules ;
5. la liste `["pair", "impair", ...]` pour les nombres de 0 à 9.

**Exercice 3 — Réécriture (`ex3_reecriture.py`).** Réécris en compréhension, puis l'inverse :

```python
resultat = []
for prix in [1200, 450, 3000, 800]:
    if prix > 500:
        resultat.append(prix * 0.9)
```

```python
total = {p: q * 2 for p, q in {"a": 1, "b": 0, "c": 3}.items() if q}
```

## 7. Exercices intermédiaires

**Exercice 4 — Pur ou pas (`ex4_pure.py`).** Écris deux versions de `appliquer_remise` sur une liste de prix : `appliquer_remise_sur_place(prix, taux)` (modifie la liste, renvoie `None`) et `prix_remises(prix, taux)` (renvoie une nouvelle liste). Écris des `assert` qui **prouvent** que la seconde ne modifie pas l'original.

**Exercice 5 — Matrices (`ex5_matrices.py`).** Une matrice est une liste de listes : `m = [[1, 2, 3], [4, 5, 6]]`. Écris, avec des compréhensions et des tests :
- `transposer(m)`, qui donne `[[1, 4], [2, 5], [3, 6]]` ;
- `aplatir(m)`, qui donne `[1, 2, 3, 4, 5, 6]` (une compréhension à deux `for`) ;
- `creer_grille(lignes, colonnes, valeur)`. Explique pourquoi `[[0] * 3] * 2` est un piège : modifie un élément et observe le résultat.

**Exercice 6 — Décomposition (`ex6_decomposition.py`).** Problème : à partir de `ventes = ["2026-10-01;riz;3;2800", "2026-10-01;sel;10;600", "2026-10-02;riz;1;2800", ...]` (crée au moins 10 lignes), affiche le chiffre d'affaires par jour et par produit, ainsi que le produit le plus vendu en quantité. **Avant de coder**, écris le tableau de décomposition (étapes, fonctions, entrées et sorties) en commentaire. Une seule fonction affiche.

## 8. Défi — Jeu du pendu (`defi_pendu.py`)

Implémente le pendu avec ces fonctions, chacune testée par des `assert` (sauf celles qui font des `input`/`print`) :
- `masquer(mot, lettres_trouvees)` : `"python"`, `{"p", "o"}` → `"p _ _ _ o _"` ;
- `est_gagne(mot, lettres_trouvees)` ;
- `demander_lettre(deja_proposees)` : validation (une seule lettre, pas déjà proposée) ;
- `dessiner_pendu(erreurs)` : renvoie une chaîne multiligne par étape (de 0 à 6 erreurs) ;
- `jouer(mot)` : la boucle de jeu ;
- `main()` : choisit un mot dans une liste, propose de rejouer.

Les accents comptent : la lettre `e` doit-elle révéler `é` ? Prends une décision, documente-la et teste-la.

## 8 bis. Corriger un bug (`bug_s2j5.py`)

```python
total_general = 0

def ajouter_commande(montant, historique=[]):
    historique.append(montant)
    total_general = total_general + montant
    return historique

h1 = ajouter_commande(100)
h2 = ajouter_commande(250)
print(h1, h2, total_general)
```

Explique les deux problèmes, puis réécris le code **sans variable globale modifiée**. Attendu : deux historiques indépendants `[100]` et `[250]` et un total de 350.

## 9. Critères de réussite

- [ ] Je n'utilise pas `global`.
- [ ] Je sais prédire si une fonction modifie la liste qu'on lui passe.
- [ ] Je n'utilise jamais une liste comme valeur par défaut.
- [ ] Je choisis entre compréhension et boucle selon la lisibilité.
- [ ] Je décompose un problème **sur papier** avant de coder.
- [ ] Mes programmes ont une fonction `main()` et le bloc `if __name__ == "__main__":`.

## 10. Questions de révision

1. Pourquoi `compteur += 1` dans une fonction provoque-t-il une `UnboundLocalError` alors que `print(compteur)` fonctionne ?
2. Quelle différence y a-t-il entre `liste.append(x)` et `liste = liste + [x]` dans une fonction ?
3. Pourquoi `def f(l=[])` est-il dangereux ?
4. Qu'est-ce qu'une fonction pure, et pourquoi est-elle plus facile à tester ?

## 11. Bilan et préparation du jour 6

Tu as maintenant tous les outils pour structurer un vrai programme : des données organisées en collections et une logique découpée en fonctions testées. Le jour 6 est consacré au projet **gestionnaire de notes d'étudiants** et à l'évaluation de la semaine 2.
