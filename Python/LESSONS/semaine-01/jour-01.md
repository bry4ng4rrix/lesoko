# Semaine 1 · Jour 1 : Python, le terminal et les premières valeurs

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer ce qu'est Python et ce qui se passe quand j'exécute un script ;
- vérifier mon installation de Python sous Linux ;
- écrire un script `.py` et le lancer depuis le terminal ;
- afficher du texte avec `print()`, y compris avec `sep` et `end` ;
- distinguer `str`, `int` et `float` ;
- faire des calculs avec `+ - * / // % **` ;
- créer, utiliser et réaffecter des variables ;
- lire les trois premiers messages d'erreur : `SyntaxError`, `NameError`, `TypeError`.

## 2. Prérequis

- Un terminal ouvert.
- VS Code installé.
- Aucune connaissance en Python.

---

## 3. Cours

### 3.1 Qu'est-ce que Python ?

Un ordinateur n'exécute que des instructions machine, de très bas niveau. Les écrire directement serait long et source d'erreurs. Un **langage de programmation** permet d'écrire des instructions lisibles par un humain, qu'un programme traduit ensuite pour la machine.

Python est un langage :
- **interprété** : un programme, l'**interpréteur** `python3`, lit ton code et l'exécute. Il n'y a pas d'étape de compilation à lancer à la main ;
- **lisible** : sa syntaxe est proche de l'anglais et l'indentation fait partie de la syntaxe ;
- **polyvalent** : scripts, automatisation, données, backend web (Django, FastAPI), etc.

**Analogie.** Ton script est une recette. L'interpréteur est le cuisinier : il lit la recette **ligne par ligne, de haut en bas**. S'il tombe sur une instruction incompréhensible, il s'arrête et te dit à quelle ligne.

### 3.2 Comment un programme s'exécute

```
bonjour.py  ──►  python3 (interpréteur)  ──►  bytecode  ──►  machine virtuelle Python  ──►  résultat
 (ton texte)       lit et vérifie              (interne)        exécute                     à l'écran
```

1. Tu écris du texte dans un fichier `.py`.
2. Tu tapes `python3 bonjour.py` dans le terminal.
3. L'interpréteur vérifie d'abord la **syntaxe** de tout le fichier. S'il trouve une faute de grammaire, il affiche `SyntaxError` et **rien ne s'exécute**.
4. Il traduit le code en **bytecode**, un format intermédiaire, puis l'exécute instruction par instruction.
5. Si une erreur survient pendant l'exécution (par exemple `NameError`), le programme s'arrête **à cette ligne**. Les lignes au-dessus ont déjà été exécutées.

Retiens la différence : une erreur de **syntaxe** empêche tout le fichier de démarrer, une erreur d'**exécution** l'arrête en cours de route.

### 3.3 Deux façons d'utiliser Python

| Mode | Commande | Usage |
|---|---|---|
| Interactif (REPL) | `python3` | Tester une ligne, explorer. Invite `>>>`. On quitte avec `exit()` ou Ctrl+D. |
| Script | `python3 fichier.py` | Le vrai travail : du code enregistré et réexécutable. |

Dans le REPL, taper une expression affiche sa valeur. Dans un script, **seul `print()` affiche quelque chose**.

### 3.4 Vérifier ton environnement Linux

Tape ces commandes **une par une** dans le terminal et observe le résultat :

```fish
python3 --version          # version de Python : on attend 3.10 ou plus
which python3              # chemin de l'exécutable, par exemple /usr/bin/python3
python3 -m pip --version   # pip, le gestionnaire de paquets (utilisé en semaine 5)
python3 -m venv --help     # venv, les environnements virtuels (semaine 5)
code --version             # VS Code depuis le terminal
```

Sur certaines distributions, `python` désigne encore Python 2 ou n'existe pas. **Utilise toujours `python3`** : c'est sans ambiguïté.

Dans VS Code, installe l'extension **Python** (éditeur : Microsoft). Elle apporte la coloration, la détection d'erreurs et le débogueur.

Crée ton dossier de travail du jour :

```fish
cd ~/Dev/formations/Python/EXERCISES/semaine-01/jour-01
code .
```

### 3.5 `print()` : afficher

`print()` est une **fonction** : un outil prêt à l'emploi qu'on appelle avec des parenthèses. Ce qu'on met entre les parenthèses s'appelle les **arguments**.

