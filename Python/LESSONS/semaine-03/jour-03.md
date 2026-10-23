# Semaine 3 · Jour 3 : le format JSON

## 1. Objectifs pédagogiques

À la fin de cette journée, je sais :
- expliquer ce qu'est la **sérialisation** et pourquoi on en a besoin ;
- lire et écrire la syntaxe JSON ;
- connaître la correspondance entre les types JSON et Python ;
- utiliser `json.dump`, `json.load`, `json.dumps` et `json.loads` ;
- produire un JSON lisible et compatible avec les accents ;
- gérer un fichier JSON absent ou corrompu ;
- sauvegarder de manière sûre, sans risquer de perdre les données.

## 2. Prérequis

- Jours 1 et 2 : fichiers, exceptions.
- Semaine 2 : dictionnaires et listes imbriqués.

---

## 3. Cours

### 3.1 Le problème : sauvegarder des structures

```python
etudiants = {"Aina": [15, 12], "Rado": [11]}
```

Pour écrire ce dictionnaire dans un fichier texte, il faudrait inventer un format (`Aina:15,12`), écrire le code qui le produit, puis celui qui l'analyse, et gérer les cas particuliers (un nom qui contient `:`…). La **sérialisation** consiste à transformer une structure en mémoire en texte (ou en octets) pour la stocker ou la transmettre. La **désérialisation** fait l'inverse.

**JSON** (*JavaScript Object Notation*) est un format texte standard, lisible par un humain et compris par **tous** les langages. C'est le format universel des API web : tout ce que tu feras en semaines 9 à 12 passe par JSON.

### 3.2 Syntaxe JSON

```json
{
  "nom": "Aina",
  "age": 21,
  "moyenne": 14.5,
  "admis": true,
  "tuteur": null,
  "notes": [15, 12, 16.5],
  "adresse": {"ville": "Antsirabe", "code": "110"}
}
```

Règles strictes :
- les chaînes et les **clés** sont entre **guillemets doubles** (`'texte'` est invalide) ;
- les clés d'un objet sont **toujours des chaînes** ;
- `true`, `false` et `null` s'écrivent en minuscules ;
- **pas de virgule** après le dernier élément ;
- pas de commentaires.

### 3.3 Correspondance des types

| JSON | Python |
|---|---|
| objet `{}` | `dict` |
| tableau `[]` | `list` |
| chaîne `"..."` | `str` |
| nombre entier | `int` |
| nombre décimal | `float` |
| `true` / `false` | `True` / `False` |
| `null` | `None` |

Conversions avec perte :
- un **tuple** devient un tableau JSON et revient sous forme de **liste** ;
- un **set** n'est pas sérialisable (`TypeError`) : il faut le convertir en liste ;
- une clé de dictionnaire **non-chaîne** est convertie en chaîne : `{1: "a"}` revient comme `{"1": "a"}` ;
- les dates (`datetime`) ne sont pas sérialisables : on les stocke en chaîne ISO, `"2026-10-23"`.

### 3.4 Le module `json`

```python
import json
```

Quatre fonctions, faciles à retenir : le **s** final signifie *string* (chaîne).

| Fonction | De → vers |
|---|---|
| `json.dumps(obj)` | objet Python → chaîne JSON |
| `json.loads(texte)` | chaîne JSON → objet Python |
| `json.dump(obj, fichier)` | objet Python → fichier |
| `json.load(fichier)` | fichier → objet Python |

```python
import json

donnees = {"nom": "Fara", "notes": [17, 16], "admis": True, "tuteur": None}

texte = json.dumps(donnees)
print(texte)          # {"nom": "Fara", "notes": [17, 16], "admis": true, "tuteur": null}
print(type(texte))    # <class 'str'>

retour = json.loads(texte)
print(retour == donnees)   # True
```

### 3.5 Écrire et lire un fichier JSON

