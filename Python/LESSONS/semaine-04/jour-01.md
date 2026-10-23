# Semaine 4 · Jour 1 : classes et objets

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer ce qu'est la programmation orientée objet (POO) et quel problème elle résout ;
- distinguer **classe** et **objet** (instance) ;
- définir une classe avec `class`, un constructeur `__init__` et des attributs ;
- expliquer le rôle de `self` ;
- écrire des **méthodes** qui lisent et modifient l'état de l'objet ;
- créer plusieurs objets indépendants et les ranger dans des collections.

## 2. Prérequis

- Phase 1 complète : fonctions, dictionnaires, exceptions.

---

## 3. Cours

### 3.1 Le problème

Dans ton gestionnaire de dépenses, une dépense est un dictionnaire, et les fonctions qui la manipulent sont dispersées :

```python
depense = {"montant": 12500, "categorie": "alimentation"}
depense["montnat"] = -3          # faute de frappe : aucune erreur, juste une nouvelle clé
depense["montant"] = -500        # montant négatif : rien ne l'empêche
```

Rien ne relie les **données** (le dictionnaire) aux **règles** (les validateurs). Il suffit d'oublier d'appeler `valider_montant` une fois pour que des données invalides entrent.

La POO regroupe dans une même entité les **données** (attributs) et les **comportements** (méthodes) qui les manipulent. L'objet peut alors **protéger** sa cohérence.

### 3.2 Classe et objet

**Analogie :** une **classe** est un **plan** de maison. Un **objet** est une **maison construite** à partir de ce plan. Avec un seul plan, on construit plusieurs maisons, chacune avec sa propre couleur et ses propres habitants.

- La classe `CompteBancaire` décrit ce qu'est un compte : il a un titulaire et un solde, on peut y déposer et en retirer.
- Les objets `compte_aina` et `compte_rado` sont deux comptes concrets, avec chacun **son** solde.

Tu utilises des objets depuis le début : `"abc"` est un objet de la classe `str`, et `.upper()` est une méthode de cette classe. `[1, 2]` est un objet de la classe `list`.

```python
print(type("abc"))    # <class 'str'>
```

### 3.3 Définir une classe

```python
class CompteBancaire:
    """Un compte bancaire avec un titulaire et un solde."""

    def __init__(self, titulaire, solde_initial=0):
        self.titulaire = titulaire
        self.solde = solde_initial

    def deposer(self, montant):
        self.solde += montant

    def afficher(self):
        print(f"{self.titulaire} : {self.solde} Ar")
```

Ligne par ligne :
- `class CompteBancaire:` : nom en **PascalCase** (majuscule à chaque mot), par convention ;
- `__init__` est le **constructeur** : il est appelé automatiquement à la création d'un objet, et son rôle est d'**initialiser** les attributs ;
- `self` désigne **l'objet en cours**, celui qui est en train d'être créé ou sur lequel on appelle la méthode ;
- `self.titulaire = titulaire` crée un **attribut** sur l'objet. À gauche, l'attribut de l'objet ; à droite, le paramètre reçu ;
- `deposer` et `afficher` sont des **méthodes** : des fonctions définies dans la classe, dont le premier paramètre est toujours `self`.

### 3.4 Créer et utiliser des objets

```python
compte_aina = CompteBancaire("Aina", 50000)    # appelle __init__(compte_aina, "Aina", 50000)
compte_rado = CompteBancaire("Rado")           # solde_initial = 0

compte_aina.deposer(10000)                     # équivaut à CompteBancaire.deposer(compte_aina, 10000)
compte_aina.afficher()                         # Aina : 60000 Ar
compte_rado.afficher()                         # Rado : 0 Ar

print(compte_aina.solde)                       # 60000 : lecture directe d'un attribut
```

**Le mystère de `self` est levé :** quand tu écris `compte_aina.deposer(10000)`, Python appelle `CompteBancaire.deposer(compte_aina, 10000)`. L'objet est passé **automatiquement** comme premier argument. C'est pour cela que la méthode a un paramètre de plus à la définition qu'à l'appel.

Chaque objet a **ses propres** attributs : déposer sur `compte_aina` ne change pas `compte_rado`.

### 3.5 Méthodes qui renvoient et méthodes qui valident

Les règles des semaines précédentes s'appliquent : une méthode de calcul **renvoie** et ne fait pas de `print`. Une méthode qui refuse une opération **lève** une exception.

```python
class CompteBancaire:
    def __init__(self, titulaire, solde_initial=0):
        if solde_initial < 0:
            raise ValueError("Le solde initial ne peut pas être négatif.")
        self.titulaire = titulaire
        self.solde = solde_initial
        self.historique = []                 # chaque compte a SA propre liste

    def deposer(self, montant):
        if montant <= 0:
            raise ValueError("Le dépôt doit être positif.")
        self.solde += montant
        self.historique.append(("dépôt", montant))

    def retirer(self, montant):
        if montant <= 0:
            raise ValueError("Le retrait doit être positif.")
        if montant > self.solde:
            raise ValueError(f"Solde insuffisant ({self.solde}).")
        self.solde -= montant
        self.historique.append(("retrait", montant))

    def peut_retirer(self, montant):
        return 0 < montant <= self.solde

    def resume(self):
        return f"{self.titulaire} : {self.solde:,} Ar ({len(self.historique)} opérations)"
```

