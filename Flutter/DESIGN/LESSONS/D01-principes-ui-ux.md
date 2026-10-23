# D01 — Principes UI/UX

Durée : 2 h 30 à 3 h. Prérequis : aucun. Exercices : [`EXERCISES/D01.md`](../EXERCISES/D01.md)

## 1. Objectifs pédagogiques

- Distinguer UI et UX, et expliquer pourquoi une belle interface peut être une mauvaise expérience.
- Identifier les besoins réels d'un utilisateur, rédiger un persona et un scénario.
- Connaître les 10 heuristiques de Nielsen et les appliquer à une vraie application.
- Comprendre affordance, feedback, cohérence, prévention et récupération des erreurs.
- Connaître les « lois » de l'ergonomie utiles sur mobile.
- Limiter la charge cognitive.

## 2. UI et UX

**UX (User eXperience)** : l'expérience globale. L'utilisateur atteint-il son
but ? Facilement ? Sans erreur ? Sans frustration ? L'UX commence **avant**
l'écran (le besoin) et continue **après** (la livraison, le support).

**UI (User Interface)** : la partie visible et touchable : écrans, boutons,
couleurs, typographie, icônes, animations.

| | UX | UI |
|---|---|---|
| Question | « Est-ce utile et utilisable ? » | « Est-ce clair, cohérent, agréable ? » |
| Livrables | Recherche, personas, parcours, wireframes | Maquettes, design system, composants |
| Mesure | Taux de réussite, temps, erreurs, satisfaction | Lisibilité, cohérence, contraste |

Exemple concret : une application de paiement mobile **magnifique** qui demande
le code PIN à chaque écran a une bonne UI et une mauvaise UX. À l'inverse, une
application moche mais qui permet d'envoyer de l'argent en 3 touches sans erreur
a une bonne UX… jusqu'à ce que l'utilisateur doute de sa fiabilité, parce
qu'elle « a l'air amateur ». **L'UI fait partie de l'UX** : l'apparence crée la
confiance.

## 3. Comprendre les besoins

### 3.1 Le besoin n'est pas la demande

Un commerçant demande : « Je veux un bouton pour exporter le stock en Excel. »
Son vrai besoin : « Savoir chaque lundi quels produits recommander. »
Une liste « À recommander » directement dans l'application répond mieux au
besoin que l'export demandé.

Technique des **5 pourquoi** : demande « pourquoi ? » jusqu'à atteindre le but réel.

### 3.2 Méthodes de recherche utilisateur (légères)

| Méthode | Quand | Effort |
|---|---|---|
| Entretien (5 personnes suffisent pour voir les tendances) | Comprendre les besoins, le contexte | Moyen |
| Observation (regarder quelqu'un utiliser une app ou faire la tâche sans app) | Découvrir ce que les gens ne disent pas | Moyen |
| Questionnaire | Mesurer sur beaucoup de personnes | Faible |
| Analyse de la concurrence | Voir les conventions existantes | Faible |
| Test utilisateur (D15) | Vérifier une conception | Moyen |

Règle d'or de l'entretien : demande ce que la personne **a fait** (« Racontez-moi
la dernière fois que… »), pas ce qu'elle **ferait** (« Est-ce que vous
utiliseriez… ? »). Les gens prédisent mal leur propre comportement.

### 3.3 Persona

Un **persona** est un utilisateur type, construit à partir de la recherche. Il
sert à trancher les débats : « Est-ce que Hanta utiliserait ça ? »

```
┌─────────────────────────────────────────────────────────────┐
│ HANTA, 34 ans — gérante d'une épicerie à Antsirabe            │
├─────────────────────────────────────────────────────────────┤
│ Contexte  : seule en boutique, interrompue sans arrêt,        │
│             Android d'entrée de gamme, 3G instable            │
│ Objectifs : savoir ce qui manque avant la tournée du          │
│             grossiste le mardi ; ne pas perdre de ventes      │
│ Frustrations : cahier illisible, oublie de noter les sorties  │
│ Compétences : WhatsApp, Mobile Money ; jamais d'Excel         │
│ Citation : « Je n'ai pas le temps de remplir des formulaires. »│
└─────────────────────────────────────────────────────────────┘
```

Ce qui compte dans un persona : le **contexte**, les **objectifs** et les
**frustrations**. L'âge et la photo sont secondaires. Ce persona te dit déjà
beaucoup sur l'interface : des actions rapides à une main, un fonctionnement
hors ligne, peu de saisie, de grands boutons, peu de jargon.

