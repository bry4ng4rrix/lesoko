# Semaine 4 · Jour 4 : composition et méthodes spéciales

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- modéliser une relation « **a un** » ou « **contient des** » par la composition ;
- choisir entre héritage et composition ;
- **déléguer** un travail à un objet contenu ;
- écrire `__str__` et `__repr__`, et expliquer leur différence ;
- rendre des objets comparables (`__eq__`, `__lt__`) et triables ;
- rendre un objet conteneur compatible avec `len`, `in` et `for` (`__len__`, `__contains__`, `__iter__`) ;
- savoir quand **ne pas** ajouter de méthode spéciale.

## 2. Prérequis

- Jours 1 à 3 : classes, propriétés, héritage, exceptions personnalisées.

---

## 3. Cours — Partie A : la composition

### 3.1 Le problème

Une commande contient des lignes, et chaque ligne associe un produit et une quantité. Est-ce qu'une `Commande` **est un** `Produit` ? Non. Est-ce qu'une `Commande` est une `list` ? Pas vraiment : elle a aussi un client, une date, un statut, et des règles (pas de modification après validation).

Une commande **a des** lignes. La **composition** consiste à construire un objet en y plaçant d'**autres objets** comme attributs.

**Analogie :** une voiture n'hérite pas d'un moteur. Elle **contient** un moteur, des roues et un volant, et chaque pièce a sa propre responsabilité. On peut changer le moteur sans changer la voiture.

### 3.2 Exemple de composition

```python
class Produit:
    def __init__(self, code, nom, prix):
        self.code = code
        self.nom = nom
        self.prix = prix


class LigneCommande:
    def __init__(self, produit, quantite):
        if quantite <= 0:
            raise ValueError("Quantité positive attendue.")
        self.produit = produit           # COMPOSITION : la ligne contient un Produit
        self.quantite = quantite

    @property
    def sous_total(self):
        return self.produit.prix * self.quantite


class Commande:
    def __init__(self, client):
        self.client = client
        self._lignes = []                # COMPOSITION : la commande contient des LigneCommande
        self._validee = False

    def ajouter(self, produit, quantite=1):
        if self._validee:
            raise RuntimeError("Commande déjà validée.")
        for ligne in self._lignes:
            if ligne.produit.code == produit.code:
                ligne.quantite += quantite
                return
        self._lignes.append(LigneCommande(produit, quantite))

    @property
    def total(self):
        return sum(ligne.sous_total for ligne in self._lignes)     # DÉLÉGATION

    def valider(self):
        if not self._lignes:
            raise ValueError("Commande vide.")
        self._validee = True
```

- `Commande.total` ne calcule pas lui-même chaque sous-total : il **délègue** à chaque `LigneCommande`, qui délègue à son tour le prix au `Produit`. Chaque classe a **une responsabilité**.
- `sum(ligne.sous_total for ligne in self._lignes)` : une **expression génératrice**, comme une compréhension mais sans crochets. Elle est passée directement à `sum`.
- La liste `_lignes` est interne. Le reste du programme passe par `ajouter`, ce qui garantit les règles (pas de modification après validation, fusion des doublons).

### 3.3 Héritage ou composition ?

| Question | Réponse | Choix |
|---|---|---|
| « X **est un** Y », et X peut remplacer Y partout ? | Oui | Héritage |
| « X **a un** Y » ou « X **utilise** un Y » ? | Oui | Composition |
| On veut changer le comportement **pendant l'exécution** ? | Oui | Composition |
| Doute | — | **Composition** |

La recommandation classique est de **préférer la composition à l'héritage**. La composition est plus souple : on combine des pièces indépendantes, au lieu de figer une hiérarchie.

Exemple : une commande et son mode de livraison.

```python
class LivraisonStandard:
    def cout(self, commande):
        return 0 if commande.total >= 100_000 else 5000

class LivraisonExpress:
    def cout(self, commande):
        return 15000

class Commande:
    def __init__(self, client, livraison):
        self.client = client
        self.livraison = livraison       # l'objet livraison est interchangeable
        self._lignes = []
    ...
    def total_a_payer(self):
        return self.total + self.livraison.cout(self)
```

Avec l'héritage, il aurait fallu créer `CommandeStandard` et `CommandeExpress`. Et s'il fallait aussi varier le moyen de paiement, on obtiendrait `CommandeExpressCarte`, `CommandeStandardMobileMoney`… une explosion combinatoire. Avec la composition, on assemble simplement `Commande(client, LivraisonExpress())`, et on peut même changer `commande.livraison` en cours de route.

---

## 3. Cours — Partie B : les méthodes spéciales

### 3.4 Le principe

Les méthodes spéciales (ou *dunder methods*, pour *double underscore*) sont des méthodes au nom entouré de `__`, que **Python appelle automatiquement** dans certaines situations :

