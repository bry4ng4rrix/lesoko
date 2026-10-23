# Semaine 4 · Jour 5 : concevoir avec des objets — fonctions ou classes, dataclasses, méthodes de classe

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- choisir entre une fonction, un dictionnaire, une classe et une dataclass ;
- utiliser `@dataclass` pour les classes de données ;
- écrire des **méthodes de classe** (`@classmethod`), notamment des constructeurs alternatifs (`depuis_dict`) ;
- écrire des **méthodes statiques** (`@staticmethod`) et savoir quand les éviter ;
- sérialiser et désérialiser des objets en JSON ;
- appliquer une démarche de conception : identifier les classes, leurs responsabilités et leurs relations.

## 2. Prérequis

- Jours 1 à 4 de la semaine 4.

---

## 3. Cours

### 3.1 Fonction ou classe ?

La POO n'est pas une fin en soi. Beaucoup de débutants créent des classes partout, ce qui donne du code plus long sans être meilleur.

| Situation | Outil | Exemple |
|---|---|---|
| Une transformation : entrées → sortie, sans état | **Fonction** | `calculer_tva(prix)`, `valider_email(texte)` |
| Des données groupées, sans règle particulière | **dict**, **tuple**, ou **dataclass** | Une ligne de CSV, une configuration |
| Des données avec des **règles** à protéger (invariantes) | **Classe** encapsulée | `CompteBancaire`, `Stock` |
| Un état qui évolue au fil d'opérations | **Classe** | `Panier`, `Partie` de jeu |
| Plusieurs variantes d'un comportement interchangeables | **Classes** (polymorphisme) | Moyens de paiement, stratégies de remise |

**Signaux** qu'une classe serait utile :
- plusieurs fonctions prennent toutes le **même** dictionnaire en premier paramètre (`ajouter(stock, ...)`, `retirer(stock, ...)`, `valeur(stock)`) : ce dictionnaire et ces fonctions forment une classe ;
- tu valides le même dictionnaire à plusieurs endroits ;
- tu transportes 5 variables ensemble partout.

**Signaux** qu'une classe est inutile :
- elle n'a que `__init__` et **une** méthode : c'est une fonction déguisée ;
- elle n'a **aucune** méthode et aucune règle : une dataclass suffit ;
- son nom se termine par `Manager`, `Helper` ou `Utils` et elle n'a pas d'état : ce sont des fonctions.

### 3.2 Les dataclasses

Écrire `__init__`, `__repr__` et `__eq__` pour une classe de données est répétitif. Le module `dataclasses` les génère :

```python
from dataclasses import dataclass, field

@dataclass
class Adresse:
    rue: str
    ville: str
    code_postal: str = "101"            # valeur par défaut


a = Adresse("Lot II A 12", "Antananarivo")
print(a)                                # Adresse(rue='Lot II A 12', ville='Antananarivo', code_postal='101')
print(a == Adresse("Lot II A 12", "Antananarivo"))   # True : __eq__ généré, compare tous les champs
```

- La syntaxe `nom: type` est une **annotation de type**. Elle déclare les champs. Python ne vérifie pas les types à l'exécution : c'est une documentation, exploitée par les outils. Nous étudierons les annotations en détail en semaine 5.
- `__init__`, `__repr__` et `__eq__` sont générés automatiquement.

**Options utiles :**

```python
@dataclass(frozen=True)                  # immuable : toute modification lève une erreur, et l'objet est hachable
class Coordonnees:
    lat: float
    lon: float


@dataclass(order=True)                   # génère <, <=, >, >= en comparant les champs dans l'ordre
class Version:
    majeure: int
    mineure: int


@dataclass
class Commande:
    client: str
    lignes: list = field(default_factory=list)   # JAMAIS lignes: list = [] (erreur levée par dataclass)
```

**Validation avec `__post_init__` :** une dataclass peut garder des règles.

```python
@dataclass
class Depense:
    montant: float
    categorie: str
    description: str = ""

    def __post_init__(self):           # appelée automatiquement après le __init__ généré
        if self.montant <= 0:
            raise ValueError("Le montant doit être positif.")
        self.categorie = self.categorie.strip().lower()
```

Limite : une dataclass ordinaire ne protège pas les modifications **après** la création (`d.montant = -5` passe). Pour de vraies invariantes durables, utilise `frozen=True`, ou une classe classique avec des propriétés (jour 2).

### 3.3 Méthodes de classe : `@classmethod`

Une méthode de classe reçoit **la classe** (`cls`) au lieu de l'objet (`self`). Son usage principal est de fournir des **constructeurs alternatifs** :

