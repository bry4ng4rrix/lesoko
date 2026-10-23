# Semaine 3 · Jour 5 : validation des données et débogage méthodique

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- distinguer validation **syntaxique** (le format) et validation **métier** (le sens) ;
- centraliser la validation dans des fonctions qui lèvent des exceptions claires ;
- appliquer une **méthode** de débogage, plutôt que modifier le code au hasard ;
- utiliser `print` de débogage efficacement, notamment avec `f"{x = }"` ;
- utiliser `breakpoint()` et les commandes de base de `pdb` ;
- utiliser le débogueur de VS Code : points d'arrêt, pas à pas, inspection des variables ;
- produire un exemple minimal reproductible.

## 2. Prérequis

- Jours 1 à 4 : fichiers, exceptions, JSON, CSV.

---

## 3. Cours — Partie A : valider les données

### 3.1 Pourquoi valider ?

Règle d'or : **toute donnée qui vient de l'extérieur est suspecte**, qu'il s'agisse d'une saisie utilisateur, d'un fichier, d'une API ou d'un formulaire web. Des données invalides qui pénètrent dans ton programme provoquent des plantages **loin** de leur source, ou pire, des résultats faux et silencieux (une dépense négative qui augmente ton solde).

On valide donc **à la frontière**, dès l'entrée, puis le reste du programme peut faire confiance aux données.

### 3.2 Deux niveaux de validation

| Niveau | Question | Exemple |
|---|---|---|
| **Syntaxique** (format, type) | Est-ce convertible ? | `"12,5"` est-il un nombre ? `"2026-13-45"` est-il une date ? |
| **Métier** (règles) | Est-ce acceptable ? | Une dépense est-elle positive ? La date est-elle dans le futur ? La catégorie existe-t-elle ? |

### 3.3 Un validateur par champ

```python
from datetime import date

CATEGORIES = {"alimentation", "transport", "logement", "loisirs", "santé", "autre"}


def valider_montant(texte):
    """Convertit un montant saisi ('1 250,50') en float strictement positif."""
    nettoye = texte.strip().replace(" ", "").replace(",", ".")
    try:
        montant = float(nettoye)
    except ValueError:
        raise ValueError(f"Montant illisible : {texte!r}") from None
    if montant <= 0:
        raise ValueError("Le montant doit être strictement positif.")
    if montant > 100_000_000:
        raise ValueError("Montant anormalement élevé.")
    return round(montant, 2)


def valider_date(texte):
    """Convertit 'AAAA-MM-JJ' en date, refuse les dates futures."""
    try:
        d = date.fromisoformat(texte.strip())
    except ValueError:
        raise ValueError(f"Date invalide (format AAAA-MM-JJ attendu) : {texte!r}") from None
    if d > date.today():
        raise ValueError("La date ne peut pas être dans le futur.")
    return d


def valider_categorie(texte):
    cat = texte.strip().lower()
    if cat not in CATEGORIES:
        raise ValueError(f"Catégorie inconnue. Choix : {', '.join(sorted(CATEGORIES))}")
    return cat
```

Points clés :
- chaque validateur **nettoie**, **convertit** et **vérifie**, puis renvoie une valeur propre et typée ;
- en cas de problème, il **lève** une `ValueError` avec un message **destiné à l'utilisateur** ;
- `from None` masque l'exception technique d'origine, qui n'apporte rien ici ;
- `100_000_000` : les `_` rendent les grands nombres lisibles, et Python les ignore ;
- `date.fromisoformat` vérifie aussi la cohérence : le 30 février est refusé.

### 3.4 Réutiliser les validateurs dans l'interface

```python
def demander(message, validateur):
    """Redemande tant que le validateur lève ValueError."""
    while True:
        try:
            return validateur(input(message))
        except ValueError as e:
            print(f"  ✗ {e}")


montant = demander("Montant : ", valider_montant)
jour = demander("Date (AAAA-MM-JJ) : ", valider_date)
```

Une fonction peut être **passée en argument** à une autre fonction : `valider_montant` sans parenthèses désigne la fonction elle-même, et `demander` l'appelle. Les mêmes validateurs serviront pour l'import CSV, le chargement JSON et, en semaine 10, l'API.

### 3.5 Valider un enregistrement complet