```python
print("Bonjour, Python !")
```

- `print` : le nom de la fonction.
- `( )` : l'appel. Sans parenthèses, rien n'est exécuté.
- `"Bonjour, Python !"` : l'argument, ici un texte.

Plusieurs arguments séparés par des virgules s'affichent avec un espace entre eux :

```python
print("Bonjour", "le", "monde")    # Bonjour le monde
```

Deux options utiles :
- `sep` : le séparateur entre les arguments (par défaut, un espace) ;
- `end` : ce qu'on ajoute à la fin (par défaut, un retour à la ligne `"\n"`).

```python
print("a", "b", "c", sep="-")      # a-b-c
print("Sans retour", end=" ")
print("à la ligne")                # Sans retour à la ligne
print()                            # ligne vide
```

### 3.6 Les commentaires

Tout ce qui suit `#` sur une ligne est ignoré par Python. Un commentaire sert à expliquer **pourquoi** on fait quelque chose, pas à répéter ce que le code dit déjà.

```python
# Ce script affiche un message de bienvenue
print("Bienvenue")  # commentaire en fin de ligne
```

### 3.7 Les chaînes de caractères (`str`)

Une **chaîne** est du texte entre guillemets, simples `'...'` ou doubles `"..."`.

```python
"Bonjour"
'Bonjour'                 # identique
"L'apostrophe passe"      # les doubles guillemets permettent d'écrire une apostrophe
"42"                      # c'est du TEXTE, pas un nombre
```

Opérations de base :

```python
"Py" + "thon"     # "Python"   concaténation : on colle deux textes
"ha" * 3          # "hahaha"   répétition
len("Python")     # 6          nombre de caractères
```

Caractères spéciaux : `"\n"` (retour à la ligne) et `"\t"` (tabulation).

### 3.8 Les nombres (`int` et `float`)

- `int` (*integer*) : nombre entier, comme `42`, `-7` ou `0`.
- `float` : nombre à virgule, écrit **avec un point** : `3.14`, `2.0`.

| Opérateur | Rôle | Exemple | Résultat |
|---|---|---|---|
| `+` | addition | `7 + 2` | `9` |
| `-` | soustraction | `7 - 2` | `5` |
| `*` | multiplication | `7 * 2` | `14` |
| `/` | division (toujours un `float`) | `7 / 2` | `3.5` |
| `//` | division entière | `7 // 2` | `3` |
| `%` | reste (modulo) | `7 % 2` | `1` |
| `**` | puissance | `2 ** 10` | `1024` |

Les priorités sont celles des mathématiques : `**` d'abord, puis `* / // %`, puis `+ -`. En cas de doute, ajoute des parenthèses.

**Exemple concret de `//` et `%` :** 7 bonbons à partager entre 2 enfants donnent `7 // 2 = 3` bonbons chacun, et il en reste `7 % 2 = 1`.

**Piège des `float` :**

```python
print(0.1 + 0.2)   # 0.30000000000000004
```

Ce n'est pas un bug de Python. Les ordinateurs stockent les décimaux en binaire, et `0.1` n'y est qu'une approximation. Nous verrons comment arrondir plus tard.

`type()` indique le type d'une valeur :

```python
print(type(42))      # <class 'int'>
print(type(3.14))    # <class 'float'>
print(type("42"))    # <class 'str'>
```

### 3.9 Les variables

**Le problème.** Si le prix d'un article apparaît dix fois dans ton programme et qu'il change, tu dois le modifier à dix endroits. Une variable donne un **nom** à une valeur : tu la définis une fois et tu la réutilises partout.

**Analogie.** Une variable est une étiquette collée sur une boîte. Le nom est l'étiquette, la valeur est le contenu.

```python
prenom = "Aina"
age = 25
print(prenom, "a", age, "ans")   # Aina a 25 ans
```

- `=` est l'**affectation** : on calcule ce qui est à droite, puis on le range sous le nom de gauche. **Ce n'est pas une égalité mathématique.**
- On peut **réaffecter** une variable : elle contient alors la nouvelle valeur.

```python
score = 10
score = score + 5    # on lit l'ancienne valeur (10), on ajoute 5, on range 15
print(score)         # 15
```

