# Semaine 4 · Jour 3 : l'héritage

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer l'héritage et la relation « **est un** » ;
- créer une classe enfant qui hérite d'une classe parente ;
- **redéfinir** une méthode (*override*) ;
- appeler la version parente avec `super()` ;
- utiliser `isinstance` et `issubclass` ;
- exploiter le **polymorphisme** : traiter des objets différents de façon uniforme ;
- créer mes propres **exceptions** par héritage ;
- reconnaître les abus d'héritage.

## 2. Prérequis

- Jours 1 et 2 : classes, propriétés.

---

## 3. Cours

### 3.1 Le problème

Une boutique vend des produits alimentaires (avec une date de péremption) et des produits électroniques (avec une durée de garantie). Les deux ont un code, un nom, un prix et un stock, avec les mêmes règles d'entrée et de sortie. Copier la classe `Produit` deux fois **duplique** le code : chaque correction devrait être faite deux fois.

L'**héritage** permet de définir une classe **à partir d'une autre** : elle reçoit tout ce que fait la parente, puis **ajoute** ou **modifie** des comportements.

**Analogie :** « Un produit alimentaire **est un** produit, avec en plus une date de péremption. » Si la phrase « X **est un** Y » est naturelle, l'héritage est probablement adapté.

### 3.2 Syntaxe

```python
class Produit:
    def __init__(self, nom, prix):
        self.nom = nom
        self.prix = prix

    def description(self):
        return f"{self.nom} — {self.prix} Ar"

    def prix_avec_tva(self):
        return self.prix * 1.2


class ProduitAlimentaire(Produit):          # hérite de Produit
    pass


pain = ProduitAlimentaire("Pain", 1000)
print(pain.description())    # Pain — 1000 Ar : méthode héritée
print(pain.prix_avec_tva())  # 1200.0
```

- `class Enfant(Parent):` : la classe entre parenthèses est la **classe parente** (ou superclasse, ou classe de base).
- L'enfant hérite de **tout** : attributs initialisés par `__init__` et méthodes.
- Toutes les classes héritent en définitive de `object`.

### 3.3 Étendre `__init__` avec `super()`

```python
from datetime import date

class ProduitAlimentaire(Produit):
    def __init__(self, nom, prix, peremption):
        super().__init__(nom, prix)            # le parent initialise nom et prix
        self.peremption = peremption           # l'enfant ajoute son attribut

    def est_perime(self, aujourd_hui=None):
        aujourd_hui = aujourd_hui or date.today()
        return aujourd_hui > self.peremption


yaourt = ProduitAlimentaire("Yaourt", 1500, date(2026, 10, 20))
print(yaourt.nom, yaourt.est_perime(date(2026, 10, 23)))    # Yaourt True
```

- `super()` donne accès à la classe parente. `super().__init__(nom, prix)` exécute le constructeur du parent **sur le même objet**.
- Si tu oublies cet appel, `self.nom` et `self.prix` n'existent pas : `AttributeError` dès qu'une méthode héritée les utilise.
- Le paramètre `aujourd_hui` permet de **tester** la méthode avec une date fixe. Une fonction qui dépend de `date.today()` ne peut pas être testée de façon reproductible.

### 3.4 Redéfinir une méthode

L'enfant peut **remplacer** une méthode du parent en la redéfinissant avec le même nom :

```python
class ProduitAlimentaire(Produit):
    TAUX_TVA = 0.05                              # taux réduit (exemple)

    def __init__(self, nom, prix, peremption):
        super().__init__(nom, prix)
        self.peremption = peremption

    def prix_avec_tva(self):                     # REDÉFINITION
        return self.prix * (1 + self.TAUX_TVA)

    def description(self):                       # redéfinition qui RÉUTILISE le parent
        base = super().description()
        return f"{base} (à consommer avant le {self.peremption:%d/%m/%Y})"
```

- Quand on appelle `yaourt.prix_avec_tva()`, Python cherche d'abord dans `ProduitAlimentaire`, puis dans `Produit`, puis dans `object`. C'est l'**ordre de résolution des méthodes** (MRO). La première méthode trouvée est utilisée.
- `super().description()` appelle la version du parent : on **complète** au lieu de tout réécrire.
- `{self.peremption:%d/%m/%Y}` : les objets `date` acceptent les codes de `strftime` dans une f-string.

