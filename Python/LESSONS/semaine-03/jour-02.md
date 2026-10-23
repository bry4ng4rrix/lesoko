# Semaine 3 · Jour 2 : les exceptions

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer ce qu'est une exception et lire une **traceback** complète ;
- intercepter une erreur avec `try`/`except` ;
- cibler un type d'exception précis, plutôt que tout attraper ;
- utiliser `else` et `finally` ;
- lever moi-même une exception avec `raise` ;
- choisir entre « vérifier avant » et « essayer puis gérer » ;
- reconnaître les exceptions courantes de Python.

## 2. Prérequis

- Jour 1 : fichiers.
- Semaine 2 : fonctions.

---

## 3. Cours

### 3.1 Qu'est-ce qu'une exception ?

Quand Python rencontre une situation qu'il ne peut pas traiter (une division par zéro, un fichier absent, une conversion impossible), il **lève une exception** : un objet qui décrit le problème. Si personne ne l'**intercepte**, le programme s'arrête et affiche une **traceback**.

**Analogie :** un employé tombe sur un problème qu'il ne sait pas gérer. Il le remonte à son chef. Si le chef ne sait pas non plus, il le remonte au directeur, et ainsi de suite. Si personne ne le prend en charge, l'entreprise s'arrête.

### 3.2 Lire une traceback

```python
def diviser(a, b):
    return a / b

def calculer_moyenne(total, nombre):
    return diviser(total, nombre)

print(calculer_moyenne(50, 0))
```

```
Traceback (most recent call last):
  File "/home/.../exemple.py", line 7, in <module>
    print(calculer_moyenne(50, 0))
          ~~~~~~~~~~~~~~~~^^^^^^^
  File "/home/.../exemple.py", line 5, in calculer_moyenne
    return diviser(total, nombre)
  File "/home/.../exemple.py", line 2, in diviser
    return a / b
           ~~^~~
ZeroDivisionError: division by zero
```

Méthode de lecture :
1. **Dernière ligne** : le **type** (`ZeroDivisionError`) et le **message**.
2. **Juste au-dessus** : la ligne exacte où l'erreur s'est produite (ligne 2, dans `diviser`).
3. **En remontant** : la chaîne des appels qui y a mené (`<module>` → `calculer_moyenne` → `diviser`). La plus récente est en bas.
4. La ligne `~~^~~` pointe l'endroit précis dans la ligne.

L'erreur **apparaît** dans `diviser`, mais sa **cause** se trouve peut-être ailleurs (qui a passé 0 ?). Remonter la pile permet de le découvrir.

### 3.3 `try` / `except`

```python
saisie = input("Un nombre : ")
try:
    nombre = int(saisie)
    print(f"Le double est {nombre * 2}")
except ValueError:
    print(f"'{saisie}' n'est pas un entier.")
print("Suite du programme")
```

- Python exécute le bloc `try`.
- Si une `ValueError` survient, il **saute immédiatement** au bloc `except ValueError`. Le reste du `try` est ignoré.
- S'il n'y a pas d'erreur, le bloc `except` est ignoré.
- Dans les deux cas, le programme **continue** après.

### 3.4 Cibler les exceptions

```python
try:
    a = int(input("a : "))
    b = int(input("b : "))
    print(a / b)
except ValueError:
    print("Il faut des entiers.")
except ZeroDivisionError:
    print("Division par zéro impossible.")
```

Plusieurs types dans un même `except` :

```python
except (ValueError, ZeroDivisionError):
    print("Calcul impossible.")
```

Récupérer l'objet exception pour afficher son message :

```python
except ValueError as erreur:
    print(f"Erreur : {erreur}")     # Erreur : invalid literal for int() with base 10: 'abc'
```

### 3.5 Ne jamais tout attraper aveuglément

```python
try:
    resultat = calculer(donnees)
except:                        # ← À ÉVITER
    print("Erreur")
```

