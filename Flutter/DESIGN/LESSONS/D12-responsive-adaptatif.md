# D12 — Interfaces responsives et adaptatives

Durée : 3 h. Prérequis : D11, contraintes de layout (semaine 6).
Exercices : [`EXERCISES/D12.md`](../EXERCISES/D12.md)

## 1. Objectifs pédagogiques

- Distinguer responsive et adaptatif.
- Utiliser les classes de taille de fenêtre Material 3.
- Choisir entre `MediaQuery` et `LayoutBuilder`.
- Gérer `SafeArea`, le clavier virtuel, le débordement et l'orientation.
- Concevoir pour le texte agrandi.
- Prendre en compte les particularités Android et iOS.

## 2. Responsive ou adaptatif ?

| | Responsive | Adaptatif |
|---|---|---|
| Principe | La **même** mise en page s'étire et se réorganise | Une mise en page **différente** selon le contexte |
| Exemple | Grille de 2 colonnes → 3 colonnes | Barre inférieure sur téléphone → rail latéral sur tablette |
| Outils | `Expanded`, `Flexible`, `Wrap`, `AspectRatio`, grilles « max extent » | `LayoutBuilder` + choix de widgets |

Une bonne app fait **les deux**.

## 3. Les classes de taille de fenêtre (Material 3)

On raisonne en **largeur de fenêtre**, pas en « type d'appareil ». Un pliable
ouvert, une tablette en écran partagé ou une fenêtre Linux redimensionnée
peuvent tous être « compacts ».

| Classe | Largeur | Appareils typiques | Navigation | Colonnes |
|---|---|---|---|---|
| **Compact** | < 600 | Téléphone portrait | `NavigationBar` en bas | 1 (liste) |
| **Moyenne** | 600 – 839 | Tablette portrait, pliable ouvert | `NavigationRail` | 1-2 |
| **Étendue** | 840 – 1199 | Tablette paysage | `NavigationRail` ou tiroir | 2 (liste + détail) |
| **Large / très large** | ≥ 1200 | Bureau | Tiroir permanent | 2-3 |

Le modèle **liste-détail** : en compact, la liste et le détail sont deux écrans.
À partir d'« étendue », ils s'affichent côte à côte.

```
COMPACT (< 600)              ÉTENDUE (≥ 840)
┌──────────┐  ┌──────────┐   ┌──┬───────────┬──────────────────┐
│ Liste    │→ │ Détail   │   │☰ │ Liste     │ Détail           │
│ ───      │  │          │   │🏠│ ─── ◀sél. │                  │
│ ───      │  │          │   │📦│ ───       │                  │
│ ───      │  │          │   │🛒│ ───       │                  │
├──────────┤  └──────────┘   │👤│           │                  │
│🏠 📦 🛒 👤│                 └──┴───────────┴──────────────────┘
└──────────┘                 rail      liste        détail
```

## 4. `MediaQuery` ou `LayoutBuilder` ?

| | `MediaQuery` | `LayoutBuilder` |
|---|---|---|
| Donne | Infos sur l'**écran / la fenêtre** : taille, marges système, clavier, échelle du texte, préférences | Les **contraintes de l'espace parent** |
| Utiliser pour | Décisions globales (navigation), `SafeArea`, clavier, accessibilité | Composants qui s'adaptent à **leur** place |
| Exemple | « La fenêtre fait 900 → rail » | « Ma carte a 280 de large → image au-dessus du texte » |

Utilise les accesseurs **ciblés** : `MediaQuery.sizeOf(context)`,
`MediaQuery.paddingOf(context)`, `MediaQuery.viewInsetsOf(context)`,
`MediaQuery.textScalerOf(context)`. Avec `MediaQuery.of(context).size`, le
widget se reconstruit à **chaque** changement de n'importe quelle donnée (même
le clavier). Avec `sizeOf`, il ne se reconstruit que si la taille change.

## 5. Exemple : navigation adaptative