```python
def valider_depense(donnees):
    """Valide un dict brut et renvoie un dict propre. Lève ValueError avec TOUTES les erreurs."""
    erreurs = []
    propre = {}
    for champ, validateur in [("montant", valider_montant), ("date", valider_date),
                              ("categorie", valider_categorie)]:
        try:
            propre[champ] = validateur(str(donnees.get(champ, "")))
        except ValueError as e:
            erreurs.append(f"{champ} : {e}")
    if erreurs:
        raise ValueError(" ; ".join(erreurs))
    propre["description"] = str(donnees.get("description", "")).strip()[:100]
    return propre
```

Signaler **toutes** les erreurs d'un coup est plus agréable pour l'utilisateur que de les découvrir une par une.

---

## 3. Cours — Partie B : déboguer

### 3.6 Un bug est une hypothèse fausse

Un bug signifie qu'une de tes **hypothèses** sur le programme est fausse : « cette variable contient un int », « cette boucle tourne 5 fois », « cette fonction renvoie une liste ». Déboguer, c'est **trouver quelle hypothèse est fausse**. Modifier le code au hasard jusqu'à ce que ça marche ne t'apprend rien, et produit souvent un deuxième bug.

### 3.7 La méthode

1. **Reproduire** : trouve les entrées exactes qui provoquent le bug, et assure-toi de pouvoir le déclencher à volonté.
2. **Lire** le message d'erreur en entier, de bas en haut (jour 2).
3. **Formuler une hypothèse** précise : « je pense que `total` vaut `None` à la ligne 12 ».
4. **Vérifier** l'hypothèse en observant (avec `print` ou le débogueur), **sans corriger** encore.
5. **Réduire** : supprime tout ce qui n'est pas nécessaire pour reproduire le bug. Le plus petit code qui le reproduit est un **exemple minimal reproductible**.
6. **Corriger** la cause, pas le symptôme.
7. **Ajouter un test** (`assert`) qui aurait détecté le bug, pour qu'il ne revienne jamais.

Astuce de la méthode du canard en plastique : explique ton code ligne par ligne, à voix haute, à un objet. Très souvent, tu trouves le bug en formulant l'explication.

### 3.8 Le `print` de débogage

```python
def moyenne_ponderee(notes, coefs):
    total = 0
    for n, c in zip(notes, coefs):
        total += n * c
        print(f"DEBUG {n = } {c = } {total = }")
    return total / sum(coefs)
```

- `f"{n = }"` affiche `n = 12` : le nom **et** la valeur.
- `print(f"{type(x) = }")` permet de vérifier un type.
- Préfixe tes messages par `DEBUG` pour les retrouver et **les supprimer** ensuite.
- `zip(a, b)` parcourt deux listes en parallèle. S'il te surprend, c'est l'occasion de lire sa documentation : `help(zip)`.

Le `print` est simple et efficace, mais il faut modifier le code et relancer à chaque fois. Le débogueur évite cela.

### 3.9 `breakpoint()` et `pdb`

Ajoute `breakpoint()` à l'endroit où tu veux t'arrêter :

```python
def calculer(prix, quantites):
    total = 0
    for q in quantites:
        breakpoint()          # le programme s'arrête ici
        total += prix * q
    return total
```

Le terminal affiche une invite `(Pdb)`. Commandes essentielles :

| Commande | Action |
|---|---|
| `p total` | affiche la valeur d'une expression |
| `pp donnees` | affichage lisible d'une structure |
| `n` (*next*) | exécute la ligne courante, sans entrer dans les fonctions |
| `s` (*step*) | entre dans la fonction appelée |
| `c` (*continue*) | reprend jusqu'au prochain point d'arrêt |
| `l` (*list*) | affiche le code autour de la position courante |
| `w` (*where*) | affiche la pile d'appels |
| `q` (*quit*) | arrête le programme |

Pense à retirer les `breakpoint()` une fois le bug trouvé.

### 3.10 Le débogueur de VS Code

C'est l'outil le plus confortable, à pratiquer **aujourd'hui** :
1. Ouvre ton fichier `.py` dans VS Code (avec l'extension Python installée).
2. Clique dans la marge à gauche d'un numéro de ligne : un **point rouge** apparaît (point d'arrêt).
3. Appuie sur **F5** et choisis « Python Debugger : fichier courant ».
4. L'exécution s'arrête sur le point rouge. À gauche, le panneau **Variables** affiche toutes les variables locales et globales, avec leur valeur.
5. Barre d'outils :
   - **F10** (*Step Over*) : ligne suivante ;
   - **F11** (*Step Into*) : entre dans la fonction ;
   - **Maj+F11** (*Step Out*) : termine la fonction courante ;
   - **F5** : continue jusqu'au point d'arrêt suivant.