Une méthode peut appeler une autre méthode du même objet avec `self.autre_methode(...)`.

### 3.6 Plusieurs objets dans une collection

```python
comptes = [CompteBancaire("Aina", 50000), CompteBancaire("Rado", 2000), CompteBancaire("Fara")]

for c in comptes:
    c.deposer(1000)

plus_riche = max(comptes, key=lambda c: c.solde)
print(plus_riche.titulaire)                   # Aina

par_nom = {c.titulaire: c for c in comptes}   # accès par nom
par_nom["Fara"].retirer(500)
```

### 3.7 Afficher un objet

```python
print(compte_aina)     # <__main__.CompteBancaire object at 0x7f3a...>
```

Par défaut, l'affichage d'un objet n'est pas parlant. Au jour 4, la méthode spéciale `__str__` permettra de choisir ce qu'affiche `print(objet)`.

---

## 4. Exemples commentés

### Exemple A — Un produit en stock

```python
class Produit:
    """Un article du catalogue avec son stock."""

    def __init__(self, code, nom, prix, quantite=0):
        self.code = code
        self.nom = nom
        self.prix = prix
        self.quantite = quantite

    def valeur_stock(self):
        return self.prix * self.quantite

    def est_en_rupture(self):
        return self.quantite == 0

    def entrer(self, nombre):
        """Ajoute des unités au stock."""
        if nombre <= 0:
            raise ValueError("La quantité entrée doit être positive.")
        self.quantite += nombre

    def sortir(self, nombre):
        """Retire des unités. Lève ValueError si le stock est insuffisant."""
        if nombre <= 0:
            raise ValueError("La quantité sortie doit être positive.")
        if nombre > self.quantite:
            raise ValueError(f"Stock insuffisant pour {self.nom} : {self.quantite} disponible(s).")
        self.quantite -= nombre


riz = Produit("P001", "Riz 1 kg", 2800, 50)
riz.sortir(12)
print(riz.quantite, riz.valeur_stock())     # 38 106400

try:
    riz.sortir(100)
except ValueError as e:
    print(e)                                # Stock insuffisant pour Riz 1 kg : 38 disponible(s).
```

Compare avec la semaine 3 : la règle « on ne sort pas plus que le stock » est maintenant **attachée** au produit. Impossible de l'oublier, puisque c'est la seule façon de sortir du stock… sauf si on écrit `riz.quantite = -5` directement. Le jour 2 traitera ce problème.

### Exemple B — Tester une classe

```python
p = Produit("P002", "Sel", 600)
assert p.est_en_rupture()
p.entrer(10)
assert p.quantite == 10 and p.valeur_stock() == 6000
p.sortir(10)
assert p.est_en_rupture()

for invalide in (0, -3):
    try:
        p.entrer(invalide)
        assert False, f"entrer({invalide}) aurait dû échouer"
    except ValueError:
        pass
print("Tests Produit OK")
```

---

## 5. Erreurs courantes

| Code | Erreur | Explication |
|---|---|---|
| `def deposer(montant):` dans la classe | `TypeError: deposer() takes 1 positional argument but 2 were given` | `self` oublié : l'objet est passé en plus |
| `solde += montant` dans une méthode | `UnboundLocalError` ou `NameError` | Il faut écrire `self.solde` |
| `def __init__(self, nom): nom = nom` | L'attribut n'est pas créé | Écrire `self.nom = nom` |
| `def __int__(...)` ou `def _init_(...)` | Le constructeur n'est jamais appelé | Deux tirets bas de chaque côté : `__init__` |
| `compte = CompteBancaire` (sans `()`) | `compte` est la classe, pas un objet | `CompteBancaire("Aina")` |
| `CompteBancaire.deposer(100)` | `TypeError` | Appeler la méthode sur un **objet** |
| `historique=[]` comme paramètre par défaut de `__init__` | Liste partagée entre objets (semaine 2, jour 5) | `historique=None`, puis `self.historique = []` |
| `print` dans une méthode de calcul | Non réutilisable | `return` |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-04/jour-01/`

**Exercice 1 — Rectangle (`ex1_rectangle.py`).** Classe `Rectangle(largeur, hauteur)` avec les méthodes `aire()`, `perimetre()`, `est_carre()` et `redimensionner(facteur)`. Lève une `ValueError` si une dimension n'est pas strictement positive. Tests :

```python
r = Rectangle(3, 4)
assert r.aire() == 12 and r.perimetre() == 14 and not r.est_carre()
r.redimensionner(2)
assert (r.largeur, r.hauteur) == (6, 8)
```

**Exercice 2 — Trace de `self` (`ex2_self.txt`).** Prédis l'affichage et explique, pour chaque appel, ce que vaut `self` :

```python
class Compteur:
    def __init__(self, depart=0):
        self.valeur = depart
    def incrementer(self, pas=1):
        self.valeur += pas
        return self.valeur