```dart
import 'package:flutter/material.dart';

/// Points de rupture M3.
abstract final class Rupture {
  static const double moyenne = 600;
  static const double etendue = 840;
}

class CoquilleAdaptative extends StatefulWidget {
  const CoquilleAdaptative({super.key});

  @override
  State<CoquilleAdaptative> createState() => _CoquilleAdaptativeState();
}

class _CoquilleAdaptativeState extends State<CoquilleAdaptative> {
  int _index = 0;

  static const _destinations = [
    (Icons.home_outlined, Icons.home, 'Accueil'),
    (Icons.inventory_2_outlined, Icons.inventory_2, 'Catalogue'),
    (Icons.shopping_cart_outlined, Icons.shopping_cart, 'Panier'),
    (Icons.person_outline, Icons.person, 'Compte'),
  ];

  @override
  Widget build(BuildContext context) {
    final largeur = MediaQuery.sizeOf(context).width;
    final contenu = Center(child: Text(_destinations[_index].$3));

    // Compact : barre en bas
    if (largeur < Rupture.moyenne) {
      return Scaffold(
        body: contenu,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (final (icone, iconeActive, libelle) in _destinations)
              NavigationDestination(
                icon: Icon(icone),
                selectedIcon: Icon(iconeActive),
                label: libelle,
              ),
          ],
        ),
      );
    }

    // Moyenne et plus : rail à gauche
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              extended: false,
              destinations: [
                for (final (icone, iconeActive, libelle) in _destinations)
                  NavigationRailDestination(
                    icon: Icon(icone),
                    selectedIcon: Icon(iconeActive),
                    label: Text(libelle),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: contenu),
          ],
        ),
      ),
    );
  }
}
```

## 6. Exemple : grille responsive avec `LayoutBuilder`

```dart
import 'package:flutter/material.dart';

class GrilleProduits extends StatelessWidget {
  const GrilleProduits({super.key, required this.nombre});

  final int nombre;

  @override
  Widget build(BuildContext context) {
    // Plutôt qu'un nombre de colonnes fixe, on fixe une largeur MAXIMALE
    // de carte : Flutter calcule le nombre de colonnes.
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: nombre,
      itemBuilder: (context, i) => LayoutBuilder(
        builder: (context, contraintes) {
          // La carte adapte son contenu à SA largeur, pas à celle de l'écran.
          final etroite = contraintes.maxWidth < 160;
          return Card.filled(
            child: Center(
              child: Text(
                etroite ? 'P$i' : 'Produit $i',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}
```

## 7. Les zones système : `SafeArea`

Encoche, caméra perforée, barre d'état, barre de gestes, coins arrondis :
`SafeArea` ajoute le padding nécessaire pour que le contenu ne soit pas masqué.

- `Scaffold` + `AppBar` gèrent déjà le haut.
- Un contenu **sans AppBar**, ou une **barre fixe en bas** : enveloppe-le dans
  `SafeArea` (avec `top: false` si le haut est déjà géré).
- Les **fonds** (couleur, image) peuvent aller sous les zones système ; le
  **contenu interactif**, non.
- Android 15 et plus impose l'affichage **bord à bord** (edge-to-edge) : les
  barres système sont transparentes par-dessus l'app. Vérifie toujours le haut
  et le bas de tes écrans.

## 8. Le clavier virtuel

Quand un champ prend le focus, le clavier recouvre jusqu'à la moitié de l'écran.

- Par défaut, `Scaffold` **réduit** son `body` (`resizeToAvoidBottomInset: true`).
- Un formulaire doit donc être **défilable** (`ListView` ou
  `SingleChildScrollView`), sinon il déborde (bande jaune et noire).
- `MediaQuery.viewInsetsOf(context).bottom` donne la hauteur du clavier.
- Bouton « Valider » : **dans le flux** du formulaire, ou dans une barre qui
  remonte au-dessus du clavier. Jamais caché dessous.
