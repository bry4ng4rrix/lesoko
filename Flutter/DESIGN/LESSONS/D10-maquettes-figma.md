# D10 — Maquettes haute fidélité avec Figma (ou Penpot)

Durée : 3 h (dont 2 h de pratique dans l'outil). Prérequis : D03 à D09.
Exercices : [`EXERCISES/D10.md`](../EXERCISES/D10.md)

## 1. Objectifs pédagogiques

- Transformer un wireframe validé en maquette haute fidélité.
- Maîtriser les notions de Figma : frames, auto layout, contraintes, composants, variantes, styles et variables.
- Organiser un fichier de design proprement.
- Préparer des spécifications exploitables par le développeur, c'est-à-dire toi.

## 2. Choisir l'outil

| | Figma | Penpot |
|---|---|---|
| Accès sous Linux | Navigateur (pas d'app officielle) | Navigateur, ou auto-hébergé |
| Prix | Gratuit (offre de base, limitée en fichiers) | Gratuit, open source |
| Écosystème | Énorme (plugins, kits, tutoriels) | Plus petit, mais croissant |
| Material 3 | Kit officiel « Material 3 Design Kit » (Figma Community) | Kits communautaires |
| Concepts | Frames, auto layout, composants, variantes, variables | Les mêmes (« flex layout », composants, tokens) |

Les **concepts** de ce module sont les mêmes dans les deux outils. Les
exemples utilisent le vocabulaire Figma.

## 3. Les notions de Figma

### 3.1 Frame

Un **frame** est un conteneur : un écran, une carte, un bouton. Pour un écran
mobile, crée un frame de **360 × 800** (Android courant) ou **393 × 852**
(iPhone 15/16). Les unités de Figma correspondent aux **pixels logiques** de
Flutter (dp/pt) : 16 dans Figma = 16 dans Flutter.

### 3.2 Auto layout : l'équivalent de `Row` / `Column`

L'**auto layout** est **la** notion qui rend une maquette « codable ».

| Figma (auto layout) | Flutter |
|---|---|
| Direction verticale | `Column` |
| Direction horizontale | `Row` |
| Gap (espace entre éléments) | `spacing:` ou `SizedBox` |
| Padding | `Padding` |
| Alignement | `mainAxisAlignment` / `crossAxisAlignment` |
| *Hug contents* (taille du contenu) | `mainAxisSize: MainAxisSize.min` / taille naturelle |
| *Fill container* (prend la place) | `Expanded` / `double.infinity` |
| *Fixed* (taille fixe) | `SizedBox(width: …)` |
| Wrap | `Wrap` |

Si ta maquette est entièrement en auto layout, sa traduction en Flutter est
presque mécanique. Si elle est faite d'éléments posés « à la main », chaque
écran devient un puzzle, et il cassera sur un écran d'une autre taille.

### 3.3 Contraintes

Pour les éléments **hors** auto layout, les contraintes indiquent comment ils
réagissent quand le frame est redimensionné (fixé à gauche, centré, étiré…).
Équivalent Flutter : `Align`, `Positioned` dans un `Stack`.

### 3.4 Composants et instances

Un **composant** est un élément maître (un bouton). Ses **instances** sont des
copies liées : modifier le maître modifie toutes les instances. C'est le
pendant exact d'une classe de widget Flutter et de ses utilisations.

### 3.5 Variantes et propriétés

Les **variantes** regroupent les versions d'un composant dans un « component set » :

```
Bouton
├── Type = Principal | Tonal | Destructif
├── État = Normal | Pressé | Désactivé | Chargement
└── Icône = Oui | Non
```

Les **propriétés de composant** (texte, booléen, instance) correspondent aux
**paramètres du constructeur** Flutter : `libelle`, `icone`, `variante`, `enChargement`.
Conçois tes variantes Figma en pensant aux paramètres du widget, et inversement.

### 3.6 Styles et variables : les tokens dans Figma

- **Styles** : couleurs, textes, effets (ombres) réutilisables.
- **Variables** : tokens avec des **modes**, par exemple les modes « Clair » et
  « Sombre » pour une même variable `color/surface`. C'est l'équivalent de
  `ThemeData` clair et sombre.

Organise les variables comme en D08 : une collection **Primitifs**
(`teal/600`), une collection **Sémantique** (`color/primary` → `teal/600`).

## 4. Organiser un fichier

```
📄 Tsena — Design
├── 📑 Couverture        (nom, version, statut, date)
├── 📑 Fondations        (couleurs, typo, espacements, rayons, élévation)
├── 📑 Composants        (boutons, champs, cartes… avec toutes les variantes)
├── 📑 Wireframes        (basse fidélité, archivés)
├── 📑 Écrans            (maquettes HF, par parcours)
│     ├── 01 Accueil  — idéal / chargement / erreur
│     ├── 02 Catalogue — idéal / vide / recherche sans résultat
│     └── …
└── 📑 Prototype         (liens entre écrans)
```

Conventions de nommage : `Composant/Variante`, par exemple `Bouton/Principal`
ou `Carte/Produit`. Nommer les calques : « Frame 284 » ne dit rien à personne.

## 5. Du wireframe à la maquette : la méthode

1. **Reprends le wireframe validé**. Ne change pas la structure maintenant : si
   un problème de structure apparaît, retourne au wireframe.
2. **Pose la grille** : marges de 16, grille de 4 colonnes, grille de base de 8.
3. **Applique la typographie** avec les styles de texte, uniquement ceux de l'échelle.
4. **Remplace les boîtes** par des instances de composants.
5. **Applique les couleurs** en 60-30-10, avec les variables uniquement.
6. **Insère du contenu réel** : vrais noms de produits, prix réalistes, textes
   longs. Les images doivent être de la bonne proportion.
7. **Duplique l'écran pour chaque état** : chargement, vide, erreur, texte long.
8. **Vérifie** : contraste, zones tactiles de 48 dp, test du plissement des yeux.
9. **Version sombre** : change le mode des variables. Rien ne doit casser.

## 6. Images et ressources graphiques

| Ressource | Format | Flutter |
|---|---|---|
| Icônes | Material Symbols (inclus) ; sinon SVG | `Icon(Icons.…)` ; `flutter_svg` pour SVG |
| Illustrations (états vides) | SVG de préférence | `flutter_svg` |
| Photos | WebP/JPEG, **1x, 2x, 3x** | `Image.asset` avec dossiers `2.0x/`, `3.0x/` |
| Logo | SVG + PNG | |

Exporter les images à plusieurs densités évite des photos floues sur les
écrans haute densité. Flutter choisit automatiquement la bonne version.

## 7. Préparer les spécifications

Une maquette n'est pas une spécification. Le développeur doit savoir :

| À spécifier | Exemple |
|---|---|
| Tokens utilisés (pas des valeurs brutes) | « Fond : `surfaceContainerLow` ; titre : `titleMedium` » |
| Espacements | « Padding carte : `space.m` ; écart titre/sous-titre : `space.xs` » |
| Comportement responsive | « Grille : 2 colonnes < 600 dp, 3 au-delà » |
| Troncature | « Nom : 2 lignes max, ellipse » |
| États | Lien vers chaque frame d'état |
| Interactions | « Toucher → Détail ; appui long → menu contextuel » |
| Animations | « Ajout panier : badge qui pulse, 200 ms, `emphasized` » |
| Accessibilité | « Libellé lecteur d'écran du ♡ : "Ajouter aux favoris" » |

En **Figma Dev Mode**, le développeur inspecte directement les mesures, les
variables et les exports. La documentation des comportements reste **ta**
responsabilité : utilise le modèle [`RESSOURCES/modele-fiche-ecran.md`](../RESSOURCES/modele-fiche-ecran.md).

## 8. Le prototype

Relie les écrans par des interactions (« au toucher → aller à Détail »), avec
des transitions simples. Un prototype sert à :

- **tester** un parcours avec une vraie personne **avant** d'écrire du code (D15) ;
- **montrer** le fonctionnement à un client.

Ne prototype que les parcours **critiques** (commander, s'inscrire), pas tous les écrans.

## 9. Erreurs fréquentes

- Une maquette sans auto layout, impossible à traduire proprement.
- Des couleurs et tailles saisies à la main au lieu des styles et variables.
- Des composants détachés (« detach instance ») pour une petite retouche.
- Un seul état dessiné par écran.
- Des valeurs hors grille (13, 22, 37).
- Faire de la maquette une œuvre d'art : l'objectif est une **app livrée**, pas
  un « shot » pour un portfolio.

## 10. Questions de révision

1. Quel est l'équivalent Flutter de l'auto layout ? De *Fill container* ? De *Hug contents* ?
2. À quoi correspondent les propriétés d'un composant Figma dans un widget Flutter ?
3. Différence entre style et variable dans Figma ? Pourquoi les modes ?
4. Que contient une spécification que la maquette ne montre pas ?
5. Pourquoi exporter les images en 1x, 2x et 3x ?
6. Si tu découvres un problème de structure en maquette HF, que fais-tu ?

## Pour aller plus loin

- Figma Learn : https://help.figma.com/ (recherche « auto layout », « variables », « variants », « Dev Mode »)
- Penpot, documentation : https://help.penpot.app/
- Material 3 Design Kit : dans Figma Community (https://www.figma.com/community), recherche « Material 3 Design Kit » publié par Google