```python
from dataclasses import dataclass, asdict

@dataclass
class Produit:
    code: str
    nom: str
    prix: float
    quantite: int = 0

    @classmethod
    def depuis_dict(cls, d):
        """Crée un Produit à partir d'un dict (issu d'un JSON, par exemple)."""
        return cls(code=d["code"], nom=d["nom"], prix=float(d["prix"]),
                   quantite=int(d.get("quantite", 0)))

    @classmethod
    def depuis_ligne_csv(cls, ligne, separateur=";"):
        code, nom, prix, quantite = [x.strip() for x in ligne.split(separateur)]
        return cls(code, nom, float(prix), int(quantite))

    def vers_dict(self):
        return asdict(self)                    # fonction du module dataclasses


p1 = Produit.depuis_dict({"code": "P1", "nom": "Riz", "prix": "2800"})
p2 = Produit.depuis_ligne_csv("P2 ; Sel ; 600 ; 120")
```

Pourquoi `cls(...)` plutôt que `Produit(...)` ? Si une sous-classe `ProduitAlimentaire` hérite de cette méthode, `ProduitAlimentaire.depuis_dict(...)` créera alors bien un `ProduitAlimentaire`.

Les méthodes de classe servent aussi à manipuler des attributs de classe (compteurs, registres).

### 3.4 Méthodes statiques : `@staticmethod`

```python
class Produit:
    @staticmethod
    def code_valide(code):
        return len(code) == 4 and code[0] == "P" and code[1:].isdigit()
```

Ni `self` ni `cls` : c'est une simple fonction rangée dans la classe, parce qu'elle s'y rapporte. C'est utile pour la lisibilité, mais **une fonction de module convient souvent tout aussi bien**. Ne les multiplie pas.

| Décorateur | Premier paramètre | Accès à | Usage |
|---|---|---|---|
| (aucun) | `self` | l'objet et la classe | Comportement d'un objet |
| `@classmethod` | `cls` | la classe | Constructeurs alternatifs |
| `@staticmethod` | (aucun) | rien | Fonction utilitaire liée au sujet |

### 3.5 Sérialiser des objets en JSON

`json.dump` ne sait pas sérialiser tes objets. Le schéma standard repose sur `vers_dict()` et `depuis_dict()` :

```python
import json

def sauvegarder_produits(produits, chemin):
    with open(chemin, "w", encoding="utf-8") as f:
        json.dump([p.vers_dict() for p in produits], f, ensure_ascii=False, indent=2)

def charger_produits(chemin):
    with open(chemin, encoding="utf-8") as f:
        return [Produit.depuis_dict(d) for d in json.load(f)]
```

C'est exactement ce que fera Pydantic en semaine 10, automatiquement : JSON → objet validé → JSON.

### 3.6 Démarche de conception

Face à un énoncé, voici une méthode simple et efficace :

1. **Souligner les noms** de l'énoncé : ce sont les classes candidates.
2. **Souligner les verbes** : ce sont les méthodes candidates.
3. Pour chaque classe candidate, se demander si elle a des **données** et des **règles** propres. Sinon, elle devient un simple attribut ou une dataclass.
4. **Relations** : « est un » donne de l'héritage, « a un » ou « contient » donne de la composition.
5. **Responsabilité unique** : chaque classe doit pouvoir se décrire en une phrase sans « et ».
6. Dessiner un **diagramme** simple (boîtes et flèches) avant de coder.

**Exemple d'énoncé :** « Un **magasin** gère un **catalogue** de **produits** classés par **catégorie**. Les **clients** passent des **commandes** composées de **lignes**. Une commande peut être **validée**, ce qui **diminue** le **stock**, ou **annulée**. »

```
┌────────────┐ 1   * ┌─────────┐ *   1 ┌───────────┐
│  Magasin   │──────▶│ Produit │──────▶│ Categorie │
│            │       └─────────┘       └───────────┘
│            │ 1   * ┌──────────┐ 1   * ┌───────────────┐
│            │──────▶│ Commande │──────▶│ LigneCommande │──▶ Produit
└────────────┘       └──────────┘       └───────────────┘
                          │ 1
                          ▼
                     ┌────────┐
                     │ Client │
                     └────────┘
```

- `Categorie` : un simple nom ? Une dataclass `frozen` suffit, ou même une chaîne.
- `Commande.valider()` modifie le stock. Qui est responsable de vérifier le stock disponible ? Le `Magasin`, qui connaît tous les produits, ou la `Commande` ? Discuter ce genre de question **avant** de coder évite de tout réécrire ensuite.