Un `except` nu, ou `except Exception`, attrape **tout**, y compris tes fautes de frappe (`NameError`) et même Ctrl+C dans le cas du `except` nu. Le bug est alors masqué et tu ne sauras jamais ce qui s'est passé.

**Règle :** n'attrape que les exceptions **que tu sais traiter**, et place le **moins de code possible** dans le `try`.

### 3.6 `else` et `finally`

```python
try:
    f = open("donnees.txt", encoding="utf-8")
except FileNotFoundError:
    print("Fichier absent.")
else:
    # exécuté SEULEMENT si le try n'a levé aucune exception
    contenu = f.read()
    f.close()
    print(f"{len(contenu)} caractères lus.")
finally:
    # exécuté TOUJOURS, erreur ou non, même après un return
    print("Fin de la tentative de lecture.")
```

- `else` permet de garder le `try` minimal : seule l'instruction risquée y figure, et la suite normale va dans `else`.
- `finally` sert au **nettoyage** obligatoire (fermer une connexion, libérer une ressource). Avec les fichiers, `with` fait déjà ce travail.

Ordre complet : `try` → `except` (zéro ou plusieurs) → `else` (facultatif) → `finally` (facultatif).

### 3.7 Lever une exception : `raise`

Tes propres fonctions peuvent signaler qu'on les utilise mal :

```python
def retirer(solde, montant):
    """Renvoie le nouveau solde. Lève ValueError si le retrait est impossible."""
    if montant <= 0:
        raise ValueError("Le montant doit être positif.")
    if montant > solde:
        raise ValueError(f"Solde insuffisant ({solde}) pour retirer {montant}.")
    return solde - montant


try:
    solde = retirer(5000, 8000)
except ValueError as e:
    print(f"Opération refusée : {e}")
```

Pourquoi lever plutôt que faire `print` puis renvoyer `None` ? Parce que la fonction **ne sait pas** comment l'appelant veut réagir : afficher un message, réessayer, journaliser, ou renvoyer une erreur HTTP 400 en semaine 10. Elle signale le problème et l'appelant décide.

Pour tester qu'une fonction lève bien une exception, en attendant `pytest` (semaine 6) :

```python
try:
    retirer(100, -5)
    assert False, "Une ValueError aurait dû être levée"
except ValueError:
    pass
```

### 3.8 Vérifier avant ou essayer ?

| Approche | Exemple | Nom |
|---|---|---|
| Vérifier avant | `if saisie.isdigit(): n = int(saisie)` | LBYL (*Look Before You Leap*, « regarde avant de sauter ») |
| Essayer, puis gérer | `try: n = int(saisie) except ValueError: ...` | EAFP (*Easier to Ask Forgiveness than Permission*, « plus facile de demander pardon que la permission ») |

Python favorise souvent **EAFP** :
- `isdigit()` refuse `-5` et `3.5`, alors que `float()` sait les convertir ; vérifier soi-même revient à réécrire le travail de Python ;
- entre `if chemin.exists()` et `open(chemin)`, le fichier peut être supprimé par un autre programme ; `try` gère ce cas, pas `if`.

### 3.9 Exceptions courantes

| Exception | Cause typique |
|---|---|
| `ValueError` | Bon type, mauvaise valeur : `int("abc")` |
| `TypeError` | Mauvais type : `"a" + 1`, mauvais nombre d'arguments |
| `NameError` | Nom non défini (faute de frappe) |
| `IndexError` | Index hors limites d'une liste |
| `KeyError` | Clé absente d'un dictionnaire |
| `AttributeError` | Méthode ou attribut inexistant : `[1].upper()` |
| `ZeroDivisionError` | Division par zéro |
| `FileNotFoundError` | Fichier absent |
| `PermissionError` | Pas le droit de lire ou d'écrire |
| `UnicodeDecodeError` | Fichier lu avec le mauvais encodage |
| `KeyboardInterrupt` | Ctrl+C |
| `RecursionError` | Récursion trop profonde (semaine 6) |

