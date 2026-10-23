# Semaine 2 · Jour 3 : les chaînes de caractères en profondeur

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer pourquoi une chaîne est **immuable** et ce que cela implique ;
- nettoyer une saisie (`strip`, `lower`, `replace`) ;
- découper et assembler du texte (`split`, `join`) ;
- rechercher dans un texte (`in`, `find`, `count`, `startswith`, `endswith`) ;
- tester la nature d'un texte (`isdigit`, `isalpha`, `isalnum`, `isupper`…) ;
- formater un affichage avec les f-strings (alignement, décimales, séparateur de milliers) ;
- écrire des chaînes sur plusieurs lignes.

## 2. Prérequis

- Jours 1 et 2 : index, tranches, listes, dictionnaires.

---

## 3. Cours

### 3.1 Pourquoi s'attarder sur les chaînes ?

Presque toutes les données entrent dans un programme sous forme de texte : saisies au clavier, fichiers CSV, réponses d'API, formulaires web. Les utilisateurs tapent `"  Fara "`, `"FARA"` ou `"fara"` pour désigner la même personne. Savoir **normaliser** et **découper** du texte est une compétence quotidienne.

### 3.2 Les chaînes sont immuables

```python
mot = "python"
mot[0] = "P"          # TypeError: 'str' object does not support item assignment
```

Une méthode de chaîne **ne modifie jamais** la chaîne d'origine : elle **renvoie une nouvelle chaîne**.

```python
nom = "fara"
nom.upper()           # renvoie "FARA", mais personne ne la récupère
print(nom)            # fara : inchangé !

nom = nom.upper()     # on réaffecte la variable avec le résultat
print(nom)            # FARA
```

C'est l'erreur la plus fréquente avec les chaînes : appeler une méthode sans récupérer son résultat.

### 3.3 Casse et nettoyage

```python
s = "  Bonjour le Monde  "
s.strip()         # "Bonjour le Monde"       retire les espaces aux deux extrémités
s.lstrip()        # "Bonjour le Monde  "     à gauche seulement
s.rstrip()        # "  Bonjour le Monde"     à droite seulement
s.lower()         # "  bonjour le monde  "
s.upper()         # "  BONJOUR LE MONDE  "
s.title()         # "  Bonjour Le Monde  "
"fara".capitalize()   # "Fara"
"0341234567".strip("0")   # "341234567" : retire les caractères indiqués aux extrémités
```

On peut **enchaîner** les méthodes, puisque chacune renvoie une chaîne :

```python
saisie = "  OUI  "
reponse = saisie.strip().lower()    # "oui"
```

### 3.4 Remplacer

```python
"2026-10-23".replace("-", "/")     # "2026/10/23"
"aaa".replace("a", "b", 2)         # "bba" : au maximum 2 remplacements
"12,5".replace(",", ".")           # "12.5" : utile avant float()
```

### 3.5 Découper et assembler

`split` transforme une chaîne en **liste** :

```python
"le chat dort".split()             # ['le', 'chat', 'dort']    sépare sur les espaces (multiples, tabulations…)
"a,b,,c".split(",")                # ['a', 'b', '', 'c']       séparateur explicite : les vides sont gardés
"Aina;21;Antsirabe".split(";")     # ['Aina', '21', 'Antsirabe']
"2026-10-23".split("-", 1)         # ['2026', '10-23']         au maximum 1 découpage
```

`join` fait l'inverse : il **assemble** une liste de chaînes avec un séparateur.

```python
mots = ["le", "chat", "dort"]
" ".join(mots)                     # "le chat dort"
", ".join(["riz", "lait"])         # "riz, lait"
"-".join("abc")                    # "a-b-c" : une chaîne est une séquence
" ".join([1, 2])                   # TypeError : join n'accepte que des chaînes
```

La syntaxe surprend : c'est le **séparateur** qui appelle `join`. Lis-la comme « séparateur, assemble cette liste ».

Combinés, `split` et `join` permettent de transformer un texte :

```python
phrase = "  trop     d'espaces   ici "
propre = " ".join(phrase.split())   # "trop d'espaces ici"
```

### 3.6 Rechercher

```python
email = "aina.rakoto@exemple.mg"
"@" in email                  # True
email.find("@")               # 11 : index de la première occurrence
email.find("#")               # -1 : absent (pas d'erreur)
email.index("#")              # ValueError : comme find, mais lève une erreur
email.count(".")              # 2
email.startswith("aina")      # True
email.endswith((".mg", ".fr"))  # True : accepte un tuple de suffixes
email.rfind(".")              # 19 : dernière occurrence
```

