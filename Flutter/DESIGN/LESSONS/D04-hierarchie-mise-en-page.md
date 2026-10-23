# D04 — Hiérarchie visuelle et mise en page

Durée : 2 h 30 à 3 h. Prérequis : D03. Flutter : `Row`, `Column`, `Padding`
(semaine 6) pour la partie programmation. Exercices : [`EXERCISES/D04.md`](../EXERCISES/D04.md)

## 1. Objectifs pédagogiques

- Expliquer comment l'œil parcourt un écran et comment le guider.
- Utiliser les 6 leviers de la hiérarchie visuelle.
- Appliquer les principes de la Gestalt.
- Utiliser l'espace blanc comme un outil.
- Traduire une hiérarchie en widgets Flutter.

## 2. Qu'est-ce que la hiérarchie visuelle ?

C'est l'**ordre dans lequel l'œil perçoit** les éléments. Une bonne hiérarchie
fait correspondre cet ordre à l'**ordre d'importance** défini lors de la
conception (D03).

Test : plisse les yeux devant l'écran, jusqu'à ce que tout devienne flou. Les
taches qui restent visibles sont ce que l'utilisateur voit en premier.
Correspondent-elles à ce qui est le plus important ?

### Comment l'œil parcourt un écran

- **Schéma en F** : sur les écrans riches en texte (listes, articles), l'œil
  lit le haut, puis balaie la gauche en descendant. Le **début** des lignes est
  lu, la fin beaucoup moins. Conséquence : mettre le mot important en début de
  ligne (« Riz blanc 5 kg », pas « Sac de 5 kg de riz blanc »).
- **Schéma en Z** : sur les écrans peu chargés (accueil, onboarding), l'œil va
  en haut à gauche, puis en haut à droite, en diagonale, puis en bas à droite.
  L'action finale (le bouton) a sa place en bas.

## 3. Les 6 leviers de la hiérarchie

| Levier | Plus important = | Attention |
|---|---|---|
| **Taille** | Plus grand | Le plus puissant. 2 ou 3 tailles de texte par écran suffisent |
| **Graisse** | Plus gras | Normal (400), moyen (500) et gras (700) suffisent |
| **Couleur / contraste** | Plus contrasté, coloré | Une seule couleur d'accent pour l'action principale |
| **Position** | En haut, à gauche (en lecture LTR) | Respecter le parcours de l'œil |
| **Espace** | Entouré de plus d'espace | L'isolement attire l'œil |
| **Forme / style** | Différent des autres (Von Restorff) | Un seul élément « différent » par zone |

Le plus souvent, **combiner 2 leviers** suffit. Un titre à la fois très grand,
très gras, coloré, souligné et encadré crie au lieu de guider.

### Désaccentuer au lieu d'accentuer

Quand un élément ne ressort pas assez, le réflexe est de le grossir. Souvent,
il vaut mieux **réduire les autres** : passer le texte secondaire en gris
(`onSurfaceVariant`), réduire sa taille, retirer les bordures inutiles.

### Exemple : une carte produit

```
AVANT : tout au même niveau        APRÈS : hiérarchie claire
┌────────────────────────┐         ┌────────────────────────┐
│ ┌─╳─┐ Nom : Riz 5 kg   │         │ ┌─╳─┐ Riz blanc 5 kg   │ ← titleMedium
│ └───┘ Prix : 12500 Ar  │         │ └───┘ Vakinankaratra   │ ← bodySmall, gris
│       Origine : Vakin. │         │                        │
│       Stock : 24       │         │       12 500 Ar   24 ▣ │ ← titleLarge, gras
└────────────────────────┘         └────────────────────────┘    + stock en label
```

Ce qui a changé :

- les **étiquettes** « Nom : », « Prix : » ont disparu, car le format suffit à
  reconnaître chaque donnée (un prix ressemble à un prix) ;
- le **prix** est grand et gras : c'est l'information décisive pour acheter ;
- l'**origine** est discrète : on la lit seulement si on la cherche ;
- le nom et l'origine forment un **groupe** (proximité), et prix et stock en
  forment un autre.

## 4. La Gestalt : comment le cerveau regroupe

| Principe | Énoncé | Application |
|---|---|---|
| **Proximité** | Ce qui est proche semble lié | Espace **plus petit** à l'intérieur d'un groupe qu'entre les groupes |
| **Similarité** | Ce qui se ressemble semble avoir la même fonction | Tous les liens ont le même style ; tous les boutons secondaires aussi |
| **Région commune** | Ce qui est dans un même cadre est groupé | Cartes, sections avec un fond |
| **Continuité** | L'œil suit les lignes et les alignements | Aligner sur un même axe gauche |
| **Clôture** | Le cerveau complète les formes | Carrousel dont la dernière carte est coupée : « il y a plus à droite » |
| **Figure / fond** | On distingue un premier plan d'un fond | Feuille modale sur un fond assombri |