```python
import json

etudiants = {"Aina": [15, 12], "Rado": [11], "Héry": []}

with open("etudiants.json", "w", encoding="utf-8") as f:
    json.dump(etudiants, f, ensure_ascii=False, indent=2)

with open("etudiants.json", encoding="utf-8") as f:
    charges = json.load(f)

print(charges["Héry"])    # []
```

Contenu de `etudiants.json` :

```json
{
  "Aina": [
    15,
    12
  ],
  "Rado": [
    11
  ],
  "Héry": []
}
```

- `indent=2` produit un fichier lisible, indenté. Sans ce paramètre, tout tient sur une ligne.
- `ensure_ascii=False` écrit `Héry` tel quel. Sinon, on obtient `Héry` : c'est valide, mais illisible.
- `sort_keys=True` (facultatif) trie les clés, ce qui facilite la comparaison de deux versions avec Git.

### 3.6 Gérer les erreurs de chargement

Deux situations sont prévisibles :
1. le fichier **n'existe pas** (premier lancement) : c'est normal, on part de données vides ;
2. le fichier est **corrompu** (modifié à la main, écriture interrompue) : `json.JSONDecodeError`, une sous-classe de `ValueError`.

```python
import json
from pathlib import Path

def charger(chemin, defaut):
    """Charge un JSON. Renvoie `defaut` si le fichier est absent.

    Lève ValueError si le fichier existe mais est corrompu.
    """
    try:
        with open(chemin, encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        return defaut
    except json.JSONDecodeError as e:
        raise ValueError(f"{chemin} est corrompu (ligne {e.lineno}, colonne {e.colno}) : {e.msg}") from e
```

- `defaut` est fourni par l'appelant : `{}` ou `[]` selon le cas.
- On ne renvoie **pas** silencieusement des données vides en cas de corruption : la sauvegarde suivante **écraserait** le fichier de l'utilisateur. On signale le problème.
- `raise ... from e` conserve l'exception d'origine dans la traceback.

### 3.7 Sauvegarder sans risque : l'écriture atomique

Si le programme plante **pendant** l'écriture en mode `"w"`, le fichier peut rester à moitié écrit, et toutes les données sont perdues. La technique consiste à écrire dans un fichier temporaire, puis à le **renommer**. Sur un même disque, le renommage est quasi instantané et complet.

```python
import json
from pathlib import Path

def sauvegarder(chemin, donnees):
    chemin = Path(chemin)
    temporaire = chemin.with_suffix(".tmp")
    with open(temporaire, "w", encoding="utf-8") as f:
        json.dump(donnees, f, ensure_ascii=False, indent=2)
    temporaire.replace(chemin)      # remplace l'ancien fichier en une opération
```

### 3.8 Valider la structure chargée

`json.load` vérifie la **syntaxe**, pas le **sens**. Un fichier `[1, 2]` est du JSON valide, mais ton programme attend peut-être un dictionnaire de listes. Après le chargement, vérifie la structure :

```python
def valider_etudiants(donnees):
    if not isinstance(donnees, dict):
        raise ValueError("Un objet JSON était attendu.")
    for nom, notes in donnees.items():
        if not isinstance(notes, list):
            raise ValueError(f"Notes de {nom} : une liste était attendue.")
        for n in notes:
            if not isinstance(n, (int, float)) or not 0 <= n <= 20:
                raise ValueError(f"Note invalide pour {nom} : {n!r}")
```

`isinstance(valeur, type)` teste le type, et accepte un tuple de types. `{n!r}` affiche la représentation technique : les guillemets visibles distinguent `"12"` de `12`. En semaine 10, **Pydantic** fera ce travail de validation automatiquement.

---

## 4. Exemples commentés

### Exemple A — Carnet de contacts persistant