---

## 4. Exemples commentés

### Exemple — De fonctions éparses à une classe

**Avant** (semaine 3) :

```python
def ajouter_depense(donnees, depense): ...
def supprimer_depense(donnees, id_): ...
def filtrer(depenses, mois=None, categorie=None): ...
def resume_mois(depenses, mois): ...
# toutes manipulent le même dict {"prochain_id": ..., "depenses": [...]}
```

**Après :**

```python
from dataclasses import dataclass, asdict
from datetime import date


@dataclass
class Depense:
    id: int
    date: date
    montant: float
    categorie: str
    description: str = ""

    def vers_dict(self):
        d = asdict(self)
        d["date"] = self.date.isoformat()
        return d

    @classmethod
    def depuis_dict(cls, d):
        return cls(d["id"], date.fromisoformat(d["date"]), float(d["montant"]),
                   d["categorie"], d.get("description", ""))


class Registre:
    """Ensemble des dépenses, avec un identifiant unique jamais réutilisé."""

    def __init__(self, depenses=None, prochain_id=1):
        self._depenses = {d.id: d for d in (depenses or [])}
        self._prochain_id = prochain_id

    def ajouter(self, date_, montant, categorie, description=""):
        dep = Depense(self._prochain_id, date_, montant, categorie, description)
        self._depenses[dep.id] = dep
        self._prochain_id += 1
        return dep

    def supprimer(self, id_):
        try:
            return self._depenses.pop(id_)
        except KeyError:
            raise KeyError(f"Dépense {id_} introuvable.") from None

    def filtrer(self, mois=None, categorie=None):
        resultat = self._depenses.values()
        if mois:
            resultat = [d for d in resultat if d.date.strftime("%Y-%m") == mois]
        if categorie:
            resultat = [d for d in resultat if d.categorie == categorie]
        return sorted(resultat, key=lambda d: d.date)

    def __len__(self):
        return len(self._depenses)

    def vers_dict(self):
        return {"version": 1, "prochain_id": self._prochain_id,
                "depenses": [d.vers_dict() for d in self._depenses.values()]}

    @classmethod
    def depuis_dict(cls, d):
        return cls([Depense.depuis_dict(x) for x in d["depenses"]], d["prochain_id"])
```

Les fonctions qui partageaient le même dictionnaire sont devenues les méthodes d'un `Registre`. Le `prochain_id` est **protégé** : plus personne ne peut l'oublier ou le corrompre. La validation (non montrée ici) peut se faire dans `Depense.__post_init__`.

---

## 5. Erreurs courantes