Erreur fréquente : un persona inventé sans recherche, qui ressemble au
développeur lui-même.

### 3.4 Scénario et user story

**Scénario** : une petite histoire qui place le persona dans une situation.

> Mardi, 7 h 50. Le grossiste arrive à 8 h. Hanta ouvre l'application d'une main,
> l'autre tient la porte. Elle veut voir en 10 secondes les produits sous le
> seuil minimum, pour dicter la commande.

**User story** : le format court utilisé pendant le développement.

> En tant que **gérante**, je veux **voir les produits en rupture proche**
> afin de **préparer la commande du grossiste rapidement**.

## 4. Les 10 heuristiques de Nielsen

Ce sont des règles générales d'utilisabilité, publiées par Jakob Nielsen en 1994
et toujours valables. Apprends-les par cœur : elles servent de grille pour tout audit.

| # | Heuristique | Exemple mobile respecté | Violation typique |
|---|---|---|---|
| 1 | **Visibilité de l'état du système** | Indicateur de chargement, « Envoyé ✓ » | Bouton qui ne réagit pas pendant 3 s |
| 2 | **Correspondance avec le monde réel** | « Panier », « Payer » ; icône de corbeille | « Erreur 500 », « Entité créée » |
| 3 | **Contrôle et liberté** | « Annuler » dans la SnackBar après suppression | Impossible de revenir en arrière |
| 4 | **Cohérence et standards** | Bouton retour en haut à gauche ; même vert partout pour « valider » | « Valider » à droite ici, à gauche là |
| 5 | **Prévention des erreurs** | Bouton désactivé tant que le formulaire est invalide ; clavier numérique pour un prix | Champ libre pour une date |
| 6 | **Reconnaître plutôt que se rappeler** | Recherches récentes, suggestions | Devoir retaper le code produit |
| 7 | **Flexibilité et efficacité** | Glisser pour supprimer (raccourci) + menu (méthode visible) | Raccourci comme seule méthode |
| 8 | **Esthétique et minimalisme** | Une action principale par écran | 6 boutons de même poids |
| 9 | **Aider à reconnaître, diagnostiquer, corriger les erreurs** | « Mot de passe : 8 caractères minimum » sous le champ | « Saisie invalide » |
| 10 | **Aide et documentation** | Astuce contextuelle à la première utilisation | Tutoriel de 8 écrans au lancement |

## 5. Affordance, feedback, cohérence

**Affordance** : ce qu'un objet *suggère* qu'on peut faire avec lui. Une poignée
suggère de tirer. Sur écran, on parle surtout de **signifiants** : le relief et
la couleur d'un bouton, le soulignement d'un lien, la poignée d'une feuille
glissante, le chevron `›` en bout de ligne qui annonce « on peut ouvrir ».

Problème courant : le **flat design** extrême, où tout est plat et sans
signifiant, et où l'utilisateur ne sait plus ce qui est cliquable.

**Feedback** : chaque action reçoit une réponse **immédiate** et **proportionnée**.

| Action | Feedback attendu |
|---|---|
| Toucher un bouton | Effet visuel instantané (ripple Material) |
| Action rapide réussie | Changement d'état visible (case cochée) |
| Action longue | Indicateur de progression |
| Action importante réussie | Message de confirmation (SnackBar) |
| Échec | Message clair + moyen de corriger |

**Cohérence** :
- **interne** : la même chose a le même aspect et le même comportement dans toute l'app ;
- **externe** : l'app respecte les conventions de la plateforme (Android ou iOS)
  et les habitudes prises dans les autres apps (loi de Jakob, plus bas).

## 6. Prévention et récupération des erreurs

Ordre de préférence :

1. **Rendre l'erreur impossible** : sélecteur de date au lieu d'un champ texte,
   stepper `– 3 +` au lieu d'une saisie libre de la quantité.
2. **Prévenir** : désactiver « Payer » si le panier est vide ; demander confirmation
   avant une action **irréversible**.
3. **Permettre d'annuler** : préférer « Supprimé. ANNULER » à une boîte de
   confirmation pour les actions réversibles. C'est moins de friction.
4. **Bien expliquer l'erreur** : quoi, pourquoi, comment corriger. Message
   placé **à côté** du problème.

Un bon message d'erreur :

> ❌ « Erreur de validation »
> ✅ « Le prix doit être supérieur à 0 Ar. »

## 7. Les lois utiles en design mobile