| Tu écris | Python appelle |
|---|---|
| `Produit(...)` | `__init__` |
| `str(p)`, `print(p)`, `f"{p}"` | `__str__` |
| `repr(p)`, affichage dans le REPL ou dans une liste | `__repr__` |
| `a == b` | `__eq__` |
| `a < b`, `sorted(...)` | `__lt__` |
| `len(c)` | `__len__` |
| `x in c` | `__contains__` |
| `for x in c` | `__iter__` |

Tu ne les appelles **jamais** directement (pas de `p.__str__()`). Tu les **définis**, et Python les utilise.

### 3.5 `__str__` et `__repr__`

```python
class Produit:
    def __init__(self, code, nom, prix):
        self.code = code
        self.nom = nom
        self.prix = prix

    def __str__(self):
        """Pour l'UTILISATEUR : lisible."""
        return f"{self.nom} ({self.prix:,} Ar)"

    def __repr__(self):
        """Pour le DÉVELOPPEUR : non ambigu, idéalement du code Python valide."""
        return f"Produit({self.code!r}, {self.nom!r}, {self.prix!r})"


p = Produit("P001", "Riz", 2800)
print(p)          # Riz (2,800 Ar)
print(repr(p))    # Produit('P001', 'Riz', 2800)
print([p])        # [Produit('P001', 'Riz', 2800)] : les conteneurs utilisent repr
```

- `__str__` produit l'affichage destiné à l'utilisateur.
- `__repr__` produit l'affichage destiné au débogage. Par convention, il ressemble à l'appel qui recréerait l'objet. `!r` applique `repr` à chaque valeur, ce qui ajoute les guillemets aux chaînes.
- Si seul `__repr__` est défini, `print` l'utilise aussi. **Définis toujours `__repr__` en priorité** : le débogueur et les messages d'erreur l'utilisent.

### 3.6 Égalité : `__eq__`

```python
a = Produit("P001", "Riz", 2800)
b = Produit("P001", "Riz", 2800)
print(a == b)    # False ! Par défaut, == compare l'IDENTITÉ (même objet en mémoire)
```

```python
    def __eq__(self, autre):
        if not isinstance(autre, Produit):
            return NotImplemented          # laisse Python essayer autre chose, puis renvoyer False
        return self.code == autre.code     # deux produits sont égaux s'ils ont le même code
```

- **C'est toi qui décides** de ce que signifie « égal » pour ton objet : le même code ? Tous les attributs identiques ?
- `return NotImplemented` (et non `False`, ni `raise`) est la convention quand on ne sait pas comparer avec l'autre type.
- `is` teste l'**identité** (le même objet) et `==` teste l'**égalité** (la même valeur, selon `__eq__`).

**Attention :** définir `__eq__` rend l'objet **non hachable** (`__hash__` est mis à `None`). L'objet ne peut plus être une clé de dictionnaire ni un élément d'ensemble. Si tu en as besoin, et si les attributs utilisés par `__eq__` ne changent jamais, ajoute :

```python
    def __hash__(self):
        return hash(self.code)
```

### 3.7 Ordre : `__lt__`

```python
    def __lt__(self, autre):
        if not isinstance(autre, Produit):
            return NotImplemented
        return self.prix < autre.prix


produits = [Produit("P2", "Huile", 9500), Produit("P1", "Sel", 600), Produit("P3", "Riz", 2800)]
print(sorted(produits))       # trié par prix, grâce à __lt__
print(min(produits))          # Sel (600 Ar)
```

`sorted` n'utilise que `<`. Pour disposer aussi de `<=`, `>` et `>=`, on peut les définir, ou utiliser le décorateur `functools.total_ordering` (cherche-le dans la documentation).

Un ordre « naturel » n'est pas toujours évident : faut-il trier les produits par prix, par nom ou par code ? Quand il n'y a pas d'ordre évident, **ne définis pas** `__lt__` : utilise `sorted(produits, key=lambda p: p.nom)`, qui est plus explicite.

### 3.8 Conteneurs : `__len__`, `__contains__`, `__iter__`

```python
class Commande:
    ...
    def __len__(self):
        return len(self._lignes)

    def __contains__(self, produit):
        return any(l.produit == produit for l in self._lignes)

    def __iter__(self):
        return iter(self._lignes)


cmd = Commande("Aina")
cmd.ajouter(riz, 2)
print(len(cmd))           # 1
print(riz in cmd)         # True
for ligne in cmd:         # parcours direct
    print(ligne.produit, ligne.quantite)
```

