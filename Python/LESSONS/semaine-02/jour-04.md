# Semaine 2 · Jour 4 : les fonctions

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer à quoi sert une fonction ;
- définir une fonction avec `def` et l'appeler ;
- distinguer **paramètre** et **argument** ;
- renvoyer un résultat avec `return`, et comprendre ce qu'est `None` ;
- distinguer `print` et `return` ;
- utiliser des arguments **par défaut** et des arguments **nommés** ;
- documenter une fonction avec une **docstring** ;
- tester une fonction avec `assert`.

## 2. Prérequis

- Jours 1 à 3. Les méthodes comme `.upper()` sont déjà des fonctions : aujourd'hui, tu écris les tiennes.

---

## 3. Cours

### 3.1 Le problème

Dans ta calculatrice, le bloc qui valide un nombre apparaît deux fois. Si tu y trouves un bug, il faut le corriger à deux endroits, et tu en oublieras un. Le programme est aussi long et difficile à lire d'un coup d'œil.

Une **fonction** est un bloc de code **nommé** et **réutilisable**. Elle :
- évite la duplication (on écrit une fois et on appelle partout) ;
- donne un **nom** à une intention (`calculer_moyenne` est plus parlant que 5 lignes de boucle) ;
- permet de **tester** un morceau isolément.

