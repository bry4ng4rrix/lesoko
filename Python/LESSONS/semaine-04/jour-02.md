# Semaine 4 · Jour 2 : encapsulation, propriétés et attributs de classe

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer ce qu'est l'**encapsulation** et pourquoi elle protège la cohérence d'un objet ;
- utiliser la convention `_attribut` (usage interne) ;
- créer une **propriété** en lecture seule avec `@property` ;
- créer une propriété avec validation, grâce au **setter** ;
- créer des propriétés **calculées** ;
- distinguer attribut d'**instance** et attribut de **classe** ;
- définir une **invariante** de classe et la garantir.

## 2. Prérequis

- Jour 1 : classes, `__init__`, `self`, méthodes.

---

## 3. Cours

### 3.1 Le problème

```python
riz = Produit("P001", "Riz", 2800, 50)
riz.quantite = -5        # aucune erreur !
riz.prix = "gratuit"     # aucune erreur… jusqu'au calcul de valeur_stock()
```

Les méthodes `entrer` et `sortir` vérifient les règles, mais on peut les **contourner** en modifiant l'attribut directement. L'objet peut alors se retrouver dans un **état incohérent**.

Une **invariante** est une règle qui doit être vraie **à tout moment** pour un objet. Pour `Produit` : « `quantite` est un entier positif ou nul, et `prix` est un nombre positif ». L'**encapsulation** consiste à cacher l'état interne et à n'autoriser que les modifications qui respectent les invariantes.

**Analogie :** le compteur d'électricité est sous scellé. Tu peux **lire** ta consommation, mais seule une procédure officielle peut le modifier.

### 3.2 La convention du tiret bas

Python n'a pas de vrai « privé » comme Java. Il repose sur une **convention** :

```python
class Produit:
    def __init__(self, nom, quantite):
        self.nom = nom              # public : on peut lire et modifier
        self._quantite = quantite   # « interne » : ne touche pas depuis l'extérieur
```

Le `_` signale aux autres développeurs (et à ton futur toi) : « détail d'implémentation, ne pas utiliser directement ». Python ne bloque rien, mais les éditeurs et les outils de vérification le signalent. Respecter cette convention fait partie du professionnalisme.

Le double tiret bas (`self.__quantite`) déclenche un renommage interne (*name mangling*). Il sert à éviter des collisions de noms dans l'héritage, pas à la sécurité. **Utilise un seul `_`.**

### 3.3 `@property` : lecture contrôlée

On veut qu'on puisse **lire** `produit.quantite`, mais pas l'**écrire** directement :

```python
class Produit:
    def __init__(self, nom, quantite=0):
        self.nom = nom
        self._quantite = quantite

    @property
    def quantite(self):
        """Quantité en stock (lecture seule : utiliser entrer/sortir)."""
        return self._quantite

    def entrer(self, n):
        if n <= 0:
            raise ValueError("Quantité positive attendue.")
        self._quantite += n


riz = Produit("Riz", 10)
print(riz.quantite)        # 10 : on l'utilise comme un attribut, SANS parenthèses
riz.quantite = 99          # AttributeError: property 'quantite' of 'Produit' object has no setter
riz.entrer(5)
print(riz.quantite)        # 15
```

- `@property` est un **décorateur** : il transforme la méthode `quantite` en attribut calculé. Quand on écrit `riz.quantite`, Python appelle la méthode.
- Sans setter, la propriété est en **lecture seule**.
- Pour l'utilisateur de la classe, la syntaxe reste celle d'un attribut. On peut donc commencer avec un attribut public, puis le transformer en propriété **plus tard**, sans casser le code qui l'utilise.

### 3.4 Le setter : écriture validée

```python
class Produit:
    def __init__(self, nom, prix):
        self.nom = nom
        self.prix = prix            # passe PAR le setter : validé dès la création !

    @property
    def prix(self):
        return self._prix

    @prix.setter
    def prix(self, valeur):
        if not isinstance(valeur, (int, float)) or isinstance(valeur, bool):
            raise TypeError(f"Le prix doit être un nombre, pas {type(valeur).__name__}.")
        if valeur < 0:
            raise ValueError("Le prix ne peut pas être négatif.")
        self._prix = valeur


p = Produit("Sel", 600)
p.prix = 650          # OK : le setter valide puis stocke
p.prix = -1           # ValueError
p.prix = "gratuit"    # TypeError
Produit("Huile", -5)  # ValueError : la validation s'applique aussi à la création
```

