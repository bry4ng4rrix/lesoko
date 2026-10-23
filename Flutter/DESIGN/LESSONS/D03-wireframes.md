# D03 — Wireframes et conception des écrans

Durée : 3 h. Prérequis : D01, D02. Exercices : [`EXERCISES/D03.md`](../EXERCISES/D03.md)

## 1. Objectifs pédagogiques

- Différencier wireframe, maquette et prototype.
- Dessiner des wireframes basse fidélité rapidement, sur papier et en texte.
- Structurer un écran mobile en zones.
- Tenir compte de la zone du pouce.
- Prévoir les états d'un écran : chargement, vide, erreur, partiel, idéal.

## 2. Wireframe, maquette, prototype

| | Wireframe | Maquette (mockup) | Prototype |
|---|---|---|---|
| Fidélité | Basse : boîtes grises, texte approximatif | Haute : couleurs, typo, images réelles | Variable, mais **interactif** |
| Sert à | Décider la **structure** et la hiérarchie | Décider l'**apparence** | Tester le **comportement** et les parcours |
| Durée | Minutes | Heures | Heures à jours |
| Quand | Au début, plusieurs versions | Une fois la structure validée | Avant de développer, pour tester |
| Erreur à éviter | Le peaufiner | Le faire avant le wireframe | Le confondre avec l'app finale |

Pourquoi commencer en basse fidélité ? Parce qu'on **jette** facilement un
dessin qui a pris 2 minutes. Une maquette d'une heure, on s'y attache et on la
défend, même si sa structure est mauvaise. De plus, sans couleurs, les
discussions portent sur l'essentiel : « est-ce que ça marche ? » et non « je
n'aime pas ce bleu ».

## 3. Le vocabulaire visuel du wireframe

```
┌──────────┐   Conteneur, carte, écran
[ Bouton ]     Bouton (le plus important en MAJUSCULES ou ▓▓▓ rempli)
[▓ PAYER ▓]    Bouton principal (rempli)
[ ░░░░░░ ]     Champ de saisie
(  ◯  )        Avatar, image ronde
┌─ ╳ ─┐        Image (boîte barrée)
└─────┘
━━━━━━━━       Titre (trait épais)
────────       Texte de paragraphe (trait fin)
───            Texte secondaire court
›              Ouvre un détail
☰ ⋮ ← ✕ 🔍     Icônes de menu, plus, retour, fermer, recherche
```

Sur papier : utilise un feutre épais. Il t'empêche d'entrer dans les détails.

**Méthode « Crazy 8 »** : plie une feuille en 8 cases et dessine 8 versions
différentes du même écran en 8 minutes. La première idée est rarement la
meilleure. Garde ensuite la meilleure version, ou combine-en plusieurs.

## 4. La structure d'un écran mobile

Presque tous les écrans mobiles suivent ce découpage :

```
┌──────────────────────────────┐
│ ▒ Barre d'état (système)     │  ← ne pas y mettre de contenu (SafeArea)
├──────────────────────────────┤
│ ← Titre               🔍  ⋮  │  ← EN-TÊTE : où suis-je, actions globales
├──────────────────────────────┤
│                              │
│                              │
│         CONTENU              │  ← ce pour quoi l'écran existe
│   (défile si nécessaire)     │
│                              │
│                              │
├──────────────────────────────┤
│ [▓▓▓▓ ACTION PRINCIPALE ▓▓▓▓]│  ← ACTION fixée en bas si l'écran a un but
├──────────────────────────────┤
│  🏠     📦     🛒     👤     │  ← NAVIGATION principale
│ Accueil Catal. Panier Compte │
├──────────────────────────────┤
│ ▒ Barre de gestes (système)  │
└──────────────────────────────┘
```

### 4.1 La zone du pouce

La plupart des gens tiennent leur téléphone **d'une main** et utilisent le pouce.

