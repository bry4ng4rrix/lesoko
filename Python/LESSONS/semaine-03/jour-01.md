# Semaine 3 · Jour 1 : lire et écrire des fichiers texte

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer pourquoi un programme a besoin de fichiers ;
- ouvrir un fichier avec `open()` dans les modes `r`, `w`, `a` et `x` ;
- utiliser `with` pour garantir la fermeture du fichier ;
- toujours préciser `encoding="utf-8"` et expliquer pourquoi ;
- lire un fichier en entier, ligne par ligne, ou sous forme de liste ;
- écrire et ajouter du texte ;
- comprendre les chemins relatifs et absolus, et utiliser `pathlib`.

## 2. Prérequis

- Semaine 2 : chaînes (`strip`, `split`, `join`), listes, fonctions.

---

## 3. Cours

### 3.1 Le problème : la mémoire est volatile

Les variables vivent dans la **mémoire vive** (RAM), qui est effacée quand le programme se termine. Pour **conserver** des données (les notes, les dépenses, un historique), il faut les écrire sur le **disque**, dans un fichier.

**Analogie :** la RAM est un tableau blanc, effacé à chaque fin de réunion. Un fichier est un cahier rangé dans une armoire.

### 3.2 Ouvrir, lire, fermer

```python
fichier = open("notes.txt", "r", encoding="utf-8")
contenu = fichier.read()
fichier.close()
print(contenu)
```

1. `open(chemin, mode, encoding)` ouvre le fichier et renvoie un **objet fichier**.
2. `.read()` lit tout le contenu sous forme d'une seule chaîne.
3. `.close()` libère le fichier. Si on l'oublie, ou si une erreur survient avant, le fichier peut rester verrouillé, et des données écrites peuvent ne pas être enregistrées.

### 3.3 `with` : la bonne façon

```python
with open("notes.txt", "r", encoding="utf-8") as fichier:
    contenu = fichier.read()
# ici, le fichier est automatiquement fermé, même en cas d'erreur
print(contenu)
```

`with` est un **gestionnaire de contexte** : il ferme le fichier à la sortie du bloc, quoi qu'il arrive. **Utilise toujours `with`** pour les fichiers.

### 3.4 Les modes d'ouverture

| Mode | Signification | Si le fichier existe | S'il n'existe pas |
|---|---|---|---|
| `"r"` | lecture (par défaut) | lit | `FileNotFoundError` |
| `"w"` | écriture | **efface tout** puis écrit | le crée |
| `"a"` | ajout (*append*) | écrit à la fin | le crée |
| `"x"` | création exclusive | `FileExistsError` | le crée |

Le mode `"w"` est **destructeur** : ouvrir un fichier en `"w"` le vide immédiatement, même si tu n'écris rien ensuite.

### 3.5 L'encodage : pourquoi `utf-8` ?

Un fichier ne contient que des **octets**. L'**encodage** est la table qui convertit les caractères en octets et inversement. UTF-8 est le standard universel : il gère les accents, les symboles (€, ₹…) et toutes les langues.

Sans `encoding=`, Python utilise l'encodage par défaut du système, qui peut différer sur Windows. Un fichier écrit sur une machine s'affichera alors avec des caractères corrompus sur une autre (`Ã©` au lieu de `é`). Préciser `encoding="utf-8"` rend ton programme **portable**. Fais-le **toujours**.

### 3.6 Lire un fichier

Crée d'abord `courses.txt` :

```
riz
lait
œufs
```

```python
# 1. Tout d'un coup, en une chaîne
with open("courses.txt", encoding="utf-8") as f:
    texte = f.read()            # 'riz\nlait\nœufs\n'

# 2. Ligne par ligne : la méthode la plus économe en mémoire
with open("courses.txt", encoding="utf-8") as f:
    for ligne in f:
        print(ligne.strip())    # strip retire le '\n' final

# 3. En liste de lignes
with open("courses.txt", encoding="utf-8") as f:
    lignes = f.read().splitlines()   # ['riz', 'lait', 'œufs'] sans les '\n'
```

Chaque ligne lue **se termine par `\n`** (sauf parfois la dernière). Sans `.strip()`, `print(ligne)` affiche une ligne vide supplémentaire, puisque `print` ajoute son propre retour à la ligne.

`f.readlines()` renvoie aussi une liste, mais en gardant les `\n`. `splitlines()` est souvent plus pratique.

### 3.7 Écrire dans un fichier

```python
articles = ["riz", "lait", "œufs"]

with open("courses.txt", "w", encoding="utf-8") as f:
    for article in articles:
        f.write(article + "\n")      # write n'ajoute PAS de retour à la ligne
```

Variantes :