**La proximité est le principe le plus utile et le plus souvent violé.** Règle :

> espacement **interne** d'un groupe < espacement **entre** les groupes

```
MAUVAIS (espaces égaux)     BON (espaces proportionnés)
Nom                         Nom
                            [ ░░░░░░░ ]
[ ░░░░░░░ ]
                            Prix
Prix
                            [ ░░░░░░░ ]
[ ░░░░░░░ ]
```

À gauche, on ne sait pas si « Prix » appartient au champ du dessus ou du dessous.

## 5. L'espace blanc

L'espace blanc (ou « espace négatif ») n'est **pas** de l'espace perdu. Il :

- **sépare** les groupes (proximité) ;
- **met en valeur**, car un élément isolé attire l'œil ;
- **augmente la lisibilité**, puisque le texte respire ;
- **donne une impression de qualité** : comparer une boutique de luxe et un étal surchargé.

Sur mobile, la tentation est de tout remplir parce que l'écran est petit. Il
vaut mieux montrer **moins de choses, mais lisibles**, et laisser défiler.

## 6. Alignement

- **Tout s'aligne sur quelque chose.** Un élément « à peu près » aligné a l'air
  d'une erreur.
- Sur mobile, **aligner à gauche** le texte et les titres. Centrer seulement les
  contenus courts et isolés (état vide, écran de succès).
- **Aligner les nombres à droite** dans les listes de prix, pour que les unités
  tombent sous les unités.
- Un élément **décalé exprès** doit l'être franchement : un petit décalage
  ressemble à une erreur.

## 7. Traduction en Flutter

```dart
import 'package:flutter/material.dart';

/// Carte produit : la hiérarchie vient du thème, pas de valeurs en dur.
class CarteProduit extends StatelessWidget {
  const CarteProduit({
    super.key,
    required this.nom,
    required this.origine,
    required this.prix,
    required this.stock,
  });

  final String nom;
  final String origine;
  final String prix;
  final int stock;

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;
    final couleurs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image : taille fixe, coins arrondis
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: couleurs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, color: couleurs.onSurfaceVariant),
            ),
            const SizedBox(width: 16), // espace ENTRE groupes : 16
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Groupe 1 : identité (espace interne : 4)
                  Text(nom, style: texte.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    origine,
                    style: texte.bodySmall?.copyWith(
                      color: couleurs.onSurfaceVariant, // désaccentué
                    ),
                  ),
                  const SizedBox(height: 16), // espace ENTRE groupes : 16
                  // Groupe 2 : décision d'achat
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        prix,
                        style: texte.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('$stock en stock', style: texte.labelMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Points à remarquer :

- `SizedBox(height: 4)` à l'intérieur d'un groupe et `SizedBox(height: 16)`
  entre deux groupes : c'est le principe de **proximité** traduit en code ;
- `copyWith` part du style du thème et ne change qu'une propriété. La taille
  reste cohérente avec le reste de l'app ;
- `Expanded` : le texte prend la place restante au lieu de déborder ;
- `Wrap` avec `WrapAlignment.spaceBetween` : le prix est à gauche et le stock à
  droite, **et** si la place manque, le stock passe à la ligne. La première
  version utilisait `Row` + `Spacer()`. Elle débordait (bande jaune et noire)
  avec un prix long ou le texte agrandi à 200 %. Le défaut a été trouvé en
  testant la carte sur un écran de 360 de large avec le texte agrandi : on
  testera toujours ainsi (D12).

## 8. Erreurs fréquentes

- Trop de tailles de texte différentes (5 ou 6 sur un écran).
- Tout en gras, donc plus rien ne ressort.
- Espacements identiques partout, donc aucun groupe n'apparaît.
- Centrer des paragraphes ou des listes.
- Des étiquettes redondantes (« Prix : ») qui doublent la quantité de texte.
- Utiliser la couleur comme **seul** levier, illisible pour les daltoniens (D05).
- Placer deux textes dans une `Row` sans prévoir le manque de place (`Expanded`,
  `Flexible` ou `Wrap`).

## 9. Questions de révision

1. Décris le test du plissement des yeux et ce qu'il révèle.
2. Quelle est la différence entre le schéma en F et le schéma en Z ? Où les rencontre-t-on ?
3. Cite les 6 leviers de la hiérarchie. Pourquoi en combiner seulement 2 ?
4. Énonce la règle de proximité avec les espacements internes et externes.
5. Quand centrer un texte sur mobile ?
6. Dans le code ci-dessus, quelle ligne exprime la désaccentuation ?

## Pour aller plus loin

- NN/g, *Visual hierarchy* : https://www.nngroup.com/articles/visual-hierarchy-ux-definition/
- Livre : Adam Wathan & Steve Schoger, *Refactoring UI*, très concret et orienté développeur.