```python
import json
from pathlib import Path

FICHIER = Path(__file__).parent / "contacts.json"


def charger_contacts():
    try:
        with open(FICHIER, encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        return []


def sauvegarder_contacts(contacts):
    tmp = FICHIER.with_suffix(".tmp")
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(contacts, f, ensure_ascii=False, indent=2)
    tmp.replace(FICHIER)


def ajouter_contact(contacts, nom, telephone):
    """Renvoie une NOUVELLE liste avec le contact ajouté."""
    return contacts + [{"nom": nom, "telephone": telephone}]


contacts = charger_contacts()
contacts = ajouter_contact(contacts, "Tiana", "034 11 222 33")
sauvegarder_contacts(contacts)
print(f"{len(contacts)} contact(s) enregistré(s).")
```

Lance-le plusieurs fois : le nombre de contacts augmente, preuve que la persistance fonctionne. Ouvre `contacts.json` dans VS Code pour voir le résultat.

### Exemple B — Explorer un JSON imbriqué

```python
import json

reponse = '''
{"ville": "Toamasina",
 "previsions": [
   {"jour": "lundi", "temp": {"min": 22, "max": 30}, "pluie": true},
   {"jour": "mardi", "temp": {"min": 23, "max": 31}, "pluie": false}
 ]}
'''
meteo = json.loads(reponse)
for p in meteo["previsions"]:
    parapluie = "oui" if p["pluie"] else "non"
    print(f"{p['jour']:<7} {p['temp']['min']}–{p['temp']['max']} °C, parapluie : {parapluie}")
```

```
lundi   22–30 °C, parapluie : oui
mardi   23–31 °C, parapluie : non
```

C'est exactement ce que tu feras en semaine 9 avec la réponse d'une vraie API météo.

---

## 5. Erreurs courantes

| Problème | Message | Correction |
|---|---|---|
| Guillemets simples dans le JSON | `JSONDecodeError: Expecting property name enclosed in double quotes` | Guillemets doubles |
| Virgule finale | `JSONDecodeError: Illegal trailing comma before end of object` (le message varie selon la version de Python) | Retirer la virgule |
| `json.dump(obj)` sans fichier | `TypeError: dump() missing 1 required positional argument: 'fp'` | `json.dump(obj, f)` ou `json.dumps(obj)` |
| `json.load("fichier.json")` | `AttributeError: 'str' object has no attribute 'read'` | Passer un fichier ouvert, pas un nom |
| Sérialiser un `set` ou un `datetime` | `TypeError: Object of type set is not JSON serializable` | Convertir (`list(...)`, `.isoformat()`) |
| Clés entières qui reviennent en chaînes | `d[1]` → `KeyError` après rechargement | Utiliser des clés `str`, ou reconvertir |
| Fichier vide | `JSONDecodeError: Expecting value: line 1 column 1` | Écriture interrompue : utiliser l'écriture atomique |
| Corruption remplacée silencieusement par `{}` | Données de l'utilisateur écrasées | Signaler l'erreur, faire une sauvegarde `.bak` |

---

## 6. Exercices faciles

Dossier : `EXERCISES/semaine-03/jour-03/`

**Exercice 1 — Valide ou pas (`ex1_valide.txt`).** Pour chaque texte, dis s'il s'agit de JSON valide, et sinon pourquoi. Vérifie avec `json.loads` dans le REPL.

```
{"a": 1}
{'a': 1}
[1, 2, 3,]
{"actif": True}
"bonjour"
42
{"liste": [1, {"x": null}]}
{1: "un"}
[]
{"a": 1 // commentaire}
```

**Exercice 2 — Aller-retour (`ex2_aller_retour.py`).** Sérialise puis désérialise cet objet, et compare avec `==`. Explique **chaque** différence observée.

```python
original = {"tuple": (1, 2), "cles_int": {1: "un", 2: "deux"}, "vide": None, "decimal": 0.1}
```

Que se passe-t-il si tu ajoutes `"ensemble": {1, 2}` ?

**Exercice 3 — Config (`ex3_config.py`).** Crée à la main un fichier `config.json` contenant `nom_application`, `version`, `langue`, `devise` et `tva` (un nombre). Écris un programme qui le charge et affiche chaque paramètre. S'il est absent, il crée un fichier de configuration par défaut.

## 7. Exercices intermédiaires