Exemple : extraire le domaine d'un e-mail.

```python
domaine = email[email.find("@") + 1:]    # "exemple.mg"
# ou
utilisateur, domaine = email.split("@")
```

### 3.7 Tester la nature d'un texte

| Méthode | Vrai si… | `"abc"` | `"123"` | `"a1"` | `""` |
|---|---|---|---|---|---|
| `isalpha()` | uniquement des lettres | True | False | False | False |
| `isdigit()` | uniquement des chiffres | False | True | False | False |
| `isalnum()` | lettres ou chiffres | True | True | True | False |
| `isupper()` / `islower()` | lettres toutes en majuscules / minuscules | False / True | False / False | False / True | False / False |
| `isspace()` | uniquement des blancs | False | False | False | False |

Les lettres accentuées comptent comme des lettres : `"éte".isalpha()` vaut `True`.

### 3.8 Formatage avancé des f-strings

La syntaxe complète est `{valeur:format}`.

```python
prix = 1234567.891
f"{prix:.2f}"          # '1234567.89'      2 décimales
f"{prix:,.2f}"         # '1,234,567.89'    séparateur de milliers
f"{prix:_.0f}"         # '1_234_568'

nom = "Riz"
f"[{nom:<10}]"         # '[Riz       ]'    aligné à gauche sur 10
f"[{nom:>10}]"         # '[       Riz]'    à droite
f"[{nom:^10}]"         # '[   Riz    ]'    centré
f"[{nom:*^10}]"        # '[***Riz****]'    remplissage personnalisé

n = 7
f"{n:03d}"             # '007'             zéros devant
f"{0.256:.1%}"         # '25.6%'           pourcentage

x = 5
f"{x = }"              # 'x = 5'           pratique pour déboguer
```

Pour un séparateur de milliers « à la française » (espace), on peut écrire `f"{prix:,.2f}".replace(",", " ")`.

### 3.9 Chaînes multilignes et caractères spéciaux

```python
menu = """
1. Ajouter
2. Quitter
"""
chemin = "C:\\dossier\\fichier"     # \\ donne un antislash
brut = r"C:\dossier\nouveau"        # r : chaîne brute, \n n'est pas interprété
citation = "Il a dit \"bonjour\""   # \" : guillemet dans la chaîne
```

### 3.10 Parcourir et construire une chaîne

```python
mot = "bonjour"
resultat = ""
for c in mot:
    if c in "aeiou":
        resultat += c.upper()
    else:
        resultat += c
print(resultat)   # bOnjOUr
```

Pour assembler **beaucoup** de morceaux, il est plus efficace de les ajouter à une liste puis d'utiliser `"".join(liste)`.

---

## 4. Exemples commentés

### Exemple A — Normaliser un nom complet

```python
saisie = "   rakoto   ANDRY   jean "
morceaux = saisie.split()                 # ['rakoto', 'ANDRY', 'jean']
nom = morceaux[0].upper()                 # 'RAKOTO'
prenoms = [p.capitalize() for p in morceaux[1:]]   # compréhension (jour 5) : ['Andry', 'Jean']
print(f"{nom} {' '.join(prenoms)}")       # RAKOTO Andry Jean
```

### Exemple B — Analyser une ligne de données

```python
ligne = "P042 ; Cahier 96 pages ; 2500 ; 30"
code, designation, prix, qte = [champ.strip() for champ in ligne.split(";")]
prix = int(prix)
qte = int(qte)
print(f"{code} | {designation:<20} | {prix:>8,} | {qte:>4}")
# P042 | Cahier 96 pages      |    2,500 |   30
```

Découper, nettoyer chaque champ, convertir, puis formater : tu feras exactement cela avec les fichiers CSV en semaine 3.

---

## 5. Erreurs courantes

| Code | Problème | Correction |
|---|---|---|
| `nom.strip()` sans réaffectation | `nom` est inchangé | `nom = nom.strip()` |
| `mot[0] = "X"` | `TypeError` : immuable | `mot = "X" + mot[1:]` |
| `",".join([1, 2, 3])` | `TypeError` | `",".join(str(n) for n in [1, 2, 3])` |
| `liste.join(" ")` | `AttributeError` | `" ".join(liste)` |
| `"a,b".split()` | `['a,b']` | Préciser le séparateur : `split(",")` |
| `if reponse == "oui":` sans normaliser | Échoue avec `"Oui "` | `reponse.strip().lower()` |
| `s.find(x)` utilisé dans un `if` | `if s.find(x):` est faux quand x est à l'index 0 et vrai quand il est absent (-1) | Utiliser `if x in s:` |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-02/jour-03/`

