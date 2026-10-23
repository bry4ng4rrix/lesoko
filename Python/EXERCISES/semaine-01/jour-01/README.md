# Semaine 1 · Jour 1 — Exercices

Crée chaque fichier dans ce dossier et lance-le avec `python3 nom_du_fichier.py`.
**N'utilise pas `input()`** : il sera présenté au jour 2. Les valeurs sont écrites directement dans le code.

## Exercices faciles

### Exercice 1 — Prédire avant d'exécuter (`ex1_prediction.txt`)
**Sans lancer Python**, écris ce qu'affiche chaque ligne. Vérifie ensuite dans le REPL (`python3`) et note tes erreurs de prédiction.

```python
print(10 / 4)
print(10 // 4)
print(10 % 4)
print(2 + 3 * 4)
print((2 + 3) * 4)
print("5" + "5")
print(5 + 5)
print("ab" * 2, "cd", sep="|")
print(type(10 / 2))
print(len("Bonjour !"))
```

### Exercice 2 — Carte de visite (`ex2_carte.py`)
Crée trois variables : `prenom`, `ville` et `langage_prefere`.
Affiche exactement, avec tes propres valeurs :

```
=== Carte de visite ===
Prénom : Rado
Ville : Antsirabe
J'apprends : Python
=======================
```

Contraintes : chaque valeur doit venir d'une variable, et au moins une ligne doit utiliser une f-string.

### Exercice 3 — Panier (`ex3_panier.py`)
- `prix_stylo = 800`, `quantite_stylos = 3`
- `prix_cahier = 2500`, `quantite_cahiers = 2`

Calcule le total de chaque article et le total général dans des variables, puis affiche :

```
Stylos : 3 x 800 = 2400
Cahiers : 2 x 2500 = 5000
Total : 7400
```

Change ensuite une quantité : tout doit se mettre à jour sans toucher aux lignes `print`.

## Exercices intermédiaires

### Exercice 4 — Convertisseur de durée (`ex4_duree.py`)
`secondes_totales = 3725`. Calcule les heures, les minutes et les secondes restantes avec `//` et `%` uniquement.

Résultat attendu : `3725 s = 1 h 2 min 5 s`

Teste aussi avec `59`, `60`, `3600` et `86399`, et note les résultats obtenus.

### Exercice 5 — Un seul `print` (`ex5_sep_end.py`)
1. En **un seul appel** à `print`, avec quatre arguments `"2026"`, `"10"`, `"23"` et `"15h00"`, affiche :
   `2026/10/23/15h00`
2. Avec **deux appels** à `print`, affiche sur **une seule ligne** :
   `Chargement... terminé !`

## Défi pratique (sans solution immédiate)

### Défi — Ticket de caisse (`defi_ticket.py`)
Trois articles, chacun avec un nom, un prix unitaire et une quantité, soit neuf variables.
Une constante `TAUX_TVA = 0.20`. Les prix saisis sont hors taxes (HT).

Affiche un ticket comme celui-ci (les valeurs dépendent de tes choix) :

```
------- TICKET -------
Pain        x2   1200
Lait        x1   3500
Riz         x5  15000
----------------------
Total HT  :  19700
TVA (20%) :  3940.0
Total TTC :  23640.0
----------------------
```

Contraintes :
- aucune valeur calculée ne doit être écrite à la main : tout est calculé ;
- le pourcentage affiché (`20%`) doit être calculé à partir de `TAUX_TVA` ;
- bonus : aligne les colonnes. Cherche « format specification mini-language » dans la documentation officielle de Python (indice : `{nom:<10}`).

## Corriger un bug

### Bug — `bug_01.py`
Le fichier `bug_01.py` contient **trois erreurs**. Pour chacune :
1. lance le script ;
2. recopie le **type d'erreur** et le **numéro de ligne** ;
3. explique la cause en une phrase ;
4. corrige, puis relance.

Résultat attendu une fois corrigé :

```
Produit : Clavier
Prix : 45000
Stock après vente : 7
```

## Questions de compréhension
Réponds en quelques phrases, avec tes mots :
1. Quelle différence y a-t-il entre `"42"` et `42` ? Donne une opération qui fonctionne avec l'un et échoue avec l'autre.
2. Dans `compteur = compteur + 1`, pourquoi ce n'est pas une équation absurde ? Que fait Python, étape par étape ?
3. Un script contient une `SyntaxError` à la ligne 10. Les `print` des lignes 1 à 9 s'affichent-ils ? Et si l'erreur est une `NameError` à la ligne 10 ? Explique la différence.

## Critères de réussite
- [ ] Tous les scripts s'exécutent sans erreur avec `python3`.
- [ ] Les sorties correspondent exactement au format demandé.
- [ ] Aucune valeur calculée n'est écrite à la main.
- [ ] Les noms de variables sont explicites et en `snake_case`.
- [ ] Je sais expliquer chaque ligne de mon code.
- [ ] J'ai trouvé les trois bugs en lisant les messages d'erreur, sans deviner.
