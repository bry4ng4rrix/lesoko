# Semaine 3 · Jour 4 : le format CSV

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer ce qu'est un fichier CSV et ses pièges (séparateur, guillemets, en-têtes) ;
- lire un CSV avec `csv.reader` et `csv.DictReader` ;
- écrire un CSV avec `csv.writer` et `csv.DictWriter` ;
- expliquer pourquoi on ouvre un CSV avec `newline=""` ;
- convertir et valider les valeurs lues, qui sont **toujours** des chaînes ;
- choisir entre CSV et JSON.

## 2. Prérequis

- Jours 1 à 3 : fichiers, exceptions, JSON.

---

## 3. Cours

### 3.1 Qu'est-ce qu'un CSV ?

**CSV** (*Comma-Separated Values*) est un fichier texte où chaque ligne est un enregistrement et où les champs sont séparés par un délimiteur :

```
date,produit,quantite,prix_unitaire
2026-10-01,riz,3,2800
2026-10-01,sel,10,600
2026-10-02,huile,1,9500
```

- La première ligne est généralement l'**en-tête** (le nom des colonnes).
- Tous les tableurs savent l'ouvrir et l'exporter. C'est le format d'échange de données tabulaires le plus répandu.

### 3.2 Pourquoi ne pas faire simplement `split(",")` ?

```
nom,adresse,ville
Rakoto,"Lot II A 12, Ambohipo",Antananarivo
```

Le champ `adresse` contient une virgule : il est donc entouré de guillemets. `ligne.split(",")` couperait au mauvais endroit. Un champ peut aussi contenir des guillemets (doublés : `""`) ou des retours à la ligne. Le module `csv` gère toutes ces règles. **N'analyse jamais un CSV à la main.**

### 3.3 `newline=""`

Le module `csv` gère lui-même les fins de ligne, y compris les retours à la ligne **à l'intérieur** d'un champ entre guillemets. La documentation officielle demande d'ouvrir les fichiers avec `newline=""`, pour que Python ne transforme pas les fins de ligne avant le module. Sans cela, on obtient des lignes vides parasites (surtout sous Windows) ou des champs multilignes mal lus.

```python
open("ventes.csv", newline="", encoding="utf-8")
```

### 3.4 Lire avec `csv.reader`

```python
import csv

with open("ventes.csv", newline="", encoding="utf-8") as f:
    lecteur = csv.reader(f)
    en_tete = next(lecteur)            # lit la première ligne : ['date', 'produit', 'quantite', 'prix_unitaire']
    for ligne in lecteur:
        print(ligne)                   # ['2026-10-01', 'riz', '3', '2800'] : TOUT est str !
```

- Chaque ligne est une **liste de chaînes**.
- `next(lecteur)` consomme une ligne. On l'utilise ici pour lire l'en-tête séparément.

### 3.5 Lire avec `csv.DictReader` (recommandé)

```python
import csv

with open("ventes.csv", newline="", encoding="utf-8") as f:
    for ligne in csv.DictReader(f):
        print(ligne)
        # {'date': '2026-10-01', 'produit': 'riz', 'quantite': '3', 'prix_unitaire': '2800'}
```

Chaque ligne devient un dictionnaire dont les clés viennent de l'en-tête. Le code est plus lisible (`ligne["quantite"]` plutôt que `ligne[2]`) et résiste à un changement d'ordre des colonnes.

### 3.6 Convertir les valeurs

CSV ne connaît **aucun type** : tout est texte. Il faut convertir, et donc valider.

```python
def convertir_vente(ligne):
    """Convertit un dict de chaînes en vente typée. Lève ValueError si invalide."""
    quantite = int(ligne["quantite"])
    prix = float(ligne["prix_unitaire"])
    if quantite <= 0 or prix < 0:
        raise ValueError(f"Valeurs incohérentes : {ligne}")
    return {
        "date": ligne["date"],
        "produit": ligne["produit"].strip().lower(),
        "quantite": quantite,
        "prix_unitaire": prix,
    }
```

### 3.7 Écrire avec `csv.writer`

```python
import csv

lignes = [
    ["date", "produit", "quantite"],
    ["2026-10-01", "riz", 3],
    ["2026-10-02", "Lot 12, Ambohipo", 1],    # la virgule sera protégée automatiquement
]

with open("sortie.csv", "w", newline="", encoding="utf-8") as f:
    ecrivain = csv.writer(f)
    ecrivain.writerows(lignes)       # ou writerow(ligne) pour une seule ligne
```

Résultat :

```
date,produit,quantite
2026-10-01,riz,3
2026-10-02,"Lot 12, Ambohipo",1
```

Les nombres sont convertis en texte automatiquement.

### 3.8 Écrire avec `csv.DictWriter`