- `any(...)` renvoie `True` si au moins un élément est vrai, et `all(...)` si tous le sont.
- `__iter__` renvoie un **itérateur**. `iter(self._lignes)` délègue à la liste interne : l'extérieur peut **parcourir** sans pouvoir **modifier** la liste.
- Si `__len__` est défini, `if cmd:` est faux quand la longueur vaut 0.

### 3.9 Ne pas en abuser

N'ajoute une méthode spéciale que si le comportement est **évident** pour le lecteur. `commande + produit` pour ajouter un produit est astucieux, mais surprenant : préfère `commande.ajouter(produit)`. Le code se lit beaucoup plus souvent qu'il ne s'écrit.

---

## 4. Exemples commentés

### Exemple — Panier complet

```python
class Panier:
    def __init__(self):
        self._articles = {}                       # produit -> quantité (Produit doit être hachable)

    def ajouter(self, produit, quantite=1):
        if quantite <= 0:
            raise ValueError("Quantité positive attendue.")
        self._articles[produit] = self._articles.get(produit, 0) + quantite

    def retirer(self, produit, quantite=1):
        if produit not in self._articles:
            raise KeyError(f"{produit} n'est pas dans le panier.")
        self._articles[produit] -= quantite
        if self._articles[produit] <= 0:
            del self._articles[produit]

    @property
    def total(self):
        return sum(p.prix * q for p, q in self._articles.items())

    def __len__(self):
        return sum(self._articles.values())       # nombre total d'articles

    def __contains__(self, produit):
        return produit in self._articles

    def __iter__(self):
        return iter(self._articles.items())

    def __repr__(self):
        return f"Panier({len(self)} articles, total={self.total})"


riz = Produit("P001", "Riz", 2800)
sel = Produit("P002", "Sel", 600)
panier = Panier()
panier.ajouter(riz, 2)
panier.ajouter(sel)
panier.ajouter(Produit("P001", "Riz", 2800))     # même code, donc même produit : cumulé
print(panier)                                    # Panier(4 articles, total=9000)
for produit, qte in panier:
    print(f"{qte} x {produit}")
```

Cet exemple suppose que `Produit` définit `__eq__` **et** `__hash__` sur `code`. Sinon, la troisième ligne créerait une entrée séparée, puisque les deux objets seraient différents. Vérifie-le en retirant `__hash__` et `__eq__`.

---

## 5. Erreurs courantes