Points clés :
- le setter porte le **même nom** que la propriété, avec le décorateur `@prix.setter` ;
- dans `__init__`, on écrit `self.prix = prix` (sans `_`) **exprès** : on passe par le setter, et la validation est écrite **une seule fois** ;
- la valeur réelle est stockée dans `self._prix`. Si le setter écrivait `self.prix = valeur`, il s'appellerait lui-même à l'infini (`RecursionError`) ;
- `isinstance(True, int)` vaut `True` en Python (un booléen est un entier), d'où l'exclusion explicite de `bool`.

### 3.5 Propriétés calculées

Une propriété n'est pas forcément liée à un attribut stocké. Elle peut être **calculée** à chaque lecture :

```python
class Produit:
    TAUX_TVA = 0.20

    def __init__(self, nom, prix_ht, quantite=0):
        self.nom = nom
        self.prix_ht = prix_ht
        self._quantite = quantite

    @property
    def prix_ttc(self):
        return round(self.prix_ht * (1 + self.TAUX_TVA), 2)

    @property
    def valeur_stock(self):
        return self.prix_ht * self._quantite

    @property
    def en_rupture(self):
        return self._quantite == 0
```

Pourquoi ne pas stocker `prix_ttc` dans un attribut ? Parce qu'il faudrait le **mettre à jour** à chaque changement de `prix_ht`, avec un risque d'oubli et donc d'incohérence. Une valeur dérivée se **calcule**, elle ne se stocke pas.

Utilise une propriété plutôt qu'une méthode quand l'accès ressemble à la lecture d'une caractéristique (`p.en_rupture`), est rapide et n'a pas d'effet de bord.

### 3.6 Attributs de classe et attributs d'instance

```python
class Produit:
    TAUX_TVA = 0.20        # attribut de CLASSE : partagé par tous les objets
    nb_crees = 0

    def __init__(self, nom):
        self.nom = nom     # attribut d'INSTANCE : propre à chaque objet
        Produit.nb_crees += 1


a = Produit("Riz")
b = Produit("Sel")
print(Produit.nb_crees)     # 2
print(a.TAUX_TVA)           # 0.2 : lu via l'objet, trouvé dans la classe
```

Quand on lit `a.TAUX_TVA`, Python cherche d'abord dans l'**objet**, puis dans la **classe**.

**Piège :**

```python
a.TAUX_TVA = 0.05      # crée un attribut d'INSTANCE sur a : la classe est inchangée
print(b.TAUX_TVA)      # 0.2
Produit.TAUX_TVA = 0.1 # modifie la valeur pour tous les objets qui n'ont pas leur propre attribut
```