```python
import csv

ventes = [
    {"date": "2026-10-01", "produit": "riz", "quantite": 3},
    {"date": "2026-10-02", "produit": "sel", "quantite": 10},
]

with open("sortie.csv", "w", newline="", encoding="utf-8") as f:
    ecrivain = csv.DictWriter(f, fieldnames=["date", "produit", "quantite"])
    ecrivain.writeheader()
    ecrivain.writerows(ventes)
```

`fieldnames` fixe l'ordre des colonnes. Une clé du dictionnaire absente de `fieldnames` provoque une `ValueError`, sauf avec `extrasaction="ignore"`.

### 3.9 Séparateur et compatibilité tableur

En France et à Madagascar, Excel utilise souvent le **point-virgule**, car la virgule y sert de séparateur décimal.

```python
csv.reader(f, delimiter=";")
csv.writer(f, delimiter=";")
```

Pour qu'Excel reconnaisse l'UTF-8 (et affiche correctement les accents), on peut écrire avec `encoding="utf-8-sig"` : cela ajoute une marque invisible (BOM) au début du fichier. À la lecture, `utf-8-sig` accepte les fichiers avec ou sans BOM.

### 3.10 CSV ou JSON ?

| Critère | CSV | JSON |
|---|---|---|
| Structure | Tableau plat (lignes × colonnes) | Imbriquée (objets, listes) |
| Types | Aucun (tout est texte) | Nombres, booléens, null |
| Ouverture dans un tableur | Oui | Non |
| Échange avec une API | Rare | Standard |
| Taille pour un gros tableau | Compacte | Plus verbeuse (clés répétées) |

---

## 4. Exemples commentés

### Exemple A — Import avec rapport d'erreurs

```python
import csv

def importer_ventes(chemin):
    """Renvoie (ventes_valides, erreurs). Chaque erreur est (numero_ligne, message)."""
    ventes, erreurs = [], []
    with open(chemin, newline="", encoding="utf-8-sig") as f:
        lecteur = csv.DictReader(f, delimiter=";")
        for ligne in lecteur:
            try:
                ventes.append(convertir_vente(ligne))
            except (ValueError, KeyError, TypeError) as e:
                erreurs.append((lecteur.line_num, str(e)))
    return ventes, erreurs
```

- `lecteur.line_num` donne le numéro de ligne dans le fichier, utile pour le rapport. Il tient compte de l'en-tête.
- Une ligne qui a moins de colonnes que l'en-tête donne des valeurs `None` : `int(None)` lève une `TypeError`, d'où sa présence dans le tuple d'exceptions.
- Le programme **ne s'arrête pas** à la première erreur : il les collecte toutes. C'est ce qu'on attend d'un import professionnel.

### Exemple B — Export d'un rapport agrégé

```python
import csv

def exporter_totaux(ventes, chemin):
    totaux = {}
    for v in ventes:
        totaux[v["produit"]] = totaux.get(v["produit"], 0) + v["quantite"] * v["prix_unitaire"]

    with open(chemin, "w", newline="", encoding="utf-8-sig") as f:
        ecrivain = csv.writer(f, delimiter=";")
        ecrivain.writerow(["produit", "chiffre_affaires"])
        for produit, total in sorted(totaux.items(), key=lambda c: c[1], reverse=True):
            ecrivain.writerow([produit, f"{total:.2f}".replace(".", ",")])
```

Le séparateur `;` et la virgule décimale rendent le fichier directement exploitable dans un tableur réglé en français.

---

## 5. Erreurs courantes

