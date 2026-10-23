# D02 — Architecture de l'information et parcours utilisateur

Durée : 2 h 30. Prérequis : D01. Exercices : [`EXERCISES/D02.md`](../EXERCISES/D02.md)

## 1. Objectifs pédagogiques

- Organiser le contenu et les fonctionnalités d'une application de façon compréhensible.
- Construire une arborescence et la tester.
- Dessiner un parcours utilisateur (user flow).
- Choisir le bon modèle de navigation mobile et le justifier.

## 2. L'architecture de l'information (AI)

L'AI répond à trois questions de l'utilisateur :

1. **Où suis-je ?**
2. **Qu'y a-t-il ici ?**
3. **Où puis-je aller ?**

Une bonne AI organise les éléments selon **le modèle mental de l'utilisateur**,
pas selon la base de données ni l'organigramme de l'entreprise.

Exemple. Le développeur pense « tables » : `Produits`, `Mouvements`,
`Fournisseurs`. L'utilisatrice Hanta pense « tâches » : « Vendre »,
« Recevoir une livraison », « Voir ce qui manque ». La seconde organisation est
plus utile pour elle.

### 2.1 Les systèmes de l'AI

| Système | Rôle | Exemple mobile |
|---|---|---|
| **Organisation** | Comment on regroupe | Par catégorie, par date, par tâche, alphabétique |
| **Étiquetage** | Comment on nomme | « Panier » plutôt que « Sélection temporaire » |
| **Navigation** | Comment on se déplace | Barre d'onglets, retour, liens |
| **Recherche** | Comment on trouve sans naviguer | Barre de recherche, filtres |

### 2.2 Le tri de cartes (card sorting)

Méthode pour découvrir comment les utilisateurs regroupent naturellement les choses :

1. Écris chaque fonctionnalité ou contenu sur une carte (20 à 40 cartes).
2. Demande à 5 personnes de les regrouper et de **nommer** chaque groupe.
3. **Tri ouvert** : la personne invente les groupes. **Tri fermé** : les groupes sont imposés.
4. Compare les résultats : les regroupements qui reviennent souvent deviennent tes sections.

### 2.3 L'arborescence

```
Tsena (app)
├── Accueil
│   ├── Promotions
│   └── Catégories populaires
├── Catalogue
│   ├── Liste par catégorie
│   │   └── Détail produit
│   └── Recherche
├── Panier
│   └── Commande
│       ├── Adresse
│       ├── Paiement
│       └── Confirmation
└── Compte
    ├── Mes commandes
    │   └── Détail commande
    └── Paramètres
```

Règles pratiques sur mobile :

- **3 à 5 sections principales** au maximum.
- **Profondeur limitée** : idéalement 3 niveaux, au-delà l'utilisateur se perd.
- Équilibre largeur / profondeur : 10 entrées au même niveau, c'est trop large ;
  6 niveaux d'imbrication, c'est trop profond.

**Test d'arborescence (tree testing)** : donne l'arbre *sans design* et une
tâche (« Où trouverais-tu tes anciennes commandes ? »). Si la personne hésite ou
se trompe de branche, l'étiquetage ou le regroupement est à revoir.

## 3. Le parcours utilisateur (user flow)

Un **user flow** représente les étapes pour accomplir **une tâche**, avec les
décisions et les cas d'erreur.

Symboles :

```
( Début / Fin )     [ Écran ]     < Décision ? >     { Action système }
```

Exemple, « Commander un produit » :

```
( Ouvre l'app )
      │
[ Accueil ] ──recherche──► [ Résultats ] ─┐
      │                                    │
      └──catégorie──► [ Liste ] ◄──────────┘
                          │
                     [ Détail produit ]
                          │
                  < En stock ? > ──non──► [ Bouton « M'alerter » ] ──► ( Fin )
                          │ oui
                  { Ajout au panier } ──► SnackBar « Ajouté · VOIR LE PANIER »
                          │
                     [ Panier ]
                          │
                  < Connecté ? > ──non──► [ Connexion ] ──┐
                          │ oui                            │
                     [ Adresse ] ◄─────────────────────────┘
                          │
                     [ Paiement ]
                          │
                  < Paiement OK ? > ──non──► [ Erreur + réessayer ] ──┐
                          │ oui                                         │
                     [ Confirmation ] ◄────────────────────────────────┘
                          │
                     ( Fin )
```