Pour modifier un compteur de classe, écris `Produit.nb_crees += 1`, et non `self.nb_crees += 1` (qui créerait un attribut d'instance).

Usages typiques : constantes liées à la classe, compteurs, valeurs par défaut immuables. **Jamais** de liste ou de dictionnaire mutable partagé par accident :

```python
class Panier:
    articles = []          # BUG : tous les paniers partagent la même liste !
```

### 3.7 Identifiant automatique

```python
class Commande:
    _prochain_id = 1

    def __init__(self, client):
        self._id = Commande._prochain_id
        Commande._prochain_id += 1
        self.client = client

    @property
    def id(self):
        return self._id          # lecture seule : un identifiant ne change jamais
```

---

## 4. Exemples commentés

### Exemple — Produit encapsulé complet

```python
class Produit:
    """Article du catalogue. Invariantes : prix >= 0, quantité entière >= 0."""

    TAUX_TVA = 0.20

    def __init__(self, code, nom, prix_ht, quantite=0):
        self._code = code
        self.nom = nom
        self.prix_ht = prix_ht                 # validé par le setter
        if not isinstance(quantite, int) or quantite < 0:
            raise ValueError("Quantité initiale invalide.")
        self._quantite = quantite

    # --- Lecture seule ---
    @property
    def code(self):
        return self._code

    @property
    def quantite(self):
        return self._quantite

    # --- Lecture et écriture validée ---
    @property
    def nom(self):
        return self._nom

    @nom.setter
    def nom(self, valeur):
        valeur = str(valeur).strip()
        if not 2 <= len(valeur) <= 50:
            raise ValueError("Le nom doit faire entre 2 et 50 caractères.")
        self._nom = valeur

    @property
    def prix_ht(self):
        return self._prix_ht

    @prix_ht.setter
    def prix_ht(self, valeur):
        if not isinstance(valeur, (int, float)) or isinstance(valeur, bool) or valeur < 0:
            raise ValueError("Prix invalide.")
        self._prix_ht = valeur

    # --- Calculées ---
    @property
    def prix_ttc(self):
        return round(self._prix_ht * (1 + self.TAUX_TVA), 2)

    # --- Seules façons de modifier le stock ---
    def entrer(self, n):
        if not isinstance(n, int) or n <= 0:
            raise ValueError("Entrée : entier positif attendu.")
        self._quantite += n

    def sortir(self, n):
        if not isinstance(n, int) or n <= 0:
            raise ValueError("Sortie : entier positif attendu.")
        if n > self._quantite:
            raise ValueError(f"Stock insuffisant ({self._quantite}).")
        self._quantite -= n
```

Toutes les modifications passent par un point de contrôle. **Il est impossible** de créer ou d'obtenir un `Produit` incohérent sans contourner volontairement la convention `_`.

---

## 5. Erreurs courantes

| Code | Problème |
|---|---|
| `self.prix = valeur` **dans** le setter de `prix` | `RecursionError` : le setter s'appelle lui-même. Stocker dans `self._prix` |
| `@prix.setter` sans `@property` avant | `NameError: name 'prix' is not defined` |
| `p.quantite()` | `TypeError: 'int' object is not callable` : une propriété s'utilise sans parenthèses |
| `self._prix = prix` dans `__init__` | Contourne la validation à la création |
| `self.compteur += 1` pour un compteur de classe | Crée un attribut d'instance |
| Liste comme attribut de classe | Partagée entre tous les objets |
| Stocker une valeur dérivée (`self.prix_ttc = ...`) | Incohérence quand `prix_ht` change |
| Lire `objet._attribut` depuis l'extérieur | Viole l'encapsulation : utiliser la propriété |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-04/jour-02/`

**Exercice 1 — Température (`ex1_temperature.py`).** Classe `Temperature(celsius)` avec la propriété `celsius` (setter : refuse les valeurs inférieures à −273.15) et les propriétés `fahrenheit` et `kelvin`, **avec leurs setters** (qui convertissent puis stockent en Celsius). Un seul attribut stocké.

```python
t = Temperature(25)
assert t.fahrenheit == 77
t.fahrenheit = 212
assert t.celsius == 100
```

**Exercice 2 — Instance ou classe (`ex2_classe_instance.txt`).** Prédis l'affichage :

```python
class A:
    x = 1
    liste = []
    def __init__(self):
        self.y = 2

a1, a2 = A(), A()
a1.x = 10
a1.liste.append("!")
A.x = 5
print(a1.x, a2.x, A.x, a2.liste, a1.y)
```

**Exercice 3 — Lecture seule (`ex3_lecture_seule.py`).** Reprends `CompteBancaire` (jour 1) : `solde` devient une propriété en lecture seule, et `titulaire` une propriété validée (non vide, normalisée avec `.title()`). Vérifie par un test que `compte.solde = 1_000_000` lève une `AttributeError`.

## 7. Exercices intermédiaires

**Exercice 4 — Utilisateur (`ex4_utilisateur.py`).** Classe `Utilisateur(identifiant, email, mot_de_passe)` :
- `identifiant` : lecture seule après la création, 3 à 20 caractères alphanumériques ou `_` ;
- `email` : propriété validée, stockée en minuscules ;
- le mot de passe n'est **jamais** stocké en clair. Stocke son empreinte avec `hashlib.sha256(mdp.encode()).hexdigest()` et fournis une méthode `verifier_mot_de_passe(mdp)` ;
- un compteur de classe des utilisateurs créés, et un identifiant numérique automatique.

En commentaire : pourquoi SHA-256 seul n'est pas suffisant pour de vrais mots de passe ? Recherche « salage » (*salt*) dans la documentation de `hashlib` ; nous approfondirons en semaine 11.

**Exercice 5 — Date simple (`ex5_date.py`).** Classe `DateSimple(jour, mois, annee)` avec des attributs en lecture seule, une validation complète à la création (années bissextiles comprises, en réutilisant ta logique de la semaine 1), les propriétés `est_bissextile` et `jour_de_l_annee`, et une méthode `lendemain()` qui renvoie une **nouvelle** date. Compare tes résultats avec ceux du module `datetime` sur 20 dates.

**Exercice 6 — Refactorisation (`ex6_refacto.py`).** Prends le `Produit` du jour 1 et transforme-le en version encapsulée **sans changer le code qui l'utilise** (tes tests du jour 1 doivent continuer à passer). Ajoute les tests qui prouvent qu'on ne peut plus le rendre incohérent.

## 8. Défi — Réservoir (`defi_reservoir.py`)

Classe `Reservoir(capacite)` :
- `niveau` en lecture seule ;
- `remplir(litres)` renvoie le volume **réellement** ajouté (on ne dépasse pas la capacité) ;
- `vider(litres)` renvoie le volume réellement retiré ;
- `transferer(litres, autre_reservoir)` transfère au plus ce qui est possible des deux côtés et renvoie le volume transféré ;
- propriétés `taux_remplissage` (en %), `est_plein` et `est_vide` ;
- un attribut de classe `TOLERANCE = 1e-9` pour les comparaisons de floats (`0.1 + 0.2`).

Invariante : `0 <= niveau <= capacite`, **toujours**. Écris un test « aléatoire » qui effectue 10 000 opérations au hasard sur 3 réservoirs (`random.choice`, `random.uniform`) et vérifie l'invariante après **chacune**, ainsi que la conservation du volume total lors des transferts.

## 8 bis. Corriger un bug (`bug_s4j2.py`)

```python
class Article:
    remise = 0
    tags = []

    def __init__(self, nom, prix):
        self.nom = nom
        self._prix = prix

    @property
    def prix(self):
        return self._prix * (1 - self.remise)

    @prix.setter
    def prix(self, valeur):
        if valeur < 0:
            raise ValueError("Prix négatif")
        self.prix = valeur

a = Article("Stylo", -800)
b = Article("Cahier", 2500)
a.tags.append("promo")
a.remise = 0.1
print(b.tags, b.prix)
b.prix = 3000
```

Identifie les quatre problèmes. Pour chacun, indique s'il plante ou s'il produit un comportement silencieusement faux.

## 9. Critères de réussite

- [ ] Je sais énoncer les invariantes de mes classes.
- [ ] Toute modification d'état passe par une méthode ou un setter qui valide.
- [ ] Dans `__init__`, j'affecte via les propriétés pour réutiliser la validation.
- [ ] Je calcule les valeurs dérivées au lieu de les stocker.
- [ ] Je distingue attributs de classe et attributs d'instance, et je n'y mets jamais d'objet mutable partagé par accident.

## 10. Questions de révision

1. Qu'est-ce qu'une invariante ? Donne celle d'un compte bancaire.
2. Pourquoi le setter stocke-t-il dans `self._prix` et non dans `self.prix` ?
3. Pourquoi `prix_ttc` doit-il être une propriété calculée plutôt qu'un attribut ?
4. Que se passe-t-il avec `objet.ATTRIBUT_DE_CLASSE = valeur` ?

## 11. Bilan et préparation du jour 3

Tu sais créer des objets cohérents et protégés. Mais quand plusieurs classes se ressemblent (`ProduitAlimentaire` avec une date de péremption, `ProduitElectronique` avec une garantie), faut-il tout dupliquer ? Au jour 3 : l'**héritage**.