**Exercice 4 — Gestionnaire de notes persistant (`PROJECTS/semaine-02-notes/`).** Ajoute à ton projet de la semaine 2 :
- le chargement au démarrage et la sauvegarde après chaque modification, avec une écriture atomique ;
- la gestion du fichier absent ;
- la gestion du fichier corrompu : message, copie en `.bak`, puis démarrage à vide **uniquement après confirmation** de l'utilisateur ;
- une fonction de validation de la structure chargée.

Modifie le JSON à la main pour tester chaque cas d'erreur.

**Exercice 5 — Statistiques sur un JSON (`ex5_ventes.py`).** Crée `ventes.json` : une liste d'au moins 15 ventes `{"date": "2026-10-01", "produit": "riz", "quantite": 3, "prix_unitaire": 2800}`. Calcule le chiffre d'affaires total, par produit et par date, puis écris un **rapport** `rapport.json` qui contient ces agrégats.

**Exercice 6 — Fusion de fichiers (`ex6_fusion.py`).** Deux fichiers `stock_magasin1.json` et `stock_magasin2.json` contiennent chacun un dictionnaire `produit → quantité`. Produis `stock_total.json`, sans modifier les sources. Utilise ta fonction `fusionner` de l'évaluation de la semaine 2 si tu l'as écrite.

## 8. Défi — Quiz configurable (`defi_quiz.py`)

`quiz.json` contient les questions :

```json
{
  "titre": "Python — semaine 2",
  "questions": [
    {"question": "Que renvoie len([1, [2, 3]]) ?", "choix": ["1", "2", "3"], "reponse": 1},
    ...
  ]
}
```

Le programme :
1. charge et **valide** le quiz (structure, index de réponse dans les bornes, au moins 2 choix), en refusant clairement un fichier incorrect ;
2. pose les questions dans un ordre aléatoire (`random.shuffle`) ;
3. affiche le score et les questions ratées avec la bonne réponse ;
4. enregistre l'historique dans `resultats.json` (date au format ISO, score, durée), de façon atomique ;
5. propose d'afficher le meilleur score et la progression.

Rédige au moins 10 questions sur les semaines 1 et 2 : cela te servira aussi de révision.

## 8 bis. Corriger un bug (`bug_s3j3.py`)

```python
import json

def charger():
    try:
        with open("panier.json") as f:
            return json.loads(f)
    except:
        return {}

def sauvegarder(panier):
    with open("panier.json", "w") as f:
        f.write(json.dumps(panier))

panier = charger()
panier[101] = {"nom": "Thé", "qte": 2, "tags": {"bio", "promo"}}
sauvegarder(panier)
panier = charger()
print(panier[101]["nom"])
```

Il y a au moins **cinq** problèmes. Certains plantent, d'autres causent une perte de données silencieuse. Liste-les tous, puis corrige.

## 9. Critères de réussite

- [ ] Je connais par cœur les règles de syntaxe JSON et la correspondance des types.
- [ ] J'utilise toujours `encoding="utf-8"`, `ensure_ascii=False` et `indent`.
- [ ] Je distingue le fichier absent (normal) du fichier corrompu (anormal).
- [ ] Je ne perds jamais de données à cause d'une erreur de chargement.
- [ ] Je valide la structure après le chargement.

## 10. Questions de révision

1. Quelle différence y a-t-il entre `json.dump` et `json.dumps` ?
2. Pourquoi les clés entières d'un dictionnaire deviennent-elles des chaînes après un aller-retour JSON ?
3. Pourquoi est-il dangereux de renvoyer `{}` quand le fichier JSON est corrompu ?
4. Comment fonctionne l'écriture atomique, et quel problème résout-elle ?

## 11. Bilan et préparation du jour 4

JSON est idéal pour les structures imbriquées. Mais les données **tabulaires** (une ligne par vente, une colonne par champ) s'échangent le plus souvent en **CSV**, le format des tableurs (Excel, LibreOffice). Au jour 4, nous verrons le module `csv`.