| Problème | Explication |
|---|---|
| Une classe pour tout | Code plus long, sans bénéfice : une fonction suffit souvent |
| `lignes: list = []` dans une dataclass | `ValueError: mutable default ... use default_factory` |
| Une dataclass utilisée pour protéger des invariantes | Les champs restent modifiables : `frozen=True` ou classe classique |
| `Produit(...)` dans un `@classmethod` | Les sous-classes obtiennent un `Produit` : utiliser `cls(...)` |
| `@staticmethod` partout | Ce sont des fonctions de module déguisées |
| Classe qui « fait tout » (`GestionnaireApplication`) | Plusieurs responsabilités : découper |
| Oublier la conversion des dates pour JSON | `TypeError: Object of type date is not JSON serializable` |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-04/jour-05/`

**Exercice 1 — Choisir l'outil (`ex1_choix.txt`).** Pour chaque besoin, choisis entre fonction, dict, dataclass, dataclass `frozen` et classe encapsulée, et justifie : convertir des euros en ariary ; un point GPS ; les paramètres de configuration d'une application ; un compte bancaire ; une note d'étudiant avec son coefficient ; une partie de morpion ; calculer un IMC ; un intervalle de dates utilisé comme clé de dictionnaire.

**Exercice 2 — Dataclasses (`ex2_dataclasses.py`).** Réécris `Point`, puis `Livre` (jour 4), en dataclasses. Compare le nombre de lignes avec ta version précédente. Que perd-on ? Que gagne-t-on ? Rends `Point` `frozen` et vérifie qu'il est utilisable dans un `set`.

**Exercice 3 — Constructeurs alternatifs (`ex3_constructeurs.py`).** Dataclass `Duree(secondes: int)` avec `@classmethod` : `depuis_minutes(m)`, `depuis_texte("01:30:15")` et `depuis_dict(d)`. Méthode `vers_texte()`. Écris des tests d'aller-retour : `Duree.depuis_texte(d.vers_texte()) == d`.

## 7. Exercices intermédiaires

**Exercice 4 — Conception sur papier (`ex4_conception.md`).** Énoncé : « Une **école** propose des **cours**. Chaque cours a un **enseignant** et des **séances** à date fixe dans une **salle** dont la **capacité** est limitée. Les **élèves** s'inscrivent aux cours. On note la **présence** des élèves à chaque séance. On veut connaître le taux de présence d'un élève et le taux de remplissage d'une salle. »

Produis : la liste des classes avec leur responsabilité en une phrase, leurs attributs et méthodes principales, les relations (héritage ou composition, cardinalités), un diagramme en ASCII, et **trois questions de conception** avec la réponse que tu choisis. Par exemple : qui vérifie la capacité de la salle ? Envoie-le moi avant de coder.

**Exercice 5 — Implémentation (`ex5_ecole.py`).** Implémente ta conception de l'exercice 4, avec des dataclasses pour les objets simples et des classes encapsulées pour les règles. Ajoute des tests et une sauvegarde JSON complète (`vers_dict` / `depuis_dict` à chaque niveau).

**Exercice 6 — Refactorisation des dépenses (`PROJECTS/semaine-03-depenses/`).** Transforme ton gestionnaire de dépenses : `Depense` (dataclass avec validation dans `__post_init__`) et `Registre` (classe). Les fonctions d'interface et d'import/export CSV restent des **fonctions**. Tous tes anciens tests doivent passer, adaptés si nécessaire. Le format du fichier JSON ne doit **pas** changer : les anciennes données restent lisibles. Écris en commentaire ce qui a été simplifié et ce qui est devenu plus sûr.

## 8. Défi — Morpion orienté objet (`defi_morpion.py`)

Conçois **puis** code un morpion (3×3, extensible à N×N avec K symboles alignés pour gagner) :
- `Plateau` : grille, `jouer(ligne, col, symbole)` (lève `CaseOccupee` ou `HorsPlateau`), `gagnant()`, `est_plein()`, `__str__` pour l'affichage ;
- `Joueur` (classe de base) avec `choisir_coup(plateau)` ; `JoueurHumain` (saisie validée) ; `JoueurAleatoire` ; `JoueurMalin` (gagne s'il le peut, bloque sinon, joue au hasard sinon) ;
- `Partie(joueur1, joueur2, taille, alignement)` : la boucle de jeu, polymorphe, **sans `isinstance`** ;
- un mode « tournoi » : 1000 parties entre `JoueurMalin` et `JoueurAleatoire`, avec les statistiques de victoires.

La classe `Plateau` ne fait **aucun** `print` ni `input`.

## 8 bis. Corriger un bug (`bug_s4j5.py`)

```python
from dataclasses import dataclass
import json

@dataclass
class Tache:
    titre: str
    tags: list = []
    faite: bool = False

    @staticmethod
    def depuis_dict(d):
        return Tache(**d)

class TacheUrgente(Tache):
    priorite: int = 1

taches = [Tache("Coder"), TacheUrgente("Déployer")]
json.dumps(taches)
t = TacheUrgente.depuis_dict({"titre": "Test"})
print(type(t).__name__)
```

Corrige les trois problèmes, et explique pourquoi `TacheUrgente.depuis_dict` ne renvoie pas une `TacheUrgente`. `Tache(**d)` décompose le dictionnaire en arguments nommés : cherche « unpacking argument lists » dans le tutoriel officiel.

## 9. Critères de réussite

- [ ] Je justifie chaque classe que je crée, et je sais aussi dire quand ne pas en créer.
- [ ] J'utilise des dataclasses pour les données, et des classes encapsulées pour les règles.
- [ ] Mes constructeurs alternatifs utilisent `@classmethod` et `cls`.
- [ ] Mes objets se sérialisent en JSON et se désérialisent sans perte.
- [ ] Je conçois sur papier avant de coder un ensemble de plusieurs classes.

## 10. Questions de révision

1. Donne deux signaux qui indiquent qu'un groupe de fonctions devrait devenir une classe.
2. Quelles méthodes `@dataclass` génère-t-il ? Que fait `frozen=True` ?
3. Pourquoi utiliser `cls(...)` plutôt que le nom de la classe dans un `@classmethod` ?
4. Quelle différence y a-t-il entre `@classmethod` et `@staticmethod` ?

## 11. Bilan et préparation du jour 6

Tu sais concevoir et implémenter un ensemble de classes qui collaborent. Le jour 6 est consacré au projet **gestion de produits, de stock et de commandes**, première ébauche du projet final de la semaine 12, puis à l'évaluation de la semaine 4.