| Problème | Symptôme | Correction |
|---|---|---|
| `split(",")` à la main | Champs coupés au mauvais endroit | Module `csv` |
| Oubli de `newline=""` | Lignes vides parasites, champs multilignes cassés | Toujours `newline=""` |
| Oubli de la conversion | `"3" * 2` donne `"33"` | `int()`, `float()` |
| Mauvais délimiteur | Une seule colonne contenant tout | Préciser `delimiter=";"` |
| Accents corrompus dans Excel | `Ã©` | `encoding="utf-8-sig"` |
| BOM non géré à la lecture | Première clé `'﻿date'` au lieu de `'date'` | Lire avec `utf-8-sig` |
| Écrire avant `writeheader()` | Fichier sans en-tête | Appeler `writeheader()` d'abord |
| Itérer deux fois sur le même lecteur | Deuxième boucle vide | Relire le fichier, ou stocker en liste |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-03/jour-04/`

**Exercice 1 — Créer et lire (`ex1_lire.py`).** Crée à la main `etudiants.csv` (nom, prénom, âge, ville), avec 6 lignes dont une adresse contenant une virgule. Lis-le avec `csv.reader`, puis avec `csv.DictReader`, et affiche un tableau aligné.

**Exercice 2 — Écrire (`ex2_ecrire.py`).** À partir de la liste `produits = [("Riz", 2800, 50), ("Huile, 1L", 9500, 12), ("Sel", 600, 120)]`, écris `produits.csv` avec un en-tête. Ouvre-le dans un tableur (LibreOffice Calc), puis vérifie que « Huile, 1L » tient bien dans **une** cellule. Affiche aussi le fichier brut avec `cat` dans le terminal.

**Exercice 3 — Types (`ex3_types.py`).** Lis `produits.csv` et calcule la valeur totale du stock (prix × quantité). Montre d'abord, en commentaire, ce que donne le calcul **sans** conversion, et explique le résultat.

## 7. Exercices intermédiaires

**Exercice 4 — Import tolérant (`ex4_import.py`).** Crée un `ventes.csv` d'au moins 20 lignes, avec un séparateur `;`, dont 4 lignes invalides : quantité non numérique, prix négatif, colonne manquante, produit vide. Écris l'import avec rapport d'erreurs (inspire-toi de l'exemple A, sans le copier) et affiche les totaux par produit et un rapport des lignes rejetées.

**Exercice 5 — Conversions CSV ↔ JSON (`ex5_conversion.py`).** Écris `csv_vers_json(chemin_csv, chemin_json, types)`, où `types` est un dictionnaire `colonne → fonction de conversion`, par exemple `{"quantite": int, "prix": float}`. Écris aussi la fonction inverse `json_vers_csv`. Vérifie qu'un aller-retour conserve les données.

**Exercice 6 — Filtre en ligne de commande (`ex6_filtre.py`).** Le programme demande un fichier CSV, une colonne et une valeur, puis écrit dans un nouveau fichier les seules lignes correspondantes, en gardant l'en-tête. Il gère : fichier absent, colonne inexistante (affiche la liste des colonnes disponibles), aucune ligne trouvée.

## 8. Défi — Relevé bancaire (`defi_releve.py`)

Ta banque t'envoie un export `releve.csv` :

```
Date;Libellé;Débit;Crédit
01/10/2026;Salaire;;850 000,00
03/10/2026;Loyer;300 000,00;
05/10/2026;"Courses Score, Analakely";45 600,50;
...
```

Écris un programme qui :
1. importe le relevé : dates au format `JJ/MM/AAAA`, montants avec des espaces et une virgule décimale, débit **ou** crédit vide ;
2. catégorise chaque opération à l'aide d'un fichier `categories.json` (`{"loyer": "Logement", "courses": "Alimentation", ...}`), par recherche de mot-clé dans le libellé, sans tenir compte de la casse ; les opérations non reconnues vont dans « Autre » ;
3. affiche le solde du mois et les dépenses par catégorie, triées, avec leur pourcentage ;
4. exporte `synthese.csv`, compatible avec un tableur français.

Crée un relevé d'au moins 25 lignes. Pense aux cas limites : les deux colonnes remplies, montant illisible, date invalide.

## 8 bis. Corriger un bug (`bug_s3j4.py`)

```python
import csv

with open("notes.csv", "w") as f:
    w = csv.writer(f)
    w.writerow(["nom", "note"])
    w.writerow(["Aina", 15])
    w.writerow(["Rado", 9])

with open("notes.csv") as f:
    lecteur = csv.DictReader(f)
    admis = [l["nom"] for l in lecteur if l["note"] >= 10]
    moyenne = sum(l["note"] for l in lecteur) / 2

print(admis, moyenne)
```

Identifie tous les problèmes, explique ceux qui produisent une erreur et ceux qui produiraient un résultat faux même sans erreur, puis corrige.

## 9. Critères de réussite

- [ ] J'utilise le module `csv`, jamais `split(",")`.
- [ ] J'ouvre toujours mes CSV avec `newline=""` et un encodage explicite.
- [ ] Je convertis et je valide chaque champ.
- [ ] Mon import collecte les erreurs au lieu de s'arrêter à la première.
- [ ] Je sais choisir entre CSV et JSON.

## 10. Questions de révision

1. Pourquoi `split(",")` ne suffit-il pas pour lire un CSV ?
2. À quoi sert `newline=""` ?
3. Quels avantages `DictReader` a-t-il par rapport à `reader` ?
4. Dans quel cas choisirais-tu CSV plutôt que JSON, et inversement ?

## 11. Bilan et préparation du jour 5

Tes programmes manipulent maintenant des données externes, souvent imparfaites. Au jour 5, nous formaliserons la **validation des données**, puis nous apprendrons à **déboguer** méthodiquement : lire une erreur, formuler une hypothèse, utiliser `breakpoint()` et le débogueur de VS Code.