```python
with open("courses.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(articles) + "\n")

with open("journal.txt", "a", encoding="utf-8") as f:
    print("Nouvelle entrée", file=f)   # print peut écrire dans un fichier
```

`f.write()` n'accepte que des chaînes. Pour un nombre, écris `f.write(str(42))` ou utilise une f-string.

### 3.8 Chemins de fichiers

Un **chemin relatif** comme `"notes.txt"` est interprété depuis le **répertoire courant**, c'est-à-dire **là où tu as lancé la commande**, pas forcément là où se trouve le script.

```fish
cd ~/Dev/formations/Python
python3 EXERCISES/semaine-03/jour-01/lire.py   # cherche notes.txt dans ~/Dev/formations/Python !
```

Pour que ton script trouve ses fichiers où qu'on le lance, utilise `pathlib` :

```python
from pathlib import Path

DOSSIER = Path(__file__).parent          # le dossier qui contient le script
chemin = DOSSIER / "notes.txt"           # l'opérateur / assemble les chemins

print(chemin)                            # chemin complet
print(chemin.exists())                   # True ou False
print(chemin.name, chemin.suffix)        # notes.txt .txt

texte = chemin.read_text(encoding="utf-8")        # lecture en une ligne
chemin.write_text("contenu\n", encoding="utf-8")  # écriture en une ligne (écrase)
```

`from pathlib import Path` est un **import** de la bibliothèque standard. Les imports seront détaillés en semaine 5 : pour l'instant, retiens que cette ligne rend `Path` disponible. Elle se place en haut du fichier.

Sous Linux, un chemin **absolu** commence par `/` (`/home/garrix/...`) et `~` désigne ton dossier personnel dans le terminal, mais **pas** dans Python. En Python, écris `Path.home()`.

---

## 4. Exemples commentés

### Exemple A — Journal horodaté

```python
from datetime import datetime
from pathlib import Path

JOURNAL = Path(__file__).parent / "journal.txt"


def ajouter_entree(texte):
    """Ajoute une ligne horodatée à la fin du journal."""
    horodatage = datetime.now().strftime("%Y-%m-%d %H:%M")
    with open(JOURNAL, "a", encoding="utf-8") as f:
        f.write(f"[{horodatage}] {texte}\n")


def lire_journal():
    """Renvoie la liste des entrées, ou une liste vide si le journal n'existe pas."""
    if not JOURNAL.exists():
        return []
    with open(JOURNAL, encoding="utf-8") as f:
        return f.read().splitlines()


ajouter_entree("Début de la semaine 3")
for entree in lire_journal():
    print(entree)
```

- Le mode `"a"` permet de conserver les entrées précédentes à chaque exécution.
- `JOURNAL.exists()` évite une `FileNotFoundError` au premier lancement. Au jour 2, nous verrons une meilleure méthode avec `try`/`except`.
- `datetime.now().strftime(...)` formate la date. `%Y`, `%m`, `%d`, `%H` et `%M` sont des codes de format, documentés dans `datetime`.

### Exemple B — Statistiques sur un fichier texte

```python
def statistiques_fichier(chemin):
    """Renvoie (nb_lignes, nb_mots, nb_caracteres) d'un fichier texte."""
    nb_lignes = nb_mots = nb_car = 0
    with open(chemin, encoding="utf-8") as f:
        for ligne in f:
            nb_lignes += 1
            nb_mots += len(ligne.split())
            nb_car += len(ligne)
    return nb_lignes, nb_mots, nb_car
```

C'est l'équivalent de la commande Linux `wc`. Compare : `wc courses.txt`. `wc -m` compte les caractères. Les résultats doivent concorder.

---

## 5. Erreurs courantes

| Problème | Message ou symptôme | Correction |
|---|---|---|
| Fichier introuvable | `FileNotFoundError: [Errno 2] No such file or directory` | Vérifier le répertoire courant (`pwd`), utiliser `Path(__file__).parent` |
| Mode `"w"` au lieu de `"a"` | Données précédentes effacées | Choisir le mode avec soin |
| Oubli de `\n` avec `write` | Tout sur une seule ligne | `f.write(texte + "\n")` |
| Lignes affichées avec une ligne vide entre chaque | Le `\n` de la ligne s'ajoute à celui de `print` | `ligne.strip()` ou `rstrip("\n")` |
| `f.write(42)` | `TypeError: write() argument must be str, not int` | `str(42)` |
| Pas d'`encoding` | Accents corrompus sur une autre machine | `encoding="utf-8"` |
| Lire après la fin du `with` | `ValueError: I/O operation on closed file` | Lire **dans** le bloc |
| Lire deux fois `f.read()` | La seconde lecture renvoie `""` | Le curseur est à la fin : stocker le résultat |
| `IsADirectoryError` | Le chemin désigne un dossier | Vérifier le chemin |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-03/jour-01/`

**Exercice 1 — Écrire puis relire (`ex1_ecrire_lire.py`).** Écris la table de multiplication de 7 dans `table7.txt` (une ligne par opération), puis relis le fichier et affiche uniquement les lignes dont le résultat est pair.

**Exercice 2 — Modes (`ex2_modes.txt` et `ex2_modes.py`).** Prédis, puis vérifie, le contenu final de `test.txt` après ce code. Explique chaque étape.

```python
with open("test.txt", "w", encoding="utf-8") as f:
    f.write("A\n")
