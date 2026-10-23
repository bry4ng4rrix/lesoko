# Semaine 4 · Jour 6 : projet produits, stock et commandes, et évaluation de la semaine

## 1. Objectifs pédagogiques

- Concevoir puis implémenter un système de plusieurs classes qui collaborent.
- Utiliser l'encapsulation, la composition, l'héritage (là où il est justifié), les méthodes spéciales et les exceptions métier.
- Persister l'ensemble en JSON.
- Évaluer mes acquis de la semaine 4, sans aide.

## 2. Prérequis

- Semaine 4, jours 1 à 5.

---

## 3. Projet — Gestion de produits, de stock et de commandes

Dossier : `PROJECTS/semaine-04-stock/` · fichier principal : `stock.py` · données : `magasin.json`

**Ce projet est la première version du projet final.** En semaine 8, il passera à une base de données SQL. En semaine 10, il deviendra une API FastAPI. En semaine 12, il recevra les utilisateurs et sera déployé. Une conception propre maintenant t'épargnera des réécritures.

### Cahier des charges fonctionnel

1. **Catégories** : nom unique, insensible à la casse.
2. **Produits** : code unique (`P` suivi de 4 chiffres), nom, catégorie, prix HT, seuil d'alerte de stock, quantité. Le prix est modifiable, avec validation. La quantité n'est modifiable **que** par des mouvements.
3. **Mouvements de stock** : chaque entrée ou sortie est enregistrée comme un `Mouvement` (identifiant, date et heure, produit, type `ENTREE`/`SORTIE`, quantité, motif). L'**historique** n'est jamais modifié ni supprimé.
4. **Commandes** : client, lignes (produit, quantité, **prix unitaire figé au moment de l'ajout**), statut `BROUILLON` → `VALIDEE` → `LIVREE`, ou `ANNULEE`.
   - en brouillon : on peut ajouter, modifier et retirer des lignes ;
   - à la **validation** : on vérifie que le stock est suffisant pour **toutes** les lignes, puis on crée une sortie pour chaque ligne. C'est **tout ou rien** : si une ligne manque de stock, rien n'est sorti, et une exception indique **toutes** les lignes en défaut ;
   - l'**annulation** d'une commande validée (non livrée) **réintègre** le stock par des mouvements d'entrée ;
   - une commande livrée ou annulée ne peut plus changer.
5. **Rapports** : produits sous le seuil d'alerte, valeur totale du stock, historique des mouvements d'un produit, chiffre d'affaires des commandes livrées.
6. **Persistance** : tout le magasin est sauvegardé dans `magasin.json` (écriture atomique) et rechargé à l'identique.
7. **Interface** : un menu en terminal, **séparé** du modèle.

### Pourquoi figer le prix dans la ligne de commande ?

Si le prix du produit change après la commande, la facture ne doit pas changer. C'est une règle métier universelle (factures, devis). La ligne **copie** donc le prix au moment de l'ajout, au lieu de le lire sur le produit.

### Étape 0 — Conception (obligatoire, à m'envoyer)

Dans `PROJECTS/semaine-04-stock/CONCEPTION.md` :
1. la liste des classes, avec leur responsabilité en une phrase ;
2. pour chacune : les attributs (publics ou internes, et ce qui est en lecture seule), les méthodes, les invariantes ;
3. les exceptions métier, organisées en hiérarchie (par exemple `ErreurMagasin` → `ProduitInconnu`, `StockInsuffisant`, `TransitionInterdite`…) ;
4. un diagramme des relations ;
5. les réponses à ces questions de conception :
   - qui crée les mouvements de stock : `Produit`, `Commande` ou `Magasin` ?
   - comment `Commande.valider()` accède-t-elle au stock sans que `Commande` connaisse tout le magasin ?
   - comment garantir le « tout ou rien » de la validation ?
   - comment représenter le statut ? Pense au module `enum` et cherche `enum.Enum` dans la documentation.

### Étapes de développement

1. Exceptions métier, `Categorie` et `Produit` (avec leurs tests).
2. `Mouvement` (dataclass `frozen`) et l'application des mouvements à un produit.
3. `LigneCommande` et `Commande` : brouillon, ajout et retrait de lignes, total, transitions de statut (testées, y compris les transitions **interdites**).
4. `Magasin` : catalogue, validation d'une commande en tout ou rien, annulation avec réintégration.
5. Rapports.
6. Sérialisation (`vers_dict` / `depuis_dict` à chaque niveau), avec un test d'aller-retour complet : sauvegarder, recharger, puis comparer.
7. Interface en terminal.
8. Le `README.md` du projet, avec un scénario de démonstration.

### Tests minimaux attendus

- Impossible de rendre une quantité négative, ni de modifier la quantité directement.
- La validation d'une commande avec une ligne en défaut ne modifie **aucun** stock.
- L'annulation d'une commande validée restaure exactement les quantités.
- Changer le prix d'un produit ne change pas le total d'une commande existante.
- Les transitions interdites lèvent `TransitionInterdite`, par exemple `LIVREE` → `BROUILLON`.
- La somme des mouvements d'un produit est égale à sa quantité actuelle (moins sa quantité initiale).
- Sauvegarder puis recharger redonne un magasin identique.

### Critères de réussite du projet

- [ ] La conception a été validée avant le code.
- [ ] Aucune invariante ne peut être violée par l'interface publique des classes.
- [ ] Le modèle ne fait ni `input` ni `print`.
- [ ] Tous les tests minimaux passent.
- [ ] Je peux expliquer chaque choix (héritage ou composition, propriétés, exceptions).

---

## 4. Évaluation de la semaine 4

**Règles :** sans cours, sans tes exercices, sans IA. La documentation officielle est autorisée. Durée indicative : 2 h 30.
Dossier : `EXERCISES/semaine-04/evaluation/`

### Partie A — Compréhension (sur 6 points)

1. Explique `self` à quelqu'un qui découvre les classes, avec un exemple d'appel et son équivalent explicite.
2. Qu'est-ce qu'une invariante ? Comment une propriété avec setter aide-t-elle à la garantir ? Quelle est la limite de la convention `_` en Python ?
3. Héritage ou composition : donne un exemple adapté à chacun, et un exemple d'héritage mal utilisé.
4. Quelle différence y a-t-il entre `__str__` et `__repr__` ? Entre `is` et `==` ? Pourquoi `__eq__` affecte-t-il `__hash__` ?
5. Quand une dataclass suffit-elle, et quand faut-il une classe classique ?
6. À quoi sert un `@classmethod` ? Pourquoi `cls(...)` ?

### Partie B — Lecture de code (sur 4 points)

Donne l'affichage exact :

```python
class A:
    n = 0
    def __init__(self, v):
        self.v = v
        A.n += 1
    def __repr__(self):
        return f"A({self.v})"
    def __lt__(self, o):
        return self.v > o.v
    def double(self):
        return type(self)(self.v * 2)

class B(A):
    def __repr__(self):
        return "B:" + super().__repr__()

objets = [A(3), B(1), A(2)]
print(sorted(objets))
print(objets[1].double(), A.n)
print(isinstance(objets[1], A), type(objets[1].double()) is A)
```

### Partie C — Programmation (sur 10 points)

Fichier `eval_s4.py`, avec des tests pour chaque règle.

**Sujet : location de vélos.**
- `Velo` : identifiant (lecture seule), type (`"classique"` ou `"electrique"`), état (`disponible`, `loue`, `maintenance`), kilométrage. Un vélo électrique a en plus un niveau de batterie (0 à 100), et ne peut pas être loué en dessous de 20 % → **héritage justifié ?** Justifie ton choix en commentaire.
- `Location` : vélo, client, début, fin (ou `None`). `cout()` : tarif horaire selon le type, toute heure entamée étant due. Un `__repr__`.
- `Station` (composition) : vélos, locations en cours et terminées. `louer(id_velo, client, debut)`, `rendre(id_velo, fin, km_parcourus)`, `disponibles(type=None)`, `chiffre_affaires()`. Supporte `len` (le nombre de vélos) et `in`.
- Exceptions : `VeloIndisponible`, `BatterieFaible`, `VeloInconnu`, toutes dérivées de `ErreurStation`.
- `Station.vers_dict()` et `Station.depuis_dict()`, avec un test d'aller-retour.

| Critère | Points |
|---|---|
| Modèle correct et encapsulé | 3 |
| Règles et exceptions | 3 |
| Tests (y compris les cas d'erreur) | 2 |
| Sérialisation | 1 |
| Lisibilité, docstrings, `__repr__` | 1 |

### Barème et suite

| Score | Décision |
|---|---|
| 16 à 20 | Semaine 5 : modules et code propre |
| 12 à 15 | Semaine 5, avec une révision ciblée de la POO |
| Moins de 12 | Révision : la POO est indispensable pour FastAPI et Pydantic |

## 5. Bilan des semaines 1 à 4

| Semaine | Compétence |
|---|---|
| 1 | Écrire un programme : variables, types, conditions, boucles |
| 2 | Organiser : collections, fonctions, décomposition |
| 3 | Rendre robuste et persistant : fichiers, JSON, CSV, exceptions, débogage |
| 4 | Modéliser : classes, encapsulation, héritage, composition |

Ton projet de stock tient sans doute dans un seul gros fichier. En semaine 5, tu apprendras à le **découper en modules et en packages**, à gérer un environnement virtuel et des dépendances, à annoter les types et à respecter les conventions PEP 8 : les bases d'un projet professionnel.

Mets à jour `PROGRESSION.md`.
