# Semaine 3 · Jour 6 : projet gestionnaire de dépenses et évaluation de la semaine

## 1. Objectifs pédagogiques

- Concevoir une application persistante, avec ses données en JSON.
- Appliquer validation, exceptions et séparation logique/interface.
- Importer et exporter du CSV.
- Évaluer mes acquis de la semaine 3, sans aide.

## 2. Prérequis

- Jours 1 à 5 de la semaine 3.

---

## 3. Projet — Gestionnaire de dépenses en terminal

Dossier : `PROJECTS/semaine-03-depenses/` · fichier principal : `depenses.py` · données : `depenses.json`

Ce projet servira de base en semaine 5, où tu le découperas en modules. Soigne-le.

### Cahier des charges

```
=== Mes dépenses ===
1. Ajouter une dépense
2. Lister les dépenses (filtres : mois, catégorie)
3. Modifier une dépense
4. Supprimer une dépense
5. Résumé du mois
6. Importer un CSV
7. Exporter en CSV
0. Quitter
```

**Modèle d'une dépense** (en JSON) :

```json
{
  "id": 7,
  "date": "2026-10-23",
  "montant": 12500.0,
  "categorie": "alimentation",
  "description": "Marché d'Analakely"
}
```

**Fichier de données :**

```json
{
  "version": 1,
  "prochain_id": 8,
  "depenses": [ ... ]
}
```

Règles :
- l'identifiant est unique et **jamais réutilisé**, même après une suppression : c'est le rôle de `prochain_id` ;
- toute donnée est validée avec les validateurs du jour 5 (montant, date, catégorie, description de 100 caractères maximum) ;
- la **sauvegarde** est atomique, et a lieu après chaque modification ;
- un fichier absent signifie un démarrage à vide. Un fichier corrompu est signalé, puis une sauvegarde `.bak` est créée, et le programme ne repart à vide qu'après confirmation ;
- la **liste** s'affiche en tableau aligné (id, date, catégorie, montant, description tronquée à 30 caractères), triée par date ;
- le **résumé du mois** affiche le total, le total par catégorie avec le pourcentage et une barre `████` proportionnelle, la plus grosse dépense, et la moyenne par jour ;
- l'**import CSV** (séparateur `;`, montants avec une virgule) valide chaque ligne, ajoute les lignes valides et affiche le rapport des lignes rejetées avec leur numéro ;
- l'**export CSV** respecte le filtre courant et est compatible avec un tableur (`utf-8-sig`, `;`) ;
- la modification et la suppression demandent un identifiant existant, et la suppression demande une confirmation.

### Conception imposée : séparer les responsabilités

Organise ton fichier en **sections** clairement commentées. En semaine 5, chacune deviendra un module.

```python
# ===== Validation =====
# valider_montant, valider_date, valider_categorie, valider_description, valider_depense

# ===== Persistance (JSON) =====
# charger_donnees(chemin), sauvegarder_donnees(chemin, donnees)

# ===== Logique métier (fonctions pures) =====
# ajouter_depense(donnees, depense) -> donnees
# supprimer_depense(donnees, id) -> donnees     (lève KeyError si l'id est inconnu)
# modifier_depense(donnees, id, changements) -> donnees
# filtrer(depenses, mois=None, categorie=None) -> list
# resume_mois(depenses, "2026-10") -> dict

# ===== Import / export CSV =====
# importer_csv(chemin) -> (depenses_valides, erreurs)
# exporter_csv(depenses, chemin)

# ===== Interface =====
# afficher_tableau, afficher_resume, demander(...), menu, main
```

Contraintes :
- les fonctions métier ne font ni `input`, ni `print`, ni lecture de fichier ;
- la logique métier et la validation ont des **tests** (`assert`) dans une fonction `tester()`, lancée au démarrage avec une option. Par exemple, `python3 depenses.py --test` ; indice : `import sys` et `sys.argv`, que nous verrons en semaine 5 ;
- aucun `except:` nu.

### Étapes

1. **Conception** : rédige `CONCEPTION.md` avec la signature de chaque fonction et les choix de structure, et envoie-le moi.
2. Validation et tests.
3. Persistance : charger et sauvegarder, avec les tests manuels du fichier absent et du fichier corrompu.
4. Logique métier et tests.
5. Interface : ajouter, lister.
6. Modifier, supprimer.
7. Résumé du mois.
8. Import et export CSV, avec un fichier de test de 30 lignes, dont 5 invalides.
9. Relecture finale, nettoyage, `README.md` du projet expliquant comment le lancer.

### Critères de réussite du projet