with open("test.txt", "a", encoding="utf-8") as f:
    f.write("B\n")
with open("test.txt", "w", encoding="utf-8") as f:
    pass
with open("test.txt", "a", encoding="utf-8") as f:
    f.write("C")
```

**Exercice 3 — Mini `wc` (`ex3_wc.py`).** Écris `compter(chemin)`, qui renvoie le nombre de lignes, de mots et de caractères, et compare ses résultats avec la commande Linux `wc` sur 3 fichiers, dont un cours de ce dépôt.

## 7. Exercices intermédiaires

**Exercice 4 — Liste de courses persistante (`ex4_courses.py`).** Reprends l'idée de la liste de tâches (semaine 2, jour 1) : au démarrage, le programme charge `courses.txt` s'il existe, puis propose un menu (afficher, ajouter, retirer, quitter). À chaque modification, le fichier est réécrit. Quitter puis relancer doit retrouver la liste.

**Exercice 5 — Recherche dans un fichier (`ex5_grep.py`).** Écris `chercher(chemin, motif)`, qui renvoie une liste de tuples `(numero_ligne, ligne)` contenant le motif, sans tenir compte de la casse. Affiche le résultat comme `grep -n -i`. Teste-la sur `LESSONS/semaine-02/jour-04.md` avec le motif `return`, et compare avec `grep -n -i return`.

**Exercice 6 — Copie transformée (`ex6_transformer.py`).** Lis un fichier texte et écris dans un **autre** fichier :
- les lignes vides supprimées ;
- les espaces multiples réduits à un seul ;
- chaque ligne préfixée par son numéro sur 3 chiffres (`001 | ...`).

Ne modifie jamais le fichier source.

## 8. Défi — Carnet de vocabulaire (`defi_vocabulaire.py`)

Le fichier `vocabulaire.txt` contient des lignes `mot = traduction`, par exemple `chat = saka`. Le programme :
1. charge le fichier dans un dictionnaire, en ignorant les lignes vides, les lignes de commentaire (`#`) et les lignes mal formées (qu'il signale avec leur numéro) ;
2. propose un menu : ajouter un mot, chercher dans les deux sens, faire un quiz de 5 mots au hasard (`import random`, `random.sample(liste, 5)`), afficher le score ;
3. enregistre les ajouts **sans réécrire tout le fichier** (pense au mode d'ouverture) ;
4. conserve l'historique des scores dans un second fichier `scores.txt`, avec la date.

## 8 bis. Corriger un bug (`bug_s3j1.py`)

```python
def sauvegarder(taches):
    for tache in taches:
        with open("taches.txt", "w") as f:
            f.write(tache)

def charger():
    with open("taches.txt") as f:
        lignes = f.readlines()
    return lignes

sauvegarder(["Réviser", "Coder", "Tester"])
print(charger())
```

Attendu : `['Réviser', 'Coder', 'Tester']`. Liste **tous** les problèmes : il y en a au moins trois, dont un qui ne se voit que sur une autre machine.

## 9. Critères de réussite

- [ ] J'utilise toujours `with` et `encoding="utf-8"`.
- [ ] Je choisis le mode d'ouverture en connaissant ses conséquences.
- [ ] Mes scripts trouvent leurs fichiers quel que soit le dossier de lancement.
- [ ] Je gère le cas « le fichier n'existe pas encore ».
- [ ] Je nettoie les `\n` à la lecture et je les ajoute à l'écriture.

## 10. Questions de révision

1. Pourquoi `with` est-il préférable à `open` puis `close` ?
2. Que se passe-t-il si on ouvre en `"w"` un fichier contenant des données importantes ?
3. Pourquoi faut-il préciser l'encodage ?
4. Quelle différence y a-t-il entre le dossier du script et le répertoire courant ?

## 11. Bilan et préparation du jour 2

Tu as rencontré plusieurs erreurs qui font planter un programme : `FileNotFoundError`, `ValueError`… Jusqu'ici, tu les évitais en testant **avant** (`exists()`, `isdigit()`). Au jour 2, nous verrons comment les **intercepter** avec `try`/`except`, une approche plus robuste et plus générale.