- Fermer le clavier en touchant ailleurs :
  `TextField(onTapOutside: (_) => FocusScope.of(context).unfocus())`.

## 9. Le débordement

| Situation | Solution |
|---|---|
| `Column` trop haute | `ListView` ou `SingleChildScrollView` |
| `Text` trop long dans une `Row` | `Expanded` / `Flexible` autour du `Text` + `overflow: TextOverflow.ellipsis` |
| Plusieurs puces qui ne tiennent pas sur une ligne | `Wrap` au lieu de `Row` |
| Ligne « libellé + valeur » qui déborde en texte agrandi | `Wrap`, ou passer en `Column` sous un seuil (`LayoutBuilder`) |
| Image trop grande | `AspectRatio`, `BoxFit.cover` |

## 10. Orientation et tablettes

- Ne **bloque pas** l'orientation sans raison. Si tu utilises les classes de
  taille, le paysage est géré automatiquement : un téléphone en paysage devient
  souvent « moyen ».
- Sur grand écran, **limite la largeur du contenu de lecture** :
  `Center > ConstrainedBox(maxWidth: 600)`. Un formulaire de 1 200 px de large
  est illisible.
- Les **boîtes de dialogue** et **feuilles** ont une largeur maximale sur tablette.

## 11. Le texte agrandi

Teste toujours à **200 %** (Paramètres → Affichage → Taille de police, ou dans
Flutter : `MediaQuery(data: …copyWith(textScaler: TextScaler.linear(2)))`).

Ce qui casse le plus souvent :

- des hauteurs fixes autour du texte ;
- des `Row` avec deux textes ;
- des boutons de largeur fixe ;
- les puces et badges.

Ne réduis pas `textScaler` pour « sauver » la mise en page : c'est la mise en
page qu'il faut corriger. Exception tolérée : limiter **certains** très grands
titres déjà énormes, avec `TextScaler.clamp`.

## 12. Particularités Android et iOS

| Sujet | Android | iOS |
|---|---|---|
| Retour | Geste ou bouton système (prédictif sur Android récent) | Glissement depuis le bord gauche, bouton « ‹ » |
| Défilement | Effet d'étirement en fin de liste | Rebond |
| Titres d'AppBar | À gauche | Centrés (Flutter le fait automatiquement sur iOS) |
| Polices système | Roboto | SF Pro |
| Zones tactiles | 48 dp | 44 pt |
| Feuilles et dialogues | Material | Cupertino (`.adaptive`) |

Teste sur iOS si tu publies sur iOS : le comportement de `SafeArea`, le clavier
et le retour par glissement réservent des surprises. Il faut un Mac pour compiler.

## 13. Erreurs fréquentes

- Tester uniquement sur son propre téléphone.
- Décider selon le type d'appareil (« si tablette… ») au lieu de la largeur disponible.
- `MediaQuery.of(context).size` partout (reconstructions inutiles).
- Formulaire non défilable, donc débordement à l'ouverture du clavier.
- Contenu sous l'encoche ou la barre de gestes.
- Bloquer le texte agrandi ou l'orientation.

## 14. Questions de révision

1. Différence entre responsive et adaptatif ? Donne un exemple de chaque.
2. Quelles sont les classes de taille M3 et leurs largeurs ?
3. Quand utiliser `LayoutBuilder` plutôt que `MediaQuery` ?
4. Pourquoi préférer `MediaQuery.sizeOf(context)` à `MediaQuery.of(context).size` ?
5. Qu'est-ce que l'affichage bord à bord et quelle conséquence a-t-il ?
6. Comment éviter qu'un formulaire déborde quand le clavier apparaît ?

## Pour aller plus loin

- Flutter, *Adaptive and responsive design* : https://docs.flutter.dev/ui/adaptive-responsive
- Material 3, *Window size classes* : https://m3.material.io/foundations/layout/applying-layout/window-size-classes
- Material 3, *Canonical layouts* (liste-détail, flux, panneau) : https://m3.material.io/foundations/layout/canonical-layouts/overview