- [ ] Aucune saisie et aucun fichier, même corrompu, ne fait planter le programme.
- [ ] Aucune perte de données possible : écriture atomique et `.bak` en cas de corruption.
- [ ] Les identifiants restent uniques après des suppressions.
- [ ] Les sections sont clairement séparées, et les fonctions métier sont pures et testées.
- [ ] Le `README.md` du projet permet à quelqu'un d'autre de l'utiliser.

---

## 4. Évaluation de la semaine 3

**Règles :** sans cours, sans tes exercices, sans IA. La documentation officielle de Python est **autorisée** : savoir la consulter fait partie de la compétence. Durée indicative : 2 h.
Dossier : `EXERCISES/semaine-03/evaluation/`

### Partie A — Compréhension (sur 5 points)

1. Quelle différence y a-t-il entre les modes `"w"`, `"a"` et `"x"` ? Donne un cas d'usage pour chacun.
2. Pourquoi faut-il préciser `encoding="utf-8"` et, pour un CSV, `newline=""` ?
3. Dans quel ordre s'exécutent `try`, `except`, `else` et `finally` ? Quand utiliser `else` ?
4. Pourquoi lever une exception dans une fonction métier plutôt qu'afficher un message ?
5. Décris ta méthode de débogage face à un résultat faux **sans** message d'erreur.

### Partie B — Lecture de code (sur 4 points)

Prédis exactement l'affichage, et le contenu final de `f.txt` :

```python
import json

def g(x):
    try:
        r = json.loads(x)
    except json.JSONDecodeError:
        return "invalide"
    else:
        return type(r).__name__
    finally:
        with open("f.txt", "a", encoding="utf-8") as f:
            f.write(x[:2])

open("f.txt", "w").close()
print(g('{"a": 1}'), g("[1,]"), g("null"), g('"7"'))
```

### Partie C — Programmation (sur 11 points)

**C1 (3 points) — `eval_c1.py`.** `compter_extensions(dossier)` renvoie un dictionnaire `extension → nombre de fichiers`, en parcourant un dossier avec `Path(dossier).iterdir()` (cherche-le dans la documentation de `pathlib`). La fonction lève une `NotADirectoryError` si le chemin n'est pas un dossier. Écris les résultats dans `extensions.json`.

**C2 (4 points) — `eval_c2.py`.** Un fichier `inscriptions.csv` (`nom;email;age;formation`) contient des erreurs. Écris un programme qui produit :
- `valides.json` : les inscriptions valides, avec les âges convertis en entiers et les e-mails en minuscules ;
- `rejets.csv` : les lignes rejetées, avec une colonne `raison` ;
- un résumé à l'écran : nombre de lignes, de valides, de rejets, et nombre d'inscrits par formation.

Crée toi-même un fichier de test de 15 lignes, avec au moins 5 types d'erreurs différents.

**C3 (4 points) — `eval_c3.py`.** Écris un **journal d'événements** persistant, uniquement avec des fonctions (pas encore de classes) :
- `enregistrer(chemin, niveau, message)` : ajoute une ligne JSON par événement (format *JSON Lines* : un objet JSON par ligne, mode `"a"`), avec la date et l'heure ISO ; `niveau` doit appartenir à `{"INFO", "ALERTE", "ERREUR"}` ;
- `lire(chemin, niveau=None)` : renvoie les événements, filtrés si besoin, en **ignorant les lignes corrompues** et en les comptant ;
- un petit programme de démonstration avec tests.

Explique en commentaire pourquoi le format *JSON Lines* est plus robuste qu'un seul gros tableau JSON pour un journal.

### Barème et suite

| Score | Décision |
|---|---|
| 16 à 20 | Phase 2 : semaine 4 |
| 12 à 15 | Semaine 4, avec une révision ciblée |
| Moins de 12 | Révision avant de continuer : les fondamentaux doivent être solides avant la POO |

## 5. Bilan de la phase 1

Après trois semaines, tu sais :
- écrire des programmes complets, interactifs et robustes ;
- organiser les données en collections et la logique en fonctions testées ;
- persister des données en JSON et CSV ;
- gérer les erreurs et déboguer méthodiquement.

C'est une base solide. Remarque cependant que dans ton gestionnaire de dépenses, chaque dépense est un dictionnaire : rien n'empêche d'écrire `depense["montnat"]` (faute de frappe), ni d'oublier de valider une modification. La **programmation orientée objet** (semaine 4) permet de regrouper les données **et** les règles qui les protègent.

Mets à jour `PROGRESSION.md` avec le bilan de la phase 1.