**Exercice 1 — Prédictions (`ex1_predictions.txt`).** Avec `s = "  Python est Génial  "`, prédis : `s.strip().lower()`, `s.split()`, `len(s.strip())`, `s.strip()[::-1]`, `s.count("e")`, `s.find("est")`, `"-".join(s.split())`, `s.strip().startswith("py")`, `s.replace(" ", "")`.

**Exercice 2 — Initiales (`ex2_initiales.py`).** Demande un nom complet et affiche ses initiales en majuscules, séparées par des points. Avec `"jean paul rakoto"`, on obtient `J.P.R.`. Les espaces multiples ne doivent pas poser problème.

**Exercice 3 — Compteur (`ex3_compteur.py`).** Demande une phrase et affiche le nombre de mots, le nombre de caractères sans les espaces, le mot le plus long et le nombre de mots commençant par une majuscule.

## 7. Exercices intermédiaires

**Exercice 4 — Validation d'e-mail simplifiée (`ex4_email.py`).** Un e-mail est considéré valide si :
- il contient exactement un `@` ;
- la partie avant `@` n'est pas vide et ne contient que des lettres, des chiffres, `.`, `_` ou `-` ;
- la partie après `@` contient au moins un `.`, et ne commence ni ne finit par `.` ;
- l'extension (après le dernier `.`) contient entre 2 et 4 lettres.

Affiche **la raison précise** du rejet. Prépare au moins 10 cas de test, valides et invalides.

**Exercice 5 — Chiffre de César (`ex5_cesar.py`).** Chiffre un message en décalant chaque lettre de `k` positions dans l'alphabet (`a` devient `d` avec `k = 3`, et `z` devient `c`). Conserve la casse et laisse les autres caractères intacts. Indices : `ord("a")` donne le code d'un caractère, `chr(97)` fait l'inverse, et `%` permet de « boucler » sur l'alphabet. Vérifie que déchiffrer avec `-k` redonne le message d'origine.

**Exercice 6 — Tableau formaté (`ex6_tableau.py`).** Avec `produits = [("Riz", 2800, 50), ("Huile de palme 1L", 9500, 12), ("Sel", 600, 120)]`, affiche un tableau aligné, avec des bordures et un total. Les prix utilisent un séparateur de milliers « espace ».

```
+-------------------+---------+------+
| Produit           |    Prix |  Qté |
+-------------------+---------+------+
| Riz               |   2 800 |   50 |
...
```

## 8. Défi — Formateur de numéros de téléphone (`defi_telephone.py`)

L'utilisateur saisit des numéros de téléphone malgaches sous diverses formes : `034 12 345 67`, `+261 34 12 345 67`, `0341234567`, `261341234567`, `034-12-345-67`. Ton programme doit :
- extraire uniquement les chiffres ;
- reconnaître le préfixe international (`261`) et le remplacer par `0` ;
- vérifier que le résultat compte 10 chiffres et commence par `03` ;
- afficher le numéro au format standard `034 12 345 67`, ou un message d'erreur ;
- traiter une **liste** de 8 numéros de test, que tu choisis pour couvrir tous les cas.

## 8 bis. Corriger un bug (`bug_s2j3.py`)

Ce programme doit transformer `"bonjour tout le monde"` en `"Bonjour Tout Le Monde"` **sans** utiliser `.title()`. Il contient trois erreurs.

```python
phrase = "bonjour tout le monde"
mots = phrase.split(" ")
for mot in mots:
    mot[0] = mot[0].upper()
resultat = mots.join(" ")
print(resultat)
```

## 9. Critères de réussite

- [ ] Je récupère **toujours** le résultat d'une méthode de chaîne.
- [ ] Je normalise systématiquement les saisies (`strip`, `lower`).
- [ ] J'utilise `split`/`join` plutôt que des boucles manuelles quand c'est possible.
- [ ] Je formate des tableaux alignés avec les f-strings.

## 10. Questions de révision

1. Pourquoi `nom.upper()` seul ne modifie-t-il pas `nom` ?
2. Quelle différence y a-t-il entre `"a  b".split()` et `"a  b".split(" ")` ?
3. Pourquoi `if texte.find("x"):` est-il un piège ?
4. Pourquoi écrit-on `", ".join(liste)` et non `liste.join(", ")` ?

## 11. Bilan et préparation du jour 4

Tes programmes deviennent plus longs, et tu as sûrement recopié plusieurs fois les mêmes lignes (normaliser une saisie, valider un nombre…). Au jour 4, nous verrons les **fonctions** : donner un nom à un bloc de code, lui transmettre des données et récupérer un résultat.