**Analogie :** une recette de cuisine. On l'écrit une fois (la définition), puis on la suit chaque fois qu'on en a besoin (l'appel), avec des ingrédients différents (les arguments), et on obtient un plat (la valeur de retour).

### 3.2 Définir et appeler

```python
def saluer():
    print("Bonjour !")

saluer()      # Bonjour !
saluer()      # Bonjour !
```

- `def` introduit la définition, suivi du nom, des parenthèses et de `:`.
- Le corps est indenté.
- **Définir n'exécute rien.** Le code ne s'exécute qu'à l'**appel** `saluer()`.
- Une fonction doit être définie **avant** d'être appelée, plus haut dans le fichier.

Nommage : `snake_case`, avec de préférence un **verbe** qui décrit l'action (`calculer_total`, `est_valide`, `afficher_menu`).

### 3.3 Paramètres et arguments

```python
def saluer(prenom):          # prenom est un PARAMÈTRE : une variable locale à la fonction
    print(f"Bonjour {prenom} !")

saluer("Aina")               # "Aina" est un ARGUMENT : la valeur transmise
saluer("Rado")
```

À l'appel, Python fait l'équivalent de `prenom = "Aina"`, puis exécute le corps.

Plusieurs paramètres :

```python
def presenter(prenom, age):
    print(f"{prenom} a {age} ans")

presenter("Fara", 22)        # arguments POSITIONNELS : dans l'ordre
presenter(age=22, prenom="Fara")   # arguments NOMMÉS : l'ordre est libre
presenter("Fara")            # TypeError: presenter() missing 1 required positional argument: 'age'
```

### 3.4 `return` : renvoyer un résultat

```python
def carre(x):
    return x * x

resultat = carre(5)        # l'appel est REMPLACÉ par la valeur renvoyée : 25
print(carre(3) + carre(4)) # 25
```

- `return` **termine immédiatement** la fonction et renvoie la valeur à l'appelant.
- Le code placé après un `return` exécuté n'est jamais atteint.
- On peut avoir plusieurs `return`, par exemple un par branche d'un `if`.

```python
def valeur_absolue(x):
    if x < 0:
        return -x
    return x               # pas besoin de else : si on arrive ici, x >= 0
```

### 3.5 `print` ou `return` ?

C'est **la** confusion des débutants.

```python
def aire_avec_print(l, L):
    print(l * L)

def aire_avec_return(l, L):
    return l * L

a = aire_avec_print(3, 4)    # affiche 12
print(a)                     # None !

b = aire_avec_return(3, 4)   # n'affiche rien
print(b * 2)                 # 24
```

- `print` **montre** une valeur à l'humain. Le programme ne peut pas la réutiliser.
- `return` **donne** une valeur au programme, qui peut la stocker, la calculer ou la tester.

**Règle :** une fonction de calcul **renvoie** sa valeur. On affiche à l'extérieur, au moment voulu. Une fonction qui calcule **et** affiche est plus difficile à réutiliser et à tester.

### 3.6 `None`

Une fonction sans `return`, ou avec un `return` seul, renvoie `None`, la valeur spéciale qui signifie « rien ».

```python
def rien():
    pass          # pass : bloc vide autorisé

print(rien())     # None
print(type(None)) # <class 'NoneType'>
```

Pour tester `None`, on écrit `if x is None:`, et non `== None`.

### 3.7 Renvoyer plusieurs valeurs

```python
def min_max(nombres):
    return min(nombres), max(nombres)    # renvoie un TUPLE

plus_petit, plus_grand = min_max([4, 1, 9])   # décomposition
print(plus_petit, plus_grand)                 # 1 9
```

### 3.8 Paramètres par défaut

```python
def calculer_ttc(prix_ht, taux_tva=0.20):
    return prix_ht * (1 + taux_tva)

calculer_ttc(1000)          # 1200.0 : taux par défaut
calculer_ttc(1000, 0.05)    # 1050.0
calculer_ttc(1000, taux_tva=0.1)   # nommé, plus lisible
```

Les paramètres avec une valeur par défaut viennent **après** ceux qui n'en ont pas : `def f(a=1, b):` provoque une `SyntaxError`.

### 3.9 Documenter : la docstring

```python
def calculer_moyenne(notes):
    """Renvoie la moyenne arithmétique d'une liste de notes.

    Renvoie None si la liste est vide.
    """
    if not notes:
        return None
    return sum(notes) / len(notes)
```

La chaîne entre `"""` placée juste après `def` est la **docstring**. `help(calculer_moyenne)` l'affiche, et VS Code la montre au survol. Elle explique **quoi**, pas **comment** : ce que la fonction attend, ce qu'elle renvoie, et ses cas particuliers.

### 3.10 Tester avec `assert`

`assert condition` ne fait rien si la condition est vraie, et lève une `AssertionError` sinon. C'est le moyen le plus simple de vérifier une fonction :

```python
assert calculer_moyenne([10, 20]) == 15
assert calculer_moyenne([12]) == 12
assert calculer_moyenne([]) is None
print("Tous les tests passent")
```

Prends l'habitude de **commencer** par écrire ces lignes, avant le corps de la fonction. Elles décrivent ce que tu attends. C'est le début du développement piloté par les tests, que tu approfondiras en semaine 6.

---

## 4. Exemples commentés

### Exemple A — Valider un entier, enfin sans duplication

```python
def demander_entier(message, minimum, maximum):
    """Redemande une saisie jusqu'à obtenir un entier entre minimum et maximum (inclus)."""
    while True:
        saisie = input(message).strip()
        if not saisie.lstrip("-").isdigit():
            print("Ce n'est pas un entier.")
        elif not minimum <= int(saisie) <= maximum:
            print(f"Doit être entre {minimum} et {maximum}.")
        else:
            return int(saisie)      # return sort à la fois de la boucle et de la fonction


age = demander_entier("Âge : ", 0, 120)
note = demander_entier("Note : ", 0, 20)
print(age, note)
```

- Le `return` à l'intérieur du `while True` remplace le `break` : il sort de tout.
- `saisie.lstrip("-")` retire un éventuel signe moins, ce qui permet d'accepter les négatifs.
- La validation est écrite **une fois**. Corriger un bug ici le corrige partout.

### Exemple B — Fonctions qui s'appellent entre elles

```python
def est_voyelle(c):
    return c.lower() in "aeiouyàâéèêëîïôùûü"

def compter_voyelles(texte):
    total = 0
    for c in texte:
        if est_voyelle(c):
            total += 1
    return total

assert est_voyelle("A")
assert not est_voyelle("b")
assert compter_voyelles("Élève") == 3
assert compter_voyelles("") == 0
print(compter_voyelles("Bonjour le monde"))   # 6
```

`est_voyelle` renvoie directement le booléen de la comparaison. On évite le détour `if ...: return True else: return False`.

---

## 5. Erreurs courantes

| Code | Problème |
|---|---|
| `def f:` | `SyntaxError` : les parenthèses sont obligatoires |
| `resultat = f` (sans `()`) | `resultat` contient la **fonction** elle-même, pas son résultat |
| Fonction qui fait `print` au lieu de `return` | Le résultat est `None` à l'utilisation |
| Code après `return` | Jamais exécuté |
| `return` dans une boucle, mal indenté | La fonction s'arrête au premier tour |
| Appel avant la définition | `NameError` |
| `def f(a=1, b):` | `SyntaxError: parameter without a default follows parameter with a default` |
| `if resultat == None:` | Fonctionne, mais on écrit `is None` |

Exemple du piège « `return` dans la boucle » :

```python
def contient_negatif(nombres):
    for n in nombres:
        if n < 0:
            return True
        else:
            return False      # BUG : on ne regarde que le premier élément
```

Le `return False` doit se trouver **après** la boucle, quand tous les éléments ont été vérifiés.

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-02/jour-04/`. Pour chaque exercice, écris **d'abord** les `assert` fournis, puis la fonction.

**Exercice 1 — Fonctions simples (`ex1_simples.py`).**

```python
assert est_pair(4) and not est_pair(7) and est_pair(0)
assert celsius_vers_fahrenheit(100) == 212
assert maximum(3, 9) == 9 and maximum(-1, -5) == -1   # sans max()
assert initiales("jean paul") == "J.P."
print("OK")
```

**Exercice 2 — print ou return (`ex2_print_return.txt`).** Prédis l'affichage, puis explique chaque ligne :

```python
def f(x):
    print(x * 2)

def g(x):
    return x * 2

a = f(3)
b = g(3)
print(a, b)
print(g(g(2)))
print(f(f(2)))
```

**Exercice 3 — Paramètres par défaut (`ex3_defaut.py`).** Écris `formater_prix(montant, devise="Ar", decimales=0)`.

```python
assert formater_prix(2500) == "2 500 Ar"
assert formater_prix(12.5, "€", 2) == "12,50 €"
assert formater_prix(1234567.891, decimales=1) == "1 234 567,9 Ar"
```

## 7. Exercices intermédiaires

**Exercice 4 — Bibliothèque de listes (`ex4_listes.py`).** Sans utiliser `sum`, `max`, `min`, `sorted` ni `.count`, écris ces fonctions ainsi que leurs tests, au moins 3 `assert` chacune, dont un cas limite :
- `somme(nombres)` ;
- `position_max(nombres)` : l'index du premier maximum, ou `None` si la liste est vide ;
- `compter(liste, valeur)` ;
- `filtrer_superieurs(nombres, seuil)` : une nouvelle liste ;
- `moyenne(nombres)` : `None` si la liste est vide.

**Exercice 5 — Mot de passe (`ex5_mdp.py`).** Écris `verifier_mot_de_passe(mdp)`, qui renvoie une **liste** de messages d'erreur (vide si le mot de passe est valide) : au moins 8 caractères, une majuscule, une minuscule, un chiffre, un caractère spécial, et aucun espace. Décompose ton code en petites fonctions (`contient_majuscule(mdp)`, etc.).

```python
assert verifier_mot_de_passe("Secret#2026") == []
assert "au moins 8 caractères" in verifier_mot_de_passe("Ab1#")
assert len(verifier_mot_de_passe("abc")) == 4
```

Avant d'exécuter, vérifie à la main que `"abc"` enfreint bien exactement 4 règles.

**Exercice 6 — Refactoriser la calculatrice (`PROJECTS/semaine-01-calculatrice/`).** Reprends ta calculatrice de la semaine 1 et extrais au moins trois fonctions : `est_nombre(texte)`, `demander_nombre(message)` et `calculer(a, operateur, b)`. `calculer` ne doit faire **ni `input` ni `print`**. Écris des `assert` pour `est_nombre` et `calculer`. Conserve l'ancienne version dans un fichier séparé pour comparer.

## 8. Défi — Conversion de chiffres en lettres (`defi_lettres.py`)

Écris `en_lettres(n)` pour `0 <= n <= 999`, en français :

```python
assert en_lettres(0) == "zéro"
assert en_lettres(17) == "dix-sept"
assert en_lettres(21) == "vingt et un"
assert en_lettres(70) == "soixante-dix"
assert en_lettres(80) == "quatre-vingts"
assert en_lettres(91) == "quatre-vingt-onze"
assert en_lettres(100) == "cent"
assert en_lettres(200) == "deux cents"
assert en_lettres(342) == "trois cent quarante-deux"
```

Les règles françaises sont irrégulières : c'est un excellent exercice de **décomposition**. Commence par `unites(n)` pour 0 à 16, puis traite 17 à 99, puis les centaines. Ajoute 10 tests de ton choix.

## 8 bis. Corriger un bug (`bug_s2j4.py`)

```python
def moyenne(notes):
    total = 0
    for note in notes:
        total += note
        return total / len(notes)

def mention(moy):
    if moy >= 16:
        print("Très bien")
    elif moy >= 10:
        print("Admis")
    else:
        print("Ajourné")

m = moyenne([12, 18, 15])
resultat = mention(m)
print(f"Moyenne {m:.2f} : {resultat}")
```

Attendu : `Moyenne 15.00 : Admis`. Trouve les deux bugs, puis indique ce qu'il se passe avec une liste vide et propose une solution.

## 9. Critères de réussite

- [ ] Mes fonctions de calcul utilisent `return`, pas `print`.
- [ ] Chaque fonction a un nom-verbe explicite et une docstring.
- [ ] J'écris les `assert` **avant** le corps de la fonction.
- [ ] Je teste au moins un cas limite par fonction (vide, zéro, négatif…).
- [ ] Je ne mets jamais un `return False` dans une boucle par erreur.

## 10. Questions de révision

1. Quelle est la différence entre un paramètre et un argument ?
2. Que renvoie une fonction sans `return` ? Comment le vérifier ?
3. Pourquoi une fonction de calcul ne devrait-elle pas faire de `print` ?
4. Pourquoi le paramètre `taux_tva=0.20` doit-il être placé après `prix_ht` ?

## 11. Bilan et préparation du jour 5

Tu sais créer des fonctions. Il reste des questions importantes : une variable créée dans une fonction existe-t-elle à l'extérieur ? Que se passe-t-il quand on passe une **liste** à une fonction qui la modifie ? Au jour 5 : la **portée** des variables, la mutabilité des arguments, les **compréhensions de listes** et la décomposition d'un problème en fonctions.