| Problème | Symptôme | Correction |
|---|---|---|
| `__str__` qui fait `print` | `TypeError: __str__ returned non-string (type NoneType)` | `return` une chaîne |
| `__eq__` défini sans `__hash__` | `TypeError: unhashable type` dans un set ou un dict | Ajouter `__hash__`, sur des attributs immuables |
| `__eq__` qui renvoie `False` pour un autre type | Comparaisons asymétriques | `return NotImplemented` |
| `__repr__` absent | Listes affichées `[<__main__.Produit object at 0x...>]` | Toujours définir `__repr__` |
| Héritage de `list` pour un conteneur métier | Toutes les méthodes de liste exposées, ce qui contourne les règles | Composition plus méthodes spéciales |
| `__iter__` qui renvoie la liste elle-même | `TypeError: iter() returned non-iterator` | `return iter(self._liste)` |
| `self.lignes` public | Modification directe qui contourne les règles | `self._lignes` |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-04/jour-04/`

**Exercice 1 — Point (`ex1_point.py`).** Classe `Point(x, y)` avec `__repr__` (`Point(3, 4)`), `__str__` (`(3, 4)`), `__eq__`, `__hash__`, et une méthode `distance(autre)`. Vérifie que `{Point(1, 2), Point(1, 2)}` ne contient qu'un élément.

**Exercice 2 — Fraction (`ex2_fraction.py`).** Classe `Fraction(num, den)`, toujours simplifiée (`math.gcd`), avec un dénominateur positif et non nul. Définis `__repr__`, `__str__` (`3/4`), `__eq__` et `__lt__`. Vérifie : `Fraction(2, 4) == Fraction(1, 2)`, `sorted([Fraction(1, 2), Fraction(1, 3), Fraction(3, 4)])`. Bonus : `__add__` et `__mul__`. Ici, `+` est **naturel**, contrairement au panier.

**Exercice 3 — Composition (`ex3_composition.txt`).** Pour chaque couple, indique s'il faut utiliser l'héritage ou la composition, et justifie : `Voiture`/`Moteur` ; `Chien`/`Animal` ; `Bibliotheque`/`Livre` ; `Administrateur`/`Utilisateur` ; `Facture`/`LigneFacture` ; `Pile`/`list` ; `CompteEpargne`/`Compte` ; `Ecole`/`Classe`/`Eleve`.

## 7. Exercices intermédiaires

**Exercice 4 — Bibliothèque (`ex4_bibliotheque.py`).** Classes `Livre(isbn, titre, auteur)` (égalité et hachage sur l'ISBN), `Membre(numero, nom)` (au maximum 3 emprunts) et `Bibliotheque` (composition : un catalogue et des membres). Méthodes : `ajouter_livre`, `inscrire`, `emprunter(numero_membre, isbn)`, `rendre(...)`, `disponibles()` et `emprunts_de(membre)`. Utilise des exceptions personnalisées (`LivreIndisponible`, `LimiteEmprunts`, `MembreInconnu`). `Bibliotheque` doit supporter `len()` (nombre de livres) et `in` (par ISBN ou par `Livre`).

**Exercice 5 — Stratégies de remise (`ex5_remises.py`).** Classes `AucuneRemise`, `RemisePourcentage(taux)`, `RemiseMontantFixe(montant)` et `RemiseQuantite(seuil, taux)`, chacune avec une méthode `calculer(commande)`. Une `Commande` reçoit une remise par **composition** et l'applique dans `total_a_payer()`. Écris des tests qui changent la remise d'une même commande à l'exécution.

**Exercice 6 — Playlist (`ex6_playlist.py`).** `Morceau(titre, artiste, duree_secondes)` avec `__str__` (`Titre — Artiste (3:45)`). `Playlist(nom)` contient des morceaux (pas de doublons) et supporte `len` (le nombre de morceaux), `in`, `for` et `__repr__`. Elle a les propriétés `duree_totale` (format `h:mm:ss`) et les méthodes `melanger(graine)`, `trier_par(cle)` et `fusionner(autre)`, qui renvoie une **nouvelle** playlist.

## 8. Défi — Agenda (`defi_agenda.py`)

- `Creneau(debut, fin)` : deux `datetime`, avec `debut < fin` validé. Méthodes `duree`, `chevauche(autre)`, `__contains__` (un `datetime` est-il dans le créneau ?), `__lt__` (tri par début), `__repr__`.
- `Evenement(titre, creneau, lieu=None)` : **composé** d'un `Creneau`.
- `Agenda` : refuse les événements qui se chevauchent (exception `ConflitHoraire`, qui indique l'événement en conflit). Il supporte `len`, `for` (dans l'ordre chronologique) et `in`. Méthodes : `evenements_du_jour(date)`, `prochain_libre(duree, apres)` (trouve le premier créneau libre d'une durée donnée), et `exporter_json(chemin)` / `importer_json(chemin)` (les dates au format ISO).

Écris au moins 15 tests. Les cas limites des intervalles (un événement qui se termine exactement quand l'autre commence se chevauche-t-il ?) doivent faire l'objet d'une **décision documentée**.

## 8 bis. Corriger un bug (`bug_s4j4.py`)

```python
class Etudiant:
    def __init__(self, matricule, nom):
        self.matricule = matricule
        self.nom = nom

    def __eq__(self, autre):
        return self.matricule == autre.matricule

    def __str__(self):
        print(f"{self.nom} ({self.matricule})")

class Classe(list):
    def inscrire(self, etudiant):
        if etudiant not in self:
            self.append(etudiant)

c = Classe()
c.inscrire(Etudiant("E1", "Aina"))
c.inscrire(Etudiant("E1", "Aina bis"))
c.append(Etudiant("E1", "Doublon"))
inscrits = {e for e in c}
print(len(c), c[0], Etudiant("E2", "Rado") == "E2")
```

Exécute-le, puis identifie au moins **quatre** problèmes. Explique en particulier pourquoi hériter de `list` est un mauvais choix ici.

## 9. Critères de réussite

- [ ] Je choisis entre composition et héritage et je sais justifier mon choix.
- [ ] Mes classes conteneurs gardent leurs données internes privées (`_`) et exposent des méthodes.
- [ ] Toutes mes classes ont un `__repr__`.
- [ ] Je définis `__eq__` en décidant consciemment ce que signifie l'égalité, avec `__hash__` si nécessaire.
- [ ] Je n'ajoute que des méthodes spéciales dont le sens est évident.

## 10. Questions de révision

1. Pourquoi « préférer la composition à l'héritage » ? Donne un exemple d'explosion combinatoire.
2. Quelle différence y a-t-il entre `__str__` et `__repr__` ? Lequel définir en priorité ?
3. Pourquoi définir `__eq__` rend-il un objet non hachable ?
4. Quelle différence y a-t-il entre `is` et `==` ?

## 11. Bilan et préparation du jour 5

Tu disposes maintenant de tous les outils de la POO. La question la plus difficile reste : **quand** créer une classe ? Au jour 5, nous verrons comment choisir entre fonctions et classes, les `dataclasses` (des classes de données sans code répétitif), les méthodes de classe, et une démarche de conception pour modéliser un problème.