Ce que le flow révèle **avant de dessiner un seul écran** :

- il faut un écran ou un état « rupture de stock » ;
- la connexion doit renvoyer au panier, pas à l'accueil ;
- il faut un écran d'erreur de paiement **qui conserve le panier**.

**Customer journey map** (plus large) : le parcours complet avec les émotions,
y compris hors de l'application (découverte, livraison, SAV). Utile pour
repérer les moments de frustration à corriger.

## 4. Les modèles de navigation mobile

| Modèle | Quand l'utiliser | Composant Flutter |
|---|---|---|
| **Barre de navigation inférieure** (3 à 5 destinations) | Sections principales de même importance, fréquemment alternées | `NavigationBar` |
| **Onglets** (en haut) | Sous-vues d'une même section (« En cours / Livrées ») | `TabBar` + `TabBarView` |
| **Tiroir** (drawer) | Beaucoup de destinations peu fréquentes, ou écran large | `NavigationDrawer` |
| **Pile** (push / retour) | Aller du général au détail | `Navigator`, `go_router` |
| **Feuille modale** (bottom sheet) | Tâche courte sans quitter le contexte (filtres, choix) | `showModalBottomSheet` |
| **Dialogue** | Décision bloquante et courte | `showDialog` + `AlertDialog` |
| **Rail de navigation** | Tablette et écran large | `NavigationRail` |

### Pourquoi la barre inférieure plutôt que le tiroir ?

Le tiroir **cache** les destinations : ce qu'on ne voit pas, on l'utilise moins
(c'est l'heuristique « reconnaître plutôt que se rappeler »). Il demande aussi
deux gestes au lieu d'un, et le bouton ☰ est en haut à gauche, loin du pouce
(loi de Fitts). La barre inférieure montre toutes les sections en permanence, à
portée du pouce. On garde le tiroir quand il y a plus de 5 sections peu utilisées.

### Règles de la barre de navigation inférieure (Material 3)

- 3 à 5 destinations, jamais 2 (dans ce cas, utiliser des onglets) ni 6 et plus.
- Icône **et** libellé court (1 mot si possible).
- La destination active est mise en évidence (indicateur M3).
- Toucher l'onglet actif ramène en haut de la liste ou à la racine de la section.
- Chaque section **conserve son état** quand on change d'onglet (position de
  scroll, filtres). On verra comment avec `go_router` en semaine 16.

### Android et iOS

| | Android (Material) | iOS (HIG) |
|---|---|---|
| Retour | Geste ou bouton système **+** flèche dans l'AppBar | Bouton « ‹ Titre » en haut à gauche, glissement depuis le bord gauche |
| Navigation principale | `NavigationBar` | Tab bar (même concept, apparence différente) |
| Titre | Souvent à gauche | Centré, ou grand titre qui se réduit au scroll |
| Action principale | Bouton flottant (FAB) possible | Plutôt dans la barre du haut ou dans le contenu |

## 5. Erreurs fréquentes

- Une arborescence qui copie la structure de la base de données.
- Des libellés créatifs mais ambigus (« Mon univers », « Découvrir »).
- Des destinations de barre inférieure qui sont des **actions** (« Ajouter ») et non des **lieux**.
- Oublier les branches d'erreur dans les user flows.
- Mélanger barre inférieure **et** tiroir pour les mêmes destinations.

## 6. Questions de révision

1. Quelles sont les trois questions auxquelles répond une bonne architecture de l'information ?
2. Quelle est la différence entre tri de cartes ouvert et tri fermé ?
3. Pourquoi limiter la profondeur d'une arborescence mobile ?
4. Qu'apporte un user flow par rapport à une liste d'écrans ?
5. Barre inférieure ou tiroir pour 4 sections fréquentes ? Justifie avec deux principes de D01.
6. Pourquoi « Ajouter » ne doit-il pas être une destination de la barre inférieure ?

## Pour aller plus loin

- Material 3, navigation : https://m3.material.io/components/navigation-bar/overview
- Apple HIG, *Tab bars* : https://developer.apple.com/design/human-interface-guidelines/tab-bars
- NN/g, *Tree testing* : https://www.nngroup.com/articles/tree-testing/
