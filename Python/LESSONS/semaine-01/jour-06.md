# Semaine 1 · Jour 6 : projet calculatrice et évaluation de la semaine

## 1. Objectifs pédagogiques

- Assembler `input`, conversions, conditions et boucles dans un programme complet.
- Construire un programme **par étapes**, en le testant après chaque étape.
- Valider toutes les saisies utilisateur.
- Évaluer mes acquis de la semaine 1, sans aide.

## 2. Prérequis

- Jours 1 à 5. Si un exercice du jour 4 ou 5 n'est pas encore réussi, termine-le d'abord.

---

## 3. Méthode : construire un programme par étapes

Un débutant écrit souvent tout le programme d'un coup, le lance, obtient dix erreurs et ne sait plus par où commencer. Un développeur procède autrement :

1. **Comprendre** ce qu'on doit obtenir, en écrivant des exemples d'entrées et de sorties.
2. **Découper** en étapes, chacune exécutable et testable.
3. **Coder une étape**, l'exécuter et la tester.
4. Passer à l'étape suivante seulement quand la précédente fonctionne.

Chaque étape ajoute **peu** de code. En cas d'erreur, tu sais qu'elle se trouve dans ce que tu viens d'ajouter.

---

## 4. Projet — Calculatrice en ligne de commande

Dossier : `PROJECTS/semaine-01-calculatrice/` · fichier : `calculatrice.py`

### Cahier des charges

```
=== Calculatrice ===
Premier nombre : 12
Opérateur (+ - * / // % **) : /
Second nombre : 5
12.0 / 5.0 = 2.4

Autre calcul ? (o/n) : o
Premier nombre : douze
Erreur : 'douze' n'est pas un nombre valide.
Premier nombre : 12
Opérateur (+ - * / // % **) : ^
Erreur : opérateur inconnu.
Opérateur (+ - * / // % **) : /
Second nombre : 0
Erreur : division par zéro impossible.
Second nombre : 4
12.0 / 4.0 = 3.0

Autre calcul ? (o/n) : n
2 calculs effectués. Au revoir !
```

Exigences :
- les nombres peuvent être entiers, décimaux ou négatifs (`-3.5`) ;
- toute saisie invalide est **redemandée**, sans faire planter le programme ;
- la division par zéro est refusée pour `/`, `//` et `%` ;
- le programme compte les calculs réussis ;
- à la question « Autre calcul ? », seules les réponses `o` et `n` sont acceptées, sans tenir compte de la casse.

**Contrainte :** sans `try`/`except` (prévu en semaine 3) ni fonctions (prévues en semaine 2). Cette contrainte est voulue : elle t'oblige à raisonner sur la validation avec ce que tu connais.

### Le problème des nombres décimaux et négatifs

`.isdigit()` refuse `-3.5`. Il faut donc écrire **ta propre vérification**. Une chaîne représente un nombre valide si :
- elle n'est pas vide ;
- elle commence éventuellement par `-` ;
- le reste ne contient que des chiffres et **au plus un** point ;
- il y a au moins un chiffre.

Indice : retire d'abord le `-` initial s'il existe. Avec une boucle sur les caractères, compte les chiffres, les points et les autres caractères. La méthode `texte.startswith("-")` et la tranche `texte[1:]` (le texte sans son premier caractère) te seront utiles. Nous étudierons les tranches en semaine 2.

### Étapes

**Étape 1 — Calcul unique sans validation.** Lire deux nombres (`float`) et un opérateur, puis afficher le résultat avec une chaîne de `if`/`elif`. Teste chaque opérateur.

**Étape 2 — Opérateur validé.** Redemander l'opérateur tant qu'il ne fait pas partie des sept autorisés. Indice : `operateur in ("+", "-", ...)`.

**Étape 3 — Division par zéro.** Si l'opérateur est `/`, `//` ou `%` et que le second nombre vaut 0, afficher l'erreur et redemander le second nombre.

**Étape 4 — Nombres validés.** Écrire la vérification décrite plus haut, d'abord pour le premier nombre. Une fois qu'elle fonctionne, **copie** le même bloc pour le second nombre. Note la duplication : en semaine 2, une fonction la supprimera.

**Étape 5 — Boucle principale.** Envelopper le tout dans une boucle `while`, avec la question « Autre calcul ? » validée et le compteur de calculs.

**Étape 6 — Finitions.** Afficher les résultats entiers sans `.0` quand c'est possible (indice : `resultat == int(resultat)`), et ajouter les commentaires utiles.

### Plan de test (à remplir dans `PROJECTS/semaine-01-calculatrice/TESTS.md`)

