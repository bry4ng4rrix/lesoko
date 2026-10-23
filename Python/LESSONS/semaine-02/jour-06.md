# Semaine 2 · Jour 6 : projet gestionnaire de notes et évaluation de la semaine

## 1. Objectifs pédagogiques

- Concevoir les structures de données d'un programme avant de coder.
- Découper une application en fonctions pures, testées, et en fonctions d'interface.
- Assembler un menu interactif robuste.
- Évaluer mes acquis de la semaine 2, sans aide.

## 2. Prérequis

- Jours 1 à 5 de la semaine 2, en particulier la décomposition (jour 5).

---

## 3. Méthode : séparer la logique de l'interface

Dans tout logiciel professionnel, on sépare :
- la **logique métier** : calculs, règles, transformations. Ce sont des fonctions **pures**, sans `input` ni `print`, et testées ;
- l'**interface** : dialogue avec l'utilisateur. Ce sont des fonctions qui lisent les saisies, appellent la logique, puis affichent.

Pourquoi ? En semaine 10, tu remplaceras l'interface terminal par une API web. Si la logique est bien isolée, tu la réutiliseras **sans la modifier**.

---

## 4. Projet — Gestionnaire de notes d'étudiants

Dossier : `PROJECTS/semaine-02-notes/` · fichier : `gestion_notes.py`

### Cahier des charges

```
=== Gestion des notes ===
1. Ajouter un étudiant
2. Ajouter une note à un étudiant
3. Afficher tous les étudiants
4. Afficher le classement
5. Rechercher un étudiant
6. Statistiques de la classe
7. Supprimer un étudiant
0. Quitter
```

Règles :
- un étudiant a un **nom unique**, insensible à la casse : « fara » et « Fara » désignent la même personne ;
- une note est un nombre entre 0 et 20, décimal accepté (avec `,` ou `.`) ;
- un étudiant peut avoir zéro note : sa moyenne s'affiche alors « — » et il est classé en dernier ;
- **classement** : par moyenne décroissante, puis par nom en cas d'égalité, avec la mention ;
- **recherche** : partielle et insensible à la casse (« ra » trouve « Rado » et « Rakoto ») ;
- **statistiques** : nombre d'étudiants, moyenne de la classe (calculée sur les étudiants ayant au moins une note), meilleure et pire moyenne, nombre d'admis (moyenne ≥ 10), et répartition par mention ;
- une suppression demande une confirmation.

### Étape 0 — Conception (sur papier ou dans `CONCEPTION.md`)

Réponds **avant de coder** :
1. Quelle structure de données pour l'ensemble des étudiants ? Compare une liste de dictionnaires et un dictionnaire `nom → liste de notes`. Quels sont les avantages de chaque option pour la recherche, l'unicité et l'ordre ?
2. Liste les fonctions **pures** nécessaires, avec leur signature, leur entrée et leur sortie. Par exemple : `moyenne(notes) -> float | None`.
3. Liste les fonctions **d'interface**.
4. Écris au moins 2 `assert` par fonction pure.

Envoie-moi ta conception : je la relis avant que tu codes. C'est l'étape la plus importante.

### Étapes de développement

1. Fonctions pures et leurs tests : `normaliser_nom`, `est_note_valide`, `convertir_note`, `moyenne`, `mention`, `classement`, `rechercher`, `statistiques`. Tous les tests passent **avant** l'étape 2.
2. Fonctions de saisie validée : `demander_nom`, `demander_note`, `demander_choix`.
3. Le menu et les options 1, 2 et 3.
4. Les options 4 et 5.
5. Les options 6 et 7.
6. Relecture : noms, docstrings, suppression du code mort, et `main()` avec `if __name__ == "__main__":`.

### Données de test

Prévois une fonction `donnees_demo()` qui renvoie 6 étudiants déjà remplis (dont un sans note et deux à égalité), afin de tester rapidement sans tout ressaisir.

### Critères de réussite du projet

- [ ] Aucune fonction pure ne fait d'`input` ni de `print`.
- [ ] Toutes les fonctions pures sont testées par des `assert`, y compris les cas limites.
- [ ] Aucune saisie ne fait planter le programme.
- [ ] Le classement gère les égalités et les étudiants sans note.
- [ ] Je peux expliquer le choix de la structure de données.

---

## 5. Évaluation de la semaine 2

**Règles :** sans cours, sans tes exercices, sans IA. Le REPL est autorisé, ainsi que `help()`. Durée indicative : 2 h.
Dossier : `EXERCISES/semaine-02/evaluation/`

### Partie A — Compréhension (sur 5 points)

1. Quand utiliser une liste, un tuple, un ensemble et un dictionnaire ? Donne un exemple concret pour chacun.
2. Explique la différence entre `sorted(l)` et `l.sort()`, et entre `print` et `return`.
3. Que vaut `a` à la fin ? Justifie.

```python
def f(x):
    x.append(1)
    x = [2]
    x.append(3)
a = [0]
f(a)
```

### Partie B — Lecture de code (sur 5 points)

Donne l'affichage exact :

```python
d = {"a": 3, "b": 1, "c": 2}
print(sorted(d))
print(sorted(d, key=lambda k: d[k]))
print([k * v for k, v in d.items() if v > 1])
print({v: k for k, v in d.items()}[1])
s = "Le Python, c'est clair"
print(s.lower().split(",")[0].split()[-1][::-1])
```

### Partie C — Programmation (sur 10 points)

Fichier `eval_s2.py`. Chaque fonction a une docstring et **au moins 3 `assert`**.

**C1 (2 points).** `compter_mots(texte)` renvoie un dictionnaire `mot → occurrences`, sans tenir compte de la casse ni de la ponctuation `.,;:!?`.

**C2 (2 points).** `fusionner(d1, d2)` renvoie un **nouveau** dictionnaire dans lequel les valeurs des clés communes sont additionnées. Les dictionnaires d'origine ne sont pas modifiés, et un `assert` doit le prouver.

**C3 (3 points).** `anagrammes(mots)` regroupe les mots qui sont des anagrammes les uns des autres. Par exemple, `["chien", "niche", "chine", "rat", "art", "tar", "seul"]` donne `[["chien", "niche", "chine"], ["rat", "art", "tar"], ["seul"]]`. L'ordre des groupes suit la première apparition.

**C4 (3 points).** `valider_iban_simplifie(texte)` : supprime les espaces, met en majuscules, et vérifie que la chaîne commence par 2 lettres puis 2 chiffres, contient uniquement des lettres et des chiffres, et compte entre 15 et 34 caractères. La fonction renvoie un tuple `(est_valide, message)`.

### Barème et suite

| Score | Décision |
|---|---|
| 16 à 20 | Semaine 3 |
| 12 à 15 | Semaine 3, avec une révision ciblée |
| Moins de 12 | Révision avant de continuer |

## 6. Questions de révision de la semaine

1. Pourquoi les clés de dictionnaire doivent-elles être immuables ?
2. Comment savoir si une fonction doit modifier son argument ou renvoyer une nouvelle valeur ?
3. Décris ta méthode pour décomposer un problème nouveau.

## 7. Bilan et préparation de la semaine 3

Ton gestionnaire de notes a un défaut majeur : **tout est perdu à la fermeture du programme**. De plus, une saisie imprévue peut encore provoquer une erreur que tu n'as pas anticipée. La semaine 3 résout ces deux problèmes avec les **fichiers** (sauvegarde en JSON et en CSV) et les **exceptions** (`try`/`except`).

Mets à jour `PROGRESSION.md`.