Les exceptions forment une **hiérarchie**. Par exemple, `FileNotFoundError` et `PermissionError` sont des `OSError`. `except OSError` attrape les deux.

---

## 4. Exemples commentés

### Exemple A — Saisie robuste, version définitive

```python
def demander_nombre(message, minimum=None, maximum=None):
    """Redemande jusqu'à obtenir un float valide, dans les bornes si elles sont fournies."""
    while True:
        saisie = input(message).strip().replace(",", ".")
        try:
            valeur = float(saisie)
        except ValueError:
            print(f"« {saisie} » n'est pas un nombre.")
            continue
        if minimum is not None and valeur < minimum:
            print(f"Minimum : {minimum}.")
        elif maximum is not None and valeur > maximum:
            print(f"Maximum : {maximum}.")
        else:
            return valeur
```

Compare avec ta validation manuelle de la semaine 1 : `float()` gère déjà les négatifs, les décimaux, les espaces et même la notation `1e3`.

Attention : `float("nan")` et `float("inf")` sont acceptés. Teste-le, puis décide si tu dois les refuser.

### Exemple B — Charger un fichier avec une valeur de repli

```python
def charger_lignes(chemin):
    """Renvoie les lignes du fichier, ou une liste vide s'il n'existe pas."""
    try:
        with open(chemin, encoding="utf-8") as f:
            return f.read().splitlines()
    except FileNotFoundError:
        return []
```

Seule l'absence du fichier est un cas **normal** (premier lancement), et c'est donc la seule exception traitée. Une `PermissionError`, en revanche, signale un vrai problème : on la laisse remonter, pour qu'elle soit visible.

---

## 5. Erreurs courantes

| Mauvaise pratique | Pourquoi | Mieux |
|---|---|---|
| `except:` ou `except Exception:` partout | Masque les bugs | Cibler `ValueError`, `KeyError`… |
| `try` qui englobe 30 lignes | On ne sait plus quelle ligne a échoué | `try` minimal, et `else` pour la suite |
| `except ValueError: pass` | Erreur avalée en silence | Au minimum, informer ou journaliser |
| `print` dans une fonction métier au lieu de `raise` | L'appelant ne peut pas réagir | `raise ValueError("...")` |
| Utiliser une variable définie dans le `try` après un `except` qui ne fait pas `return`/`continue` | `NameError` | S'assurer que la variable existe dans tous les cas |
| `raise ValueError` sans message | Diagnostic difficile | Message précis, avec les valeurs en cause |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-03/jour-02/`

**Exercice 1 — Provoquer les erreurs (`ex1_provoquer.py`).** Écris une ligne qui provoque **chacune** des 10 premières exceptions du tableau 3.9. Entoure chaque ligne d'un `try`/`except` du **bon type**, qui affiche le nom et le message de l'exception. Indice : `type(e).__name__`.

**Exercice 2 — Traceback (`ex2_traceback.txt`).** Exécute ce code, recopie la traceback, puis réponds : quel est le type d'erreur ? Dans quelle fonction et à quelle ligne survient-elle ? Quelle est la **vraie cause** ? Quelle correction proposes-tu ?

```python
def prix_unitaire(produit, catalogue):
    return catalogue[produit]

def total_ligne(ligne, catalogue):
    produit, quantite = ligne.split(":")
    return prix_unitaire(produit, catalogue) * int(quantite)

catalogue = {"riz": 2800, "sel": 600}
for ligne in ["riz:2", "sel:5", "Riz:1"]:
    print(total_ligne(ligne, catalogue))
```

**Exercice 3 — Ordre d'exécution (`ex3_ordre.txt`).** Prédis l'affichage de `f(10)`, `f(0)` et `f("a")` :

```python
def f(x):
    try:
        print("A")
        r = 10 / x
        print("B")
    except ZeroDivisionError:
        print("C")
        return "zéro"
    else:
        print("D")
        return r
    finally:
        print("E")