| # | Saisies | Résultat attendu | Obtenu | OK ? |
|---|---|---|---|---|
| 1 | `7`, `+`, `3` | `10` | | |
| 2 | `-2.5`, `*`, `4` | `-10` | | |
| 3 | `7`, `//`, `2` | `3` | | |
| 4 | `7`, `%`, `0` puis `2` | erreur, puis `1` | | |
| 5 | `abc` puis `5` | erreur, puis acceptation | | |
| 6 | `1.2.3` | erreur | | |
| 7 | `-` seul | erreur | | |
| 8 | `.` seul | erreur | | |
| 9 | `2`, `**`, `10` | `1024` | | |
| 10 | Réponse `O` majuscule | on continue | | |
| … | Ajoute au moins 4 cas personnels | | | |

### Critères de réussite du projet

- [ ] Aucune saisie ne fait planter le programme (essaie de le casser !).
- [ ] Tous les cas du plan de test passent.
- [ ] Le code est indenté, commenté avec modération, et les variables ont des noms explicites.
- [ ] Je peux expliquer chaque ligne sans relire mes notes.

---

## 5. Évaluation de la semaine 1

**Règles :** travaille sans regarder le cours, ni tes anciens exercices, ni une IA. Tu as le droit au REPL Python. Durée indicative : 1 h 30. Envoie-moi tes réponses : je corrige, je note et je décide avec toi si une révision est nécessaire avant la semaine 2.

Dossier : `EXERCISES/semaine-01/evaluation/`

### Partie A — Compréhension (sur 6 points)

1. Que se passe-t-il, dans l'ordre, quand on tape `python3 script.py` ? Quelle est la différence entre une `SyntaxError` et une `NameError` du point de vue de l'exécution ?
2. Donne le type et la valeur de : `7 / 7`, `7 // 2.0`, `"7" * 2`, `int("7") * 2`, `bool("0")`, `3 > 2 > 1`.
3. Explique la différence entre `=`, `==`, `break` et `continue`, en une phrase chacun.

### Partie B — Lecture de code (sur 4 points)

Donne l'affichage exact de ce programme, sans l'exécuter :

```python
total = 0
for i in range(1, 6):
    if i == 4:
        continue
    if i % 2 == 0:
        total += i * 10
    else:
        total += i
print(total)

n = 3
while n > 0:
    print(n, end=" ")
    n -= 2
print("fin")
```

### Partie C — Programmation (sur 10 points)

**C1 (3 points) — `eval_c1.py`.** Demande un entier positif `n` (saisie validée) et affiche la somme `1² + 2² + … + n²`.

**C2 (3 points) — `eval_c2.py`.** Demande une phrase et affiche le nombre de voyelles, de consonnes, de chiffres et d'autres caractères (espaces, ponctuation). Les voyelles accentuées comptent comme des voyelles.

**C3 (4 points) — `eval_c3.py`.** Un jeu de « Nombre mystère » amélioré :
- le nombre secret est fixé dans une constante, entre 1 et 100 ;
- 7 essais maximum, avec le nombre d'essais restants affiché ;
- une saisie invalide ou hors de [1, 100] ne compte pas comme un essai ;
- indication « plus grand », « plus petit », ou « brûlant » si l'écart est de 3 ou moins ;
- message de victoire ou de défaite, avec le nombre secret révélé.

### Barème et suite

| Score | Décision |
|---|---|
| 16 à 20 | Semaine 2 |
| 12 à 15 | Semaine 2, avec une révision ciblée des points faibles le jour 1 |
| Moins de 12 | Une journée de révision dédiée avant la semaine 2 |

## 6. Questions de révision de la semaine

1. Quels sont les quatre types de base vus cette semaine ? Donne un exemple de conversion qui échoue pour chacun.
2. Explique, à quelqu'un qui n'a jamais programmé, ce qu'est une boucle et pourquoi on en a besoin.
3. Quelle stratégie suis-tu quand ton programme affiche un message d'erreur ?

## 7. Bilan et préparation de la semaine 2

Tu sais écrire des programmes qui lisent, calculent, décident et répètent. Dans ta calculatrice, tu as probablement remarqué deux limites :
- le **code dupliqué** (validation du premier et du second nombre) ;
- l'impossibilité de **mémoriser plusieurs valeurs** (toutes les notes saisies, l'historique des calculs).

La semaine 2 répond à ces deux problèmes : les **collections** (listes, dictionnaires…) et les **fonctions**.

Mets à jour `PROGRESSION.md` avec ton score et les notions à revoir.