**Règles de nommage :**
- lettres, chiffres et `_`, sans commencer par un chiffre : `prix_ttc` est valide, `2prix` ne l'est pas ;
- pas d'espace ni de tiret : `prix ttc` et `prix-ttc` sont invalides ;
- sensibles à la casse : `Age` et `age` sont deux variables différentes ;
- convention Python : `snake_case`, en minuscules avec des underscores ;
- noms explicites : `prix_unitaire` plutôt que `p` ;
- évite les accents dans les noms, même si Python les accepte.

**Constantes par convention :** Python n'interdit pas de modifier une variable. Les majuscules signalent aux autres développeurs qu'on ne doit pas la changer.

```python
TAUX_TVA = 0.20
```

### 3.10 Mélanger texte et nombres : les f-strings

```python
age = 25
print("Âge : " + age)        # TypeError ! On ne peut pas additionner un str et un int
print("Âge :", age)          # OK : print accepte plusieurs arguments
print("Âge : " + str(age))   # OK : str() convertit le nombre en texte
print(f"Âge : {age} ans")    # OK et recommandé : f-string
```

Une **f-string** commence par `f` avant le guillemet. Tout ce qui est entre `{ }` est évalué puis inséré dans le texte. On peut y mettre un calcul : `f"Dans 10 ans : {age + 10}"`.

---

## 4. Exemples commentés

### Exemple A — Premier script complet

Fichier `exemple_a.py` :

```python
# Calcul du prix d'un achat
PRIX_UNITAIRE = 1500           # constante : prix d'un cahier
quantite = 4                   # nombre de cahiers achetés

total = PRIX_UNITAIRE * quantite
print("Quantité :", quantite)
print(f"Total à payer : {total}")
```

Exécution :

```fish
python3 exemple_a.py
```

Résultat attendu :

```
Quantité : 4
Total à payer : 6000
```

Ligne par ligne :
1. Commentaire, ignoré par Python.
2. On crée la constante `PRIX_UNITAIRE`, qui vaut l'entier `1500`.
3. On crée `quantite`, qui vaut `4`.
4. Ligne vide pour aérer, sans effet.
5. Python calcule `1500 * 4 = 6000` et le range dans `total`.
6. `print` reçoit deux arguments et les sépare par un espace.
7. La f-string remplace `{total}` par `6000`.

### Exemple B — Division et reste

```python
minutes_totales = 135
heures = minutes_totales // 60     # 2
minutes = minutes_totales % 60     # 15
print(f"{minutes_totales} min = {heures} h {minutes} min")
```

Résultat : `135 min = 2 h 15 min`

### Exemple C — Ordre d'exécution et réaffectation

```python
x = 3
y = x        # y reçoit la VALEUR de x à cet instant, c'est-à-dire 3
x = 10       # modifier x ne change pas y
print(x, y)  # 10 3
```

---

## 5. Erreurs courantes

| Code fautif | Message | Explication | Correction |
|---|---|---|---|
| `print("Bonjour)` | `SyntaxError: unterminated string literal` | Guillemet fermant manquant | `print("Bonjour")` |
| `Print("Bonjour")` | `NameError: name 'Print' is not defined` | Python distingue majuscules et minuscules | `print` |
| `print(prenon)` | `NameError: name 'prenon' is not defined. Did you mean: 'prenom'?` | Faute de frappe dans un nom de variable | Corriger le nom |
| `print("Âge : " + 25)` | `TypeError: can only concatenate str (not "int") to str` | On additionne un texte et un nombre | f-string ou `str(25)` |
| ` print("x")` (espace au début) | `IndentationError: unexpected indent` | L'indentation a un sens en Python | Retirer l'espace |
| `prix = 3,5` | Aucune erreur, mais `prix` vaut `(3, 5)` | La virgule ne sert pas de séparateur décimal | `3.5` |
| `python bonjour.py` | `command not found` ou Python 2 | Mauvaise commande | `python3 bonjour.py` |

**Lire un message d'erreur :** commence par la **dernière ligne** (le type et le message), puis remonte pour trouver le **numéro de ligne** (`line 3`). Python 3.14 suggère souvent une correction avec `Did you mean ...?`.

---

Les exercices de ce jour se trouvent dans `EXERCISES/semaine-01/jour-01/README.md`.