### 3.5 Le polymorphisme

```python
from datetime import date

class ProduitElectronique(Produit):
    def __init__(self, nom, prix, garantie_mois):
        super().__init__(nom, prix)
        self.garantie_mois = garantie_mois

    def description(self):
        return f"{super().description()} (garantie {self.garantie_mois} mois)"


catalogue = [
    Produit("Stylo", 800),
    ProduitAlimentaire("Lait", 3500, date(2026, 11, 2)),
    ProduitElectronique("Clé USB", 25000, 12),
]

for p in catalogue:
    print(p.description())        # chaque objet utilise SA version
```

```
Stylo — 800 Ar
Lait — 3500 Ar (à consommer avant le 02/11/2026)
Clé USB — 25000 Ar (garantie 12 mois)
```

La boucle ne connaît pas le type exact de chaque produit et n'a pas besoin de le connaître : elle appelle `description()`, et chaque objet répond à sa façon. C'est le **polymorphisme** (« plusieurs formes »). Ajouter un nouveau type de produit ne demande **aucune** modification de cette boucle.

À éviter, l'anti-polymorphisme :

```python
for p in catalogue:
    if isinstance(p, ProduitAlimentaire):
        ...
    elif isinstance(p, ProduitElectronique):
        ...
```

Si tu écris une telle chaîne de `isinstance`, c'est souvent le signe qu'une **méthode** devrait être redéfinie dans chaque classe.

### 3.6 `isinstance` et `issubclass`

```python
lait = ProduitAlimentaire("Lait", 3500, date(2026, 11, 2))
isinstance(lait, ProduitAlimentaire)   # True
isinstance(lait, Produit)              # True : un produit alimentaire EST un produit
isinstance(lait, ProduitElectronique)  # False
issubclass(ProduitAlimentaire, Produit)  # True
type(lait) == Produit                  # False : type() ne tient pas compte de l'héritage
```

Préfère `isinstance` à `type(x) == ...`.

### 3.7 Créer ses propres exceptions

Les exceptions sont des classes organisées en hiérarchie. Créer **tes** exceptions permet à l'appelant de distinguer précisément les erreurs métier :

```python
class ErreurStock(Exception):
    """Base de toutes les erreurs liées au stock."""


class StockInsuffisant(ErreurStock):
    def __init__(self, produit, demande, disponible):
        super().__init__(f"{produit} : {demande} demandé(s), {disponible} disponible(s)")
        self.produit = produit
        self.demande = demande
        self.disponible = disponible


class ProduitInconnu(ErreurStock):
    pass


try:
    raise StockInsuffisant("Riz", 10, 3)
except StockInsuffisant as e:
    print(e)                     # Riz : 10 demandé(s), 3 disponible(s)
    print(e.disponible)          # 3 : l'exception transporte des données utiles
except ErreurStock:
    print("Autre erreur de stock")
```

- Une classe d'exception hérite de `Exception`, ou d'une de tes exceptions de base.
- Une classe peut avoir **pour seul contenu** une docstring ou `pass`.
- `except ErreurStock` attrape **toutes** ses sous-classes. En semaine 10, chaque type d'erreur sera converti en code HTTP (404 pour `ProduitInconnu`, 409 pour `StockInsuffisant`).

### 3.8 Quand ne pas utiliser l'héritage

- **Pas de relation « est un »** : une `Voiture` n'**est pas** un `Moteur`, elle **a** un moteur. Dans ce cas, on utilise la composition (jour 4).
- **Hiérarchie profonde** : au-delà de 2 ou 3 niveaux, le code devient difficile à suivre, car il faut remonter toute la chaîne pour comprendre une méthode.
- **L'enfant désactive des comportements du parent** : si `Pingouin(Oiseau)` doit lever une exception dans `voler()`, la hiérarchie est mal conçue.
- **Hériter pour réutiliser une seule fonction** : une fonction ordinaire ou la composition suffisent.

Principe à retenir : un objet enfant doit pouvoir **remplacer** un objet parent partout, sans surprise. C'est le principe de substitution de Liskov.