a = Compteur()
b = Compteur(10)
a.incrementer()
b.incrementer(5)
c = a
c.incrementer()
print(a.valeur, b.valeur, c.valeur, a is c)
```

**Exercice 3 — Étudiant (`ex3_etudiant.py`).** Classe `Etudiant(nom)` avec une liste de notes, et les méthodes `ajouter_note(note)` (valide la note entre 0 et 20), `moyenne()` (`None` si aucune note) et `mention()`. Réutilise la logique de ta semaine 2.

## 7. Exercices intermédiaires

**Exercice 4 — Compte bancaire complet (`ex4_compte.py`).** À partir de la classe du cours, sans la copier mais en la réécrivant :
- ajoute `virer(montant, compte_destination)`, qui doit être atomique : si le retrait échoue, rien ne change ;
- ajoute un **plafond** de retrait journalier, avec une valeur par défaut de 200 000 ;
- `releve()` renvoie la liste des opérations, mise en forme avec le solde après chaque opération ;
- écris des tests pour chaque règle, en particulier le virement refusé.

**Exercice 5 — Minuteur (`ex5_minuteur.py`).** Classe `Duree(heures=0, minutes=0, secondes=0)` qui stocke **uniquement** un nombre total de secondes (un seul attribut). Méthodes : `heures()`, `minutes()` et `secondes()` (décomposition), `ajouter(autre_duree)` (renvoie une **nouvelle** `Duree`), et `formater()` (`"01:02:05"`). Normalise les entrées : `Duree(minutes=90)` donne `01:30:00`.

**Exercice 6 — Conversion depuis et vers un dictionnaire (`ex6_dict.py`).** Ajoute à `Produit` une méthode `vers_dict()`, qui renvoie un dictionnaire sérialisable en JSON. Écris aussi une **fonction** `produit_depuis_dict(d)` qui reconstruit un objet. Sauvegarde une liste de produits en JSON, recharge-la, et vérifie que les objets ont les mêmes attributs. Au jour 5, nous transformerons cette fonction en méthode de classe.

## 8. Défi — Distributeur de boissons (`defi_distributeur.py`)

Modélise un distributeur avec une classe `Distributeur` :
- un stock de boissons : `{code: [nom, prix, quantite]}` ;
- `inserer(piece)` : seules les pièces de 50, 100, 200 et 500 sont acceptées ;
- `choisir(code)` : vérifie le stock et le crédit, délivre la boisson et renvoie la monnaie sous forme de **liste de pièces** (rendu glouton avec les pièces disponibles dans la caisse) ;
- `annuler()` : rend le crédit inséré ;
- la caisse a un nombre limité de pièces : si la monnaie ne peut pas être rendue, la vente est **refusée** et rien ne change.

Écris un menu en terminal **séparé** de la classe (la classe ne fait ni `input` ni `print`), ainsi que des tests pour chaque règle.

## 8 bis. Corriger un bug (`bug_s4j1.py`)

```python
class Panier:
    def __init__(self, client, articles=[]):
        client = client
        self.articles = articles

    def ajouter(article, prix):
        self.articles.append((article, prix))

    def total(self):
        for _, prix in self.articles:
            total += prix
        return total

p1 = Panier("Aina")
p1.ajouter("Riz", 2800)
p2 = Panier("Rado")
print(p2.articles, p1.client, p1.total())
```

Attendu : `[] Aina 2800`. Trouve les **quatre** bugs. Pour celui de la liste par défaut, explique pourquoi `p2` verrait les articles de `p1`.

## 9. Critères de réussite

- [ ] Je sais expliquer la différence entre classe et objet avec une analogie.
- [ ] Je sais expliquer ce que vaut `self` à chaque appel.
- [ ] Toutes les données d'un objet sont initialisées dans `__init__`.
- [ ] Mes méthodes valident leurs entrées et lèvent des exceptions.
- [ ] Mes classes ne font ni `input` ni `print` (sauf si c'est leur rôle explicite).
- [ ] Mes classes ont des tests.

## 10. Questions de révision

1. Que fait Python, étape par étape, quand on écrit `c = CompteBancaire("Aina", 100)` ?
2. Pourquoi une méthode a-t-elle un paramètre de plus à la définition qu'à l'appel ?
3. Quel avantage y a-t-il à mettre la règle « stock suffisant » dans une méthode de `Produit`, plutôt que dans une fonction séparée ?
4. Pourquoi `self.historique = []` doit-il être écrit dans `__init__` et non comme paramètre par défaut ?

## 11. Bilan et préparation du jour 2

Ta classe `Produit` valide les sorties de stock… mais rien n'empêche d'écrire `riz.quantite = -5` ou `riz.prix = "gratuit"`. Au jour 2, nous verrons l'**encapsulation** : comment un objet protège ses attributs grâce aux conventions de nommage et aux **propriétés** (`@property`). Nous verrons aussi les attributs de classe.
