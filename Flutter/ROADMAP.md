# Parcours — 20 semaines : Flutter + design d'interfaces mobiles

Les cours détaillés sont rédigés au fur et à mesure dans `LESSONS/`.
Objectif : savoir concevoir une interface mobile, justifier ses choix de design
et la reproduire fidèlement en Flutter, avec un code propre et une architecture claire.

## Phase 1 — Dart et Flutter

| Sem. | Thème | Pratique |
|------|-------|----------|
| 1 | Environnement, syntaxe, variables, types, opérateurs, conversions, chaînes. Premier aperçu d'une app Flutter | Calculatrice, convertisseur, prix total, première page |
| 2 | Conditions, boucles, listes/sets/maps, fonctions, paramètres nommés et optionnels | Gestionnaire de dépenses (terminal) |
| 3 | POO : classes, constructeurs, encapsulation, héritage, interfaces, enums, null safety | Modèle produits / commandes |
| 4 | Exceptions, imports, `pub`, `Future`/`async`/`await`, streams, génériques, `package:test` | Traitement de données asynchrones |
| 5 | Environnement Flutter (canal stable, émulateur Android), widgets, Stateless/Stateful, `BuildContext`, `Scaffold`, Material 3 | Premières pages |
| 6 | `Row`, `Column`, `Stack`, `Expanded`, `Flexible`, contraintes de layout, listes, images, icônes, thèmes | Reproduire une petite app à partir d'une maquette |

## Phase 2 — Fondamentaux du design mobile

| Sem. | Thème | Pratique |
|------|-------|----------|
| 7 | UI vs UX, besoins, personas, scénarios, architecture de l'information, parcours, hiérarchie visuelle, affordances, feedback, erreurs | Analyse ergonomique d'une app existante |
| 8 | Wireframes basse fidélité, grilles, alignements, navigation, structure d'écran, wireframe/prototype/maquette, états vides et d'erreur | Wireframes e-commerce : accueil, catalogue, détail, panier |
| 9 | Couleurs (harmonies, sémantique, contraste), échelles typographiques, interlignage, espacements, rayons, ombres, élévation, tokens | Palette + typographie + espacements |
| 10 | Design system, tokens, boutons, champs, cartes, listes, navigation, états (pressé, désactivé, chargement, erreur), Material 3 et Cupertino | Bibliothèque de composants + thème Flutter |

## Phase 3 — Maquettes et reproduction fidèle

| Sem. | Thème | Pratique |
|------|-------|----------|
| 11 | Du wireframe à la maquette haute fidélité, grille, variantes, ressources, Figma, spécifications | Maquette de 5 écrans |
| 12 | Maquette → arbre de widgets, marges, tailles, polices, icônes, composants, comparaison de captures | Reproduction des 5 écrans |
| 13 | `MediaQuery`, `LayoutBuilder`, densité, `SafeArea`, clavier, débordement, orientation, tablettes, texte agrandi, Android vs iOS | App multi-tailles |
| 14 | Feedback tactile, transitions, animations implicites puis explicites, durées et courbes, chargement, réduction des animations | Animations sobres sur l'app e-commerce |

## Phase 4 — UX avancée et fonctionnalités mobiles

| Sem. | Thème | Pratique |
|------|-------|----------|
| 15 | Formulaires accessibles, validation, messages d'erreur, claviers, soumission, confirmations, doubles soumissions | Parcours d'inscription complet |
| 16 | `go_router`, onglets, état local/partagé, `setState` puis Riverpod, états de chargement/vide/erreur, organisation par fonctionnalités | App multi-écrans |
| 17 | API REST, JSON → modèles, listes dynamiques, erreurs réseau, pagination, cache, authentification | App e-commerce connectée à Django/FastAPI |
| 18 | Contrastes, sémantique, labels, zones tactiles, texte agrandi, hors connexion, test sur appareil réel, tests utilisateurs | Audit UX et accessibilité |

## Phase 5 — Applications professionnelles

| Sem. | Thème | Pratique |
|------|-------|----------|
| 19 | Architecture par fonctionnalités, repositories, services, injection de dépendances, tests unitaires/widgets/intégration, `flutter analyze`, performances, cycle de vie | Refactorisation sans régression |
| 20 | **Projet final** | App de gestion de stock ou de commerce |

## Méthode pour chaque projet

1. Utilisateur cible → 2. Tâches principales → 3. Écrans → 4. Parcours →
5. Wireframes → 6. Couleurs, typographie, espacements → 7. Composants →
8. États de chaque écran → 9. Implémentation Flutter → 10. Captures →
11. Correction des écarts → 12. Tests (erreurs, accessibilité, tailles) →
13. Documentation des choix.

## Projet final (semaine 20)

Identité visuelle, design system, wireframes et maquettes, au moins 5 écrans,
navigation claire, composants réutilisables, formulaires validés, états
chargement/succès/erreur/vide, API, gestion d'état structurée, tests,
interface responsive, documentation et build Android de démonstration.