6. **Espion** (*Watch*) : ajoute une expression (`total / len(notes)`) dont la valeur est réévaluée à chaque pas.
7. **Point d'arrêt conditionnel** : clic droit sur le point rouge, puis « Modifier le point d'arrêt », avec par exemple `q < 0`. L'arrêt n'a lieu que si la condition est vraie, ce qui est très utile dans une boucle de 1000 tours.
8. **Console de débogage** : tape une expression Python, évaluée dans le contexte courant.

Pour les programmes qui utilisent `input()`, VS Code les exécute dans le terminal intégré : tu peux y taper tes réponses.

---

## 4. Exemples commentés

### Exemple — Débogage complet d'un vrai bug

```python
def appliquer_remises(paniers, taux):
    """Renvoie le total remisé de chaque panier."""
    resultats = []
    for panier in paniers:
        total = sum(panier)
        if total > 50000:
            total = total * (1 - taux)
        resultats.append(total)
    return resultats

paniers = [[20000, 40000], [10000], [30000, 25000]]
print(appliquer_remises(paniers, 10))
# [-540000, 10000, -495000]  ← des totaux négatifs !
```

1. **Reproduire** : c'est systématique avec ces données.
2. **Lire** : pas d'erreur, mais un résultat faux, ce qui est plus difficile.
3. **Hypothèse** : « la remise est mal calculée ». On observe : point d'arrêt sur `total = total * (1 - taux)`, puis on inspecte `taux`, qui vaut `10`. `1 - 10` donne `-9`.
4. **Cause** : la fonction attend un taux entre 0 et 1, mais l'appelant passe un pourcentage. C'est une hypothèse **implicite**, jamais écrite.
5. **Correction de la cause** : documenter et valider le paramètre.

```python
    if not 0 <= taux < 1:
        raise ValueError(f"taux doit être entre 0 et 1 (reçu : {taux}). Pour 10 %, passer 0.10.")
```

6. **Test** :

```python
assert appliquer_remises([[60000]], 0.10) == [54000]
try:
    appliquer_remises([[1]], 10)
    assert False
except ValueError:
    pass
```

---

## 5. Erreurs courantes

| Mauvaise pratique | Pourquoi | Mieux |
|---|---|---|
| Valider seulement dans l'interface | L'import CSV ou l'API contournent la validation | Validateurs partagés, appelés partout |
| Modifier le code au hasard | Introduit d'autres bugs, rien n'est appris | Hypothèse, puis observation, puis correction |
| Corriger le symptôme (`abs(total)`) | La cause reste | Remonter à l'origine |
| Laisser des `print("DEBUG")` | Pollution de la sortie | Les supprimer, ou utiliser le débogueur |
| Oublier un `breakpoint()` | Le programme se fige en production | Relire avant de valider |
| Ne pas écrire de test après correction | Le bug revient | Toujours un `assert` |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-03/jour-05/`

**Exercice 1 — Validateurs (`ex1_validateurs.py`).** Écris et teste : `valider_age(texte)` (un entier de 0 à 130), `valider_email(texte)` (réutilise ton travail de la semaine 2), et `valider_telephone(texte)` (le défi de la semaine 2). Chacun renvoie la valeur propre ou lève une `ValueError` avec un message clair. Au moins 4 tests par fonction, dont des tests d'exception.

**Exercice 2 — Prise en main de pdb (`ex2_pdb.txt`).** Place un `breakpoint()` dans la boucle de l'exemple B du jour 1 (statistiques de fichier). Avec `n`, `p` et `c`, note l'évolution de `nb_mots` sur les 3 premières lignes. Recopie la session dans le fichier.

**Exercice 3 — Prise en main de VS Code (`ex3_vscode.txt`).** Avec le débogueur VS Code, sur ton projet de calculatrice : place un point d'arrêt dans `calculer`, entre dans la fonction avec F11, ajoute un espion sur l'expression `a / b if b else None`, et pose un point d'arrêt conditionnel qui ne s'arrête que si `operateur == "/"`. Décris ce que tu as observé.

## 7. Exercices intermédiaires

**Exercice 4 — Chasse aux bugs (`ex4_chasse.py`).** Ce programme contient **quatre** bugs. Pour chacun, applique la méthode complète (reproduction, hypothèse, observation, correction, test) et documente-la en commentaire.

```python
def lire_stock(lignes):
    stock = {}
    for ligne in lignes[1:]:
        produit, qte = ligne.split(";")
        stock[produit] = stock.get(produit, 0) + int(qte)
    return stock

