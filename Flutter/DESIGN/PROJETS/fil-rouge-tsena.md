# Projet fil rouge — Tsena

> *Tsena* signifie « marché » en malgache.

Ce projet traverse tout le parcours design : on le conçoit (D01 à D10), on le
reproduit en Flutter (D11 à D14), on l'audite (D15). Il deviendra ensuite la
base de l'application connectée (semaines 16-17) et du projet final.

## Le brief

Une épicerie de quartier d'Antananarivo veut permettre à ses clients de
**commander en ligne** et de **retirer leurs courses en boutique**, ou de se
faire livrer dans le quartier. Elle vend environ 300 produits du quotidien :
riz, huile, sucre, savon, produits frais, crédit téléphonique.

### Contraintes connues

- Clients majoritairement sur Android d'entrée et de milieu de gamme.
- Connexion mobile parfois lente ou coupée.
- Paiement : Mobile Money ou espèces au retrait.
- La gérante prépare les commandes entre deux clients en boutique.
- Langue : français (le malgache pourra venir plus tard : prévoir des textes plus longs).

### Ce que tu dois découvrir toi-même (D01-D02)

- Qui sont les clients ? (au moins 2 personas)
- Pourquoi commanderaient-ils en ligne plutôt que de passer à la boutique ?
- Qu'est-ce qui les ferait abandonner ?

## Périmètre minimal (5 écrans + états)

1. **Accueil** : promotions, catégories, commande en cours éventuelle.
2. **Catalogue** : liste par catégorie, recherche, filtres.
3. **Détail produit** : informations, quantité, ajout au panier.
4. **Panier** : modification des quantités, total, mode de retrait.
5. **Confirmation de commande** : récapitulatif, suivi.

Plus, pour chaque écran : états **chargement**, **vide**, **erreur**, **hors ligne**.

## Livrables, module par module

| Module | Livrable dans `TRAVAUX/` |
|---|---|
| D01 | Personas, scénarios, user stories |
| D02 | Arborescence, user flow « commander », choix de navigation |
| D03 | Wireframes des 5 écrans + états |
| D04 | Wireframes révisés (hiérarchie), annotés |
| D05 | Palette clair/sombre + vérification des contrastes |
| D06 | Échelle typographique |
| D07 | Tokens d'espacement, de rayons, d'élévation |
| D08 | Design system documenté + thème Flutter |
| D09 | Bibliothèque de composants Flutter |
| D10 | Maquettes HF des 5 écrans dans Figma/Penpot |
| D11 | Écrans reproduits en Flutter + rapport d'écarts |
| D12 | Version responsive (téléphone + tablette) |
| D13 | Micro-interactions |
| D14 | Flux de commande et de connexion |
| D15 | Audit UX + test utilisateur + corrections |

## Où ranger le code ?

Projet Flutter : `PROJECTS/tsena/`. Tu le créeras au module D08, avec `flutter create`.
Productions de design : `DESIGN/TRAVAUX/Dxx/`.
