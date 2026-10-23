# Parcours Design mobile (UI/UX → Flutter)

Ce dossier regroupe **tout ce qui concerne le design** : cours, exercices,
modèles, projet fil rouge et tes travaux. Les bases Dart et Flutter restent à la
racine (`LESSONS/`, `EXERCISES/`, `PROJECTS/`).

Objectif : savoir **concevoir** une interface mobile, **justifier** chaque
décision et la **reproduire fidèlement** en Flutter.

## Organisation

| Dossier / fichier | Contenu |
|---|---|
| `LESSONS/` | Les 15 modules de cours (D01 → D15) |
| `EXERCISES/` | Les exercices de chaque module : design, programmation, défi, critères |
| `RESSOURCES/` | Modèles réutilisables : fiche d'écran, grille d'audit, checklist, gabarit de tokens |
| `PROJETS/` | Le brief du projet fil rouge **Tsena** (application de commerce) |
| `TRAVAUX/` | **Tes** productions : wireframes, palettes, specs, audits, captures |
| `NOTES.md` | Aide-mémoire : les valeurs et règles à connaître par cœur |

## Les 15 modules

| Module | Thème | Flutter nécessaire ? | Semaine de la roadmap |
|---|---|---|---|
| [D01](LESSONS/D01-principes-ui-ux.md) | UI vs UX, besoins, personas, heuristiques, lois de l'ergonomie | non | 7 |
| [D02](LESSONS/D02-architecture-information-parcours.md) | Architecture de l'information, parcours, navigation mobile | non | 7 |
| [D03](LESSONS/D03-wireframes.md) | Wireframes, structure d'écran, zones du pouce, états | non | 8 |
| [D04](LESSONS/D04-hierarchie-mise-en-page.md) | Hiérarchie visuelle, Gestalt, grilles, alignements | aperçu | 8 |
| [D05](LESSONS/D05-couleur.md) | Couleur, harmonies, rôles Material 3, contraste, mode sombre | oui | 9 |
| [D06](LESSONS/D06-typographie.md) | Typographie, échelles, lisibilité, polices | oui | 9 |
| [D07](LESSONS/D07-espacements-formes-elevation.md) | Espacements, rayons, bordures, ombres, élévation | oui | 9 |
| [D08](LESSONS/D08-design-tokens-design-system.md) | Design tokens et design system dans Flutter | oui | 10 |
| [D09](LESSONS/D09-composants-etats.md) | Composants, variantes et états, Material 3 et Cupertino | oui | 10 |
| [D10](LESSONS/D10-maquettes-figma.md) | Maquettes haute fidélité, Figma/Penpot, spécifications | non | 11 |
| [D11](LESSONS/D11-maquette-vers-flutter.md) | Reproduire une maquette avec précision | oui | 12 |
| [D12](LESSONS/D12-responsive-adaptatif.md) | Responsive, adaptatif, SafeArea, clavier, texte agrandi | oui | 13 |
| [D13](LESSONS/D13-animations-micro-interactions.md) | Animations et micro-interactions | oui | 14 |
| [D14](LESSONS/D14-formulaires-flux.md) | Formulaires et flux utilisateur | oui | 15 |
| [D15](LESSONS/D15-accessibilite-audit-ux.md) | Accessibilité, audit UX, tests utilisateurs | oui | 18 |

## Comment suivre ce parcours

**Quand ?** Les modules D01 à D04 ne demandent pas de Flutter. Tu peux les
commencer **dès maintenant**, en parallèle de Dart, par exemple pendant **une
séance par semaine**. Les modules suivants contiennent du code Flutter : fais
leur partie programmation après la semaine 6, mais la théorie et l'exercice de
design peuvent se faire avant.

**Comment ?** Pour chaque module :

1. Lis le cours en entier, une première fois sans prendre de notes.
2. Relis-le en observant de vraies applications sur ton téléphone. Chaque
   notion se voit dans les apps que tu utilises tous les jours.
3. Fais l'**exercice de design** (papier, Markdown ou Figma/Penpot).
4. Fais l'**exercice de programmation** si tu as le niveau Flutter requis.
5. Tente le **défi** sans aide pendant au moins 30 minutes.
6. Range tes productions dans `TRAVAUX/Dxx/` et envoie-les-moi pour correction.
7. Réponds aux questions de révision **sans relire le cours**.

**L'habitude qui fait progresser le plus vite :** tiens un carnet
d'observations (`TRAVAUX/carnet.md`). Chaque jour, note **une** chose bien
conçue et **une** chose mal conçue dans une application que tu as utilisée,
avec la raison. Au bout de quelques semaines, tu repéreras les problèmes avant
même de savoir les nommer.

## La méthode pour chaque écran ou projet

1. Utilisateur cible → 2. Tâches principales → 3. Écrans nécessaires →
4. Parcours → 5. Wireframes → 6. Couleurs, typographie, espacements →
7. Composants réutilisables → 8. États de chaque écran → 9. Implémentation Flutter →
10. Captures d'écran → 11. Correction des écarts → 12. Tests (erreurs,
accessibilité, tailles d'écran) → 13. Documentation des choix.

Le modèle [`RESSOURCES/modele-fiche-ecran.md`](RESSOURCES/modele-fiche-ecran.md)
suit exactement ces étapes.

## Outils

| Outil | Usage | Remarque |
|---|---|---|
| Papier + crayon | Wireframes rapides | Le plus rapide pour explorer. Ne le néglige pas |
| Markdown (wireframes textuels) | Wireframes versionnables | Ce qu'on utilise dans les premiers modules |
| [Figma](https://help.figma.com/) | Maquettes, composants, prototypes | Fonctionne dans le navigateur (Firefox convient). Pas d'application Linux officielle |
| [Penpot](https://penpot.app/) | Alternative libre à Figma | Open source, fonctionne dans le navigateur, auto-hébergeable |
| Flutter DevTools | Inspecter le layout, mesurer | Inclus dans Flutter |
| [Material Design 3](https://m3.material.io/) | Règles et composants Android | Référence principale |
| [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/) | Conventions iOS | Pour les différences de plateforme |

Je n'ai pas accès à ton compte Figma : pour me montrer une maquette, exporte-la
en PNG dans `TRAVAUX/` ou décris-la.