```

## 7. Exercices intermédiaires

**Exercice 4 — Fonctions qui lèvent (`ex4_raise.py`).** Écris, avec des tests qui vérifient **aussi** les exceptions :
- `convertir_note(texte)` : renvoie un float entre 0 et 20, et lève une `ValueError` avec un message précis sinon ;
- `obtenir_prix(catalogue, produit)` : lève une `KeyError` avec le message `Produit inconnu : x` ;
- `diviser_equitablement(montant, nb_personnes)` : renvoie `(part, reste)`, et lève une `ValueError` si `nb_personnes <= 0`.

**Exercice 5 — Lecture tolérante (`ex5_tolerant.py`).** Le fichier `mesures.txt` contient une valeur par ligne, mais certaines sont corrompues (`12.5`, `abc`, ligne vide, `-3`, `1,5`, `14`). Écris `lire_mesures(chemin)`, qui renvoie `(valeurs, erreurs)` : la liste des floats valides et la liste des `(numero_ligne, contenu, raison)` pour les lignes rejetées. Le programme ne doit jamais planter, même si le fichier n'existe pas.

**Exercice 6 — Calculatrice, version 3 (`PROJECTS/semaine-01-calculatrice/`).** Remplace toute la validation manuelle de ta calculatrice par `try`/`except`. `calculer(a, op, b)` doit **lever** `ZeroDivisionError` ou `ValueError` (opérateur inconnu), et c'est l'interface qui les intercepte. Compare le nombre de lignes avant et après.

## 8. Défi — Robustesse d'un menu bancaire (`defi_banque.py`)

Reprends le distributeur de la semaine 1, jour 4, en séparant :
- une logique pure : `retirer(solde, montant)` et `deposer(solde, montant)`, qui **lèvent** des exceptions explicites ;
- une interface qui les intercepte et affiche les messages.

Ajoute la persistance du solde dans `solde.txt` :
- si le fichier est absent, on part du solde initial ;
- s'il est corrompu (contenu non numérique), on avertit l'utilisateur, on sauvegarde l'ancien fichier sous `solde.txt.bak` et on repart du solde initial ;
- Ctrl+C pendant le menu doit enregistrer le solde puis quitter proprement (indice : `KeyboardInterrupt` et `finally`).

## 8 bis. Corriger un bug (`bug_s3j2.py`)

```python
def lire_age():
    try:
        age = int(input("Âge : "))
        if age < 0:
            print("Âge négatif")
    except:
        print("Erreur de saisie")
    return age

def categorie(age):
    try:
        return ["enfant", "ado", "adulte"][age // 10]
    except Exception:
        return "adulte"

a = lire_age()
print(categorie(a))
```

Teste avec `abc`, `-5`, `15` et `45`. Identifie au moins quatre problèmes de conception, et pas seulement des plantages. Propose une réécriture.

## 9. Critères de réussite

- [ ] Je lis une traceback de bas en haut et je trouve la vraie cause.
- [ ] Je n'écris jamais `except:` nu.
- [ ] Mes blocs `try` sont courts.
- [ ] Mes fonctions métier lèvent des exceptions, et l'interface les intercepte.
- [ ] Je teste aussi les cas d'erreur de mes fonctions.

## 10. Questions de révision

1. Dans quel ordre s'exécutent `try`, `except`, `else` et `finally` quand il n'y a pas d'erreur ? Et quand il y en a une ?
2. Pourquoi `except Exception:` est-il dangereux ?
3. Pourquoi une fonction métier devrait-elle lever une exception plutôt qu'afficher un message ?
4. Explique LBYL et EAFP, avec un exemple où EAFP est supérieur.

## 11. Bilan et préparation du jour 3

Sauvegarder une simple liste dans un fichier texte est facile. Mais comment sauvegarder un **dictionnaire de listes**, ou une **liste de dictionnaires** ? Il faudrait inventer un format, puis l'analyser. Le format **JSON** résout ce problème, et c'est aussi le format des API web. C'est le sujet du jour 3.