```
┌──────────────────┐
│ ✗✗✗✗✗✗✗✗✗✗✗✗✗✗ │  Difficile : actions rares ou destructives
│ ✗✗✗✗✗✗✗✗✗✗✗✗✗✗ │  (supprimer, paramètres)
│ ~~~~~~~~~~~~~~~~ │  Étirement : contenu, actions secondaires
│ ~~~~~~~~~~~~~~~~ │
│ ✓✓✓✓✓✓✓✓✓✓✓✓✓✓ │  Naturelle : actions fréquentes,
│ ✓✓✓✓✓✓✓✓✓✓✓✓✓✓ │  action principale, navigation
└──────────────────┘
```

Conséquences : l'action principale et la navigation vont en bas. Les actions
dangereuses (supprimer le compte) peuvent être placées loin du pouce, pour
éviter les touches accidentelles.

### 4.2 Grilles et alignements

- **Marges latérales** : 16 dp sur téléphone (Material 3), parfois 24.
- **Grille de 4 colonnes** sur téléphone, 8 sur tablette, 12 sur grand écran.
  Les éléments s'alignent sur les colonnes.
- **Un seul axe d'alignement à gauche** pour le texte et les titres. Chaque
  nouvel axe ajoute du « bruit » visuel.
- Toutes les dimensions sont des **multiples de 4**, et le plus souvent de 8 (D07).

## 5. Les patrons d'écran courants

```
LISTE                    DÉTAIL                   FORMULAIRE
┌────────────────┐       ┌────────────────┐       ┌────────────────┐
│ ← Produits  🔍 │       │ ←          ♡ ⋮ │       │ ✕ Nouveau prod.│
├────────────────┤       │ ┌─ ╳ ────────┐ │       ├────────────────┤
│ ┌╳┐ ━━━━━━   › │       │ │   image    │ │       │ Nom            │
│ └─┘ ───        │       │ └────────────┘ │       │ [ ░░░░░░░░░░ ] │
│ ┌╳┐ ━━━━━━   › │       │ ━━━━━━━━━━━    │       │ Prix (Ar)      │
│ └─┘ ───        │       │ ━━━ 12 500 Ar  │       │ [ ░░░░░░░░░░ ] │
│ ┌╳┐ ━━━━━━   › │       │ ─────────────  │       │ Catégorie      │
│ └─┘ ───        │       │ ─────────────  │       │ [ ░░░░░░░░ ▾ ] │
│            (+) │       │                │       │                │
└────────────────┘       │[▓ AJOUTER ▓▓▓▓]│       │[▓ ENREGISTRER ]│
                         └────────────────┘       └────────────────┘
TABLEAU DE BORD          RECHERCHE                VIDE
┌────────────────┐       ┌────────────────┐       ┌────────────────┐
│ Bonjour Hanta  │       │ ← [░ riz    ✕] │       │ ← Panier       │
│┌──────┐┌──────┐│       ├────────────────┤       │                │
││ 5 ⚠  ││ 120  ││       │ Récents        │       │      ┌─╳─┐     │
││rupt. ││ventes││       │ ─── ───── ──   │       │      └───┘     │
│└──────┘└──────┘│       │ Résultats (3)  │       │ ━━━━━━━━━━━━   │
│ Activité       │       │ ┌╳┐ ━━━━━━   › │       │ ─────────────  │
│ ───────── ───  │       │ ┌╳┐ ━━━━━━   › │       │ [ VOIR LE      │
│ ───────── ───  │       │ ┌╳┐ ━━━━━━   › │       │   CATALOGUE ]  │
└────────────────┘       └────────────────┘       └────────────────┘
```

## 6. Les états d'un écran

Un écran n'a pas **un** aspect, il en a **plusieurs**. Le débutant ne dessine
que l'état idéal. Le professionnel les dessine **tous** :