| Loi | Énoncé | Conséquence pratique |
|---|---|---|
| **Fitts** | Le temps pour atteindre une cible dépend de sa distance et de sa taille | Actions fréquentes : grandes et proches du pouce. Zones tactiles ≥ 48 dp |
| **Hick** | Plus il y a de choix, plus la décision est longue | Limiter les options visibles. Une action principale par écran |
| **Miller** (et travaux récents) | La mémoire de travail retient peu d'éléments (environ 4 groupes) | Découper : numéro `034 12 345 67` plutôt que `0341234567` ; formulaires en étapes |
| **Jakob** | Les utilisateurs passent la plupart de leur temps sur *d'autres* apps | Respecter les conventions. L'originalité a un coût |
| **Seuil de Doherty** | Sous 400 ms, l'interaction paraît fluide | Feedback instantané ; si c'est plus long, montrer la progression |
| **Tesler** | Toute complexité incompressible doit être portée par quelqu'un | Mieux vaut que ce soit l'app (valeurs par défaut, calculs automatiques) |
| **Von Restorff** | Un élément différent des autres est mémorisé | Un seul bouton coloré = l'action principale |

## 8. La charge cognitive

C'est l'effort mental demandé pour utiliser l'interface. On en distingue deux sortes :

- **intrinsèque** : la difficulté de la tâche elle-même (choisir un produit) ;
- **extrinsèque** : l'effort **ajouté par une mauvaise interface** (chercher le
  bouton, décoder une icône, se souvenir d'une info de l'écran précédent).

Le designer ne peut réduire que la seconde. Il dispose de six leviers :

1. supprimer ce qui ne sert pas la tâche ;
2. regrouper ce qui va ensemble (D04, Gestalt) ;
3. utiliser des valeurs par défaut intelligentes ;
4. montrer progressivement (« Plus d'options ») ;
5. utiliser des conventions connues ;
6. ne jamais obliger à mémoriser d'un écran à l'autre.

### Éviter les interfaces surchargées

Test des 5 secondes : montre l'écran 5 secondes à quelqu'un, cache-le, puis
demande « À quoi sert cet écran ? Que peux-tu y faire ? ». Si la personne ne
sait pas répondre, l'écran est surchargé ou sa hiérarchie est mauvaise.

## 9. Exemple d'analyse rapide

Écran d'accueil hypothétique d'une app de stock :

```
┌──────────────────────────────┐
│ ☰  STOCK MANAGER PRO v2.1  ⚙ │
├──────────────────────────────┤
│ [Produits][Catégories][Fourn.]│
│ [Entrées][Sorties][Inventaire]│
│ [Rapports][Export][Import]    │
│ [Utilisateurs][Aide][À propos]│
│                              │
│ Dernière synchro : 1698412345│
└──────────────────────────────┘
```

| Problème | Heuristique / loi | Proposition |
|---|---|---|
| 12 boutons de même poids | Hick, minimalisme (8) | Mettre en avant 2 ou 3 actions quotidiennes ; le reste dans un menu |
| Rien ne dit ce qui demande une action | Visibilité de l'état (1) | Carte « 5 produits sous le seuil » en tête |
| Timestamp brut | Monde réel (2) | « Synchronisé il y a 3 min » |
| Version dans le titre | Minimalisme (8) | Déplacer dans « À propos » |

## 10. Erreurs fréquentes du débutant

- Commencer par les couleurs et les polices avant de savoir ce que l'écran doit permettre.
- Concevoir pour soi (« moi je comprends »).
- Confondre « beaucoup de fonctionnalités » et « utile ».
- Ajouter une confirmation partout, alors qu'un « Annuler » suffit.
- Inventer une navigation originale au lieu des conventions.
- Écrire des messages techniques destinés au développeur.

## 11. Questions de révision

1. Donne un exemple d'application avec une bonne UI et une mauvaise UX.
2. Pourquoi demander « racontez-moi la dernière fois que… » plutôt que « utiliseriez-vous… » ?
3. Cite les 10 heuristiques de Nielsen de mémoire.
4. Quelle est la différence entre prévenir une erreur et permettre de la récupérer ? Quand préférer « Annuler » à une confirmation ?
5. Explique la loi de Fitts et sa conséquence pour un bouton « Ajouter au panier ».
6. Quelle charge cognitive le designer peut-il réduire ? Donne trois leviers.

## Pour aller plus loin

- Nielsen Norman Group, *10 Usability Heuristics* : https://www.nngroup.com/articles/ten-usability-heuristics/
- *Laws of UX* : https://lawsofux.com/
- Livre : Don Norman, *The Design of Everyday Things* (pour l'affordance et le feedback).