---

## 4. Exemples commentés

### Exemple — Moyens de paiement

```python
class MoyenPaiement:
    def __init__(self, titulaire):
        self.titulaire = titulaire

    def frais(self, montant):
        return 0

    def payer(self, montant):
        if montant <= 0:
            raise ValueError("Montant invalide.")
        total = montant + self.frais(montant)
        return f"{self.titulaire} paie {total:,.0f} Ar par {self.nom_moyen()}"

    def nom_moyen(self):
        return "moyen inconnu"


class Especes(MoyenPaiement):
    def nom_moyen(self):
        return "espèces"


class MobileMoney(MoyenPaiement):
    def __init__(self, titulaire, numero):
        super().__init__(titulaire)
        self.numero = numero

    def frais(self, montant):
        return max(100, montant * 0.01)        # 1 % avec un minimum de 100

    def nom_moyen(self):
        return f"mobile money ({self.numero[-4:]})"


class Carte(MoyenPaiement):
    def frais(self, montant):
        return montant * 0.025

    def nom_moyen(self):
        return "carte"


for moyen in [Especes("Aina"), MobileMoney("Rado", "0341234567"), Carte("Fara")]:
    print(moyen.payer(20000))
```

```
Aina paie 20,000 Ar par espèces
Rado paie 20,200 Ar par mobile money (4567)
Fara paie 20,500 Ar par carte
```

`payer` est écrit **une seule fois** dans le parent. Il appelle `self.frais()` et `self.nom_moyen()`, que les enfants redéfinissent. Le parent fixe **l'algorithme**, et les enfants fournissent **les détails**. Ce schéma est très courant.

---

## 5. Erreurs courantes

| Problème | Symptôme | Correction |
|---|---|---|
| Oubli de `super().__init__(...)` | `AttributeError` sur un attribut du parent | Appeler le constructeur parent |
| `super.__init__()` (sans parenthèses après `super`) | `TypeError` | `super().__init__()` |
| Signature de redéfinition incompatible | Le polymorphisme casse (`TypeError` dans la boucle) | Garder les mêmes paramètres |
| Chaîne de `isinstance` pour choisir un comportement | Code fragile, à modifier pour chaque nouveau type | Redéfinir une méthode |
| Héritage sans relation « est un » | Conception confuse | Composition (jour 4) |
| Exception personnalisée sans hériter d'`Exception` | `TypeError: exceptions must derive from BaseException` | `class MonErreur(Exception)` |
| `type(x) == Parent` | Faux pour les enfants | `isinstance(x, Parent)` |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-04/jour-03/`

**Exercice 1 — Formes (`ex1_formes.py`).** Classe `Forme` avec les méthodes `aire()` et `perimetre()` (qui lèvent `NotImplementedError`) et `decrire()`, qui les utilise. Sous-classes `Rectangle`, `Carre(Rectangle)` et `Cercle` (avec `math.pi`). Affiche, triées par aire, la description de 5 formes rangées dans une liste.

**Exercice 2 — MRO (`ex2_mro.txt`).** Prédis l'affichage, puis vérifie, et affiche `C.__mro__` :

```python
class A:
    def f(self): return "A.f"
    def g(self): return "A.g -> " + self.f()

class B(A):
    def f(self): return "B.f"

class C(B):
    def g(self): return "C.g -> " + super().g()