| État | Quand | Ce qu'il faut montrer |
|---|---|---|
| **Idéal** | Données présentes, tout va bien | Le contenu |
| **Chargement** | Premier affichage, rafraîchissement | Squelette (skeleton) ou indicateur. Jamais un écran blanc |
| **Vide** | Aucune donnée (premier usage, aucun résultat) | Explication + action pour en sortir |
| **Erreur** | Réseau, serveur, permission | Ce qui s'est passé + bouton « Réessayer » |
| **Partiel** | Une seule donnée, ou des données incomplètes | La mise en page doit tenir |
| **Hors ligne** | Pas de connexion | Données en cache + bandeau discret |
| **Extrêmes** | Texte très long, 1 000 éléments, prix énorme | Pas de débordement, troncature avec `…` |

### Trois sortes d'état vide

1. **Premier usage** : « Aucun produit pour l'instant. Ajoutez votre premier
   produit pour suivre votre stock. » + [AJOUTER UN PRODUIT]. Ici, le vide est
   une occasion d'expliquer.
2. **Aucun résultat** : « Aucun produit ne correspond à "rizz". » + [Effacer
   la recherche]. Proposer une correction si possible.
3. **Tout est fait** : « Aucun produit en rupture 🎉 ». Ici, le vide est une
   bonne nouvelle.

### Chargement : squelette plutôt que spinner

Pour une liste, un **squelette** (des blocs gris à la forme du contenu) donne
l'impression d'aller plus vite qu'un spinner centré, et évite que la mise en
page « saute » quand les données arrivent. Le spinner reste adapté aux actions
courtes et ponctuelles (soumettre un formulaire).

## 7. Annoter un wireframe

Un wireframe sans annotation laisse trop de choses à deviner. Annote :

- le **comportement** : « toucher la carte → détail produit » ;
- les **règles** : « bouton désactivé si quantité = 0 » ;
- les **données** : « trié par date, le plus récent en haut, 20 par page » ;
- les **cas limites** : « nom tronqué sur 2 lignes ».

```
┌──────────────────────────────┐
│ ← Panier (3)                 │ ①
├──────────────────────────────┤
│ ┌╳┐ Riz 5 kg      [– 2 +]    │ ②
│ └─┘ 12 500 Ar       🗑       │ ③
│ ...                          │
├──────────────────────────────┤
│ Total            37 500 Ar   │ ④
│ [▓▓▓▓▓ COMMANDER ▓▓▓▓▓▓▓▓▓▓] │ ⑤
└──────────────────────────────┘
① Le nombre d'articles se met à jour en direct.
② Le stepper ne descend pas sous 1 ; pour retirer, utiliser ③.
③ Suppression immédiate + SnackBar « Retiré · ANNULER » (pas de confirmation).
④ Total recalculé à chaque changement. Format : espace entre milliers.
⑤ Fixé en bas, toujours visible. Désactivé si le panier est vide (mais l'état vide
   remplace normalement tout l'écran).
```

## 8. Erreurs fréquentes

- Passer directement à Figma en haute fidélité.
- Dessiner un seul état par écran.
- Utiliser du faux texte (« Lorem ipsum ») : il cache les vrais problèmes de
  longueur. Utilise des contenus réalistes : « Huile d'arachide raffinée 5 L ».
- Mettre plusieurs actions principales sur un écran.
- Oublier le clavier : il couvre la moitié de l'écran quand un champ est actif.
- Mettre des actions importantes en haut, hors de portée du pouce.

## 9. Questions de révision

1. Pourquoi commencer par un wireframe basse fidélité plutôt que par une maquette ?
2. Cite les 5 zones d'un écran mobile type.
3. Quels sont les états qu'un écran de liste doit prévoir ?
4. Quelle est la différence entre les trois sortes d'état vide ?
5. Pourquoi un squelette plutôt qu'un spinner pour charger une liste ?
6. Pourquoi éviter le « Lorem ipsum » ?

## Pour aller plus loin

- NN/g, *Wireframes* : https://www.nngroup.com/articles/wireframe/
- Material 3, *Layout* : https://m3.material.io/foundations/layout/understanding-layout/overview
- Steven Hoober, *How Do Users Really Hold Mobile Devices?* (UXmatters, 2013)