def produits_en_alerte(stock, seuil=5):
    alertes = []
    for produit, qte in stock.items():
        if qte < seuil:
            alertes.append(produit)
            return alertes
    return alertes

def valeur_stock(stock, prix):
    total = 0
    for produit in stock:
        total = stock[produit] * prix[produit]
    return total

lignes = ["produit;qte", "riz;10", "sel;2", "Riz;5", "huile ;0", "sucre; 3"]
prix = {"riz": 2800, "sel": 600, "huile": 9500, "sucre": 3000}
stock = lire_stock(lignes)
print(stock)
print(produits_en_alerte(stock))
print(valeur_stock(stock, prix))
```

Attendu : `{'riz': 15, 'sel': 2, 'huile': 0, 'sucre': 3}`, puis `['sel', 'huile', 'sucre']`, puis `52200`.

**Exercice 5 — Exemple minimal (`ex5_minimal.py`).** Reprends un bug que tu as réellement rencontré cette semaine (ou l'un des bugs de l'exercice 4). Réduis-le à moins de 8 lignes qui le reproduisent encore. Rédige-le comme une question que tu pourrais poster sur un forum : contexte, code, résultat attendu, résultat obtenu, ce que tu as déjà essayé.

**Exercice 6 — Validation d'un enregistrement (`ex6_enregistrement.py`).** Écris `valider_produit(donnees)` pour un produit `{"code", "nom", "prix", "quantite", "categorie"}` : code `P` suivi de 3 chiffres, nom de 2 à 50 caractères, prix positif, quantité entière positive ou nulle, catégorie parmi une liste. La fonction renvoie le dictionnaire propre ou lève une `ValueError` qui liste **toutes** les erreurs. Applique-la ensuite à un CSV de 10 produits, dont 4 invalides.

## 8. Défi — Le débogueur détective (`defi_detective.py`)

Écris un programme volontairement buggé de 40 à 60 lignes (par exemple un mini système de réservation), avec **trois bugs subtils** de nature différente : un bug de logique de boucle, un bug de mutabilité (liste partagée) et un bug de type silencieux. Envoie-le moi **sans dire où sont les bugs**. De mon côté, je t'en envoie un autre. Chacun débogue celui de l'autre avec la méthode complète.

Concevoir un bug réaliste oblige à comprendre précisément **pourquoi** il se produit.

## 8 bis. Corriger un bug (`bug_s3j5.py`)

```python
from datetime import date

def valider_date(texte):
    try:
        return date.fromisoformat(texte)
    except ValueError:
        print("Date invalide")

def jours_restants(echeance_texte):
    echeance = valider_date(echeance_texte)
    return (echeance - date.today()).days

print(jours_restants("2026-12-25"))
print(jours_restants("25/12/2026"))
```

Le second appel provoque une erreur **loin** de sa cause. Lis la traceback, puis explique pourquoi l'erreur n'apparaît pas dans `valider_date`. Corrige la **conception**, pas seulement le symptôme.

## 9. Critères de réussite

- [ ] Mes validateurs sont des fonctions séparées, réutilisables et testées.
- [ ] Je valide à la frontière, dès l'entrée des données.
- [ ] Face à un bug, je formule une hypothèse **avant** de modifier le code.
- [ ] Je sais utiliser `breakpoint()` et le débogueur de VS Code.
- [ ] Chaque bug corrigé est accompagné d'un test.

## 10. Questions de révision

1. Quelle différence y a-t-il entre validation syntaxique et validation métier ? Donne un exemple de chaque.
2. Pourquoi valider « à la frontière » ?
3. Décris les 7 étapes de la méthode de débogage.
4. Quelle différence y a-t-il entre *Step Over* et *Step Into* ?

## 11. Bilan et préparation du jour 6

Fichiers, JSON, CSV, exceptions, validation et débogage : tu disposes de tout ce qu'il faut pour écrire un **outil réellement utilisable**. Le jour 6 est consacré au projet **gestionnaire de dépenses** et à l'évaluation de la semaine 3.