print(A().g())
print(B().g())
print(C().g())
```

**Exercice 3 — Exceptions métier (`ex3_exceptions.py`).** Crée une hiérarchie `ErreurBanque` → `SoldeInsuffisant` (avec les attributs `solde` et `montant`), `CompteBloque` et `MontantInvalide`. Adapte ton `CompteBancaire` pour qu'il les lève, et écris un programme qui les intercepte séparément.

## 7. Exercices intermédiaires

**Exercice 4 — Types de comptes (`ex4_comptes.py`).** À partir de ton `CompteBancaire` encapsulé :
- `CompteEpargne` : taux d'intérêt, méthode `appliquer_interets()`, et au maximum 2 retraits par mois (méthode `nouveau_mois()` pour réinitialiser le compteur) ;
- `CompteCourant` : découvert autorisé, ce qui redéfinit la règle de retrait. Réfléchis : quelle méthode du parent faut-il découper pour ne pas dupliquer le code de `retirer` ? (Indice : une méthode `_retrait_autorise(montant)`.) ;
- une fonction `releve_global(comptes)` qui fonctionne pour tous les types, **sans `isinstance`**.

**Exercice 5 — Employés (`ex5_employes.py`).** `Employe(nom, salaire_base)` avec `salaire_mensuel()`. Sous-classes : `Commercial` (base plus 5 % du chiffre d'affaires du mois), `Manager` (base plus 200 000 par personne dans l'équipe), `Stagiaire` (indemnité fixe, et `salaire_base` ignoré). Calcule la masse salariale totale d'une liste. Réponds en commentaire : la classe `Stagiaire` respecte-t-elle le principe de substitution ? Justifie.

**Exercice 6 — Notifications (`ex6_notifications.py`).** Classe `Notification(destinataire, message)` avec `envoyer()`, qui renvoie une chaîne simulant l'envoi, et `valider()`. Sous-classes `Email` (valide le format d'adresse), `SMS` (valide le numéro et tronque à 160 caractères), `Push` (exige un jeton). Écris une fonction `envoyer_toutes(notifications)` qui renvoie le nombre de succès et la liste des échecs avec leur raison.

## 8. Défi — Mini-jeu de rôle (`defi_combat.py`)

Une classe `Personnage(nom, pv, attaque, defense)` avec `est_vivant`, `subir(degats)` et `attaquer(cible)`. Sous-classes :
- `Guerrier` : 20 % de chances de coup critique (×2) ;
- `Mage` : une attaque magique qui ignore la défense, avec du mana limité (au retour à 0 mana, attaque normale) ;
- `Soigneur` : une méthode `soigner(allie)`, et un PV maximum à respecter.

Écris une fonction `combat(equipe_a, equipe_b, graine)` qui fait s'affronter deux équipes tour par tour et renvoie le journal du combat et l'équipe gagnante. `random.seed(graine)` rend le combat **reproductible**, donc testable. La boucle de combat ne doit contenir **aucun** `isinstance`.

## 8 bis. Corriger un bug (`bug_s4j3.py`)

```python
class Vehicule:
    def __init__(self, immatriculation, vitesse_max):
        self.immatriculation = immatriculation
        self.vitesse_max = vitesse_max

    def description(self):
        return f"{self.immatriculation} ({self.vitesse_max} km/h)"

class Camion(Vehicule):
    def __init__(self, immatriculation, vitesse_max, charge_max):
        self.charge_max = charge_max

    def description(self, avec_charge):
        return super.description() + f" charge {self.charge_max} t"

flotte = [Vehicule("1234 TAA", 180), Camion("5678 TBB", 90, 12)]
for v in flotte:
    print(v.description())
```

Trouve les trois bugs, puis explique lequel casse le polymorphisme.

## 9. Critères de réussite

- [ ] Je n'utilise l'héritage que si la relation « est un » est naturelle.
- [ ] J'appelle toujours `super().__init__()` dans le constructeur enfant.
- [ ] Mes redéfinitions gardent la même signature.
- [ ] Mes boucles polymorphes ne contiennent pas de `isinstance`.
- [ ] Je crée des exceptions métier hiérarchisées.

## 10. Questions de révision

1. Que fait `super().__init__(...)`, et que se passe-t-il si on l'oublie ?
2. Qu'est-ce que le polymorphisme ? Donne un exemple tiré de ton code.
3. Pourquoi une chaîne de `isinstance` est-elle souvent un mauvais signe ?
4. Pourquoi créer ses propres classes d'exceptions plutôt que d'utiliser `ValueError` partout ?

## 11. Bilan et préparation du jour 4

L'héritage modélise la relation « **est un** ». Mais la plupart des relations du monde réel sont du type « **a un** » : une commande **a des** lignes, un panier **a des** produits, un magasin **a un** stock. Au jour 4 : la **composition**, puis les **méthodes spéciales**, qui permettent à tes objets de s'intégrer naturellement au langage (`print`, `==`, `len`, `sorted`, `in`…).
