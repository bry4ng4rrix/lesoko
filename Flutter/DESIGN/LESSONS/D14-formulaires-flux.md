# D14 — Formulaires et flux utilisateur

Durée : 3 h. Prérequis : D09, D12, `Form` et `TextFormField` (semaine 7).
Exercices : [`EXERCISES/D14.md`](../EXERCISES/D14.md)

## 1. Objectifs pédagogiques

- Concevoir un formulaire court, clair et accessible.
- Choisir le bon moment pour valider.
- Écrire des messages d'erreur utiles.
- Configurer le bon clavier et l'autoremplissage.
- Gérer chargement, soumission, double soumission et confirmation.
- Concevoir un flux d'inscription et de connexion complet.

## 2. Concevoir un formulaire

### 2.1 Moins de champs

Chaque champ a un coût (temps, abandon). Pour chacun, demande-toi :
- est-il **indispensable maintenant** ? (l'adresse peut attendre la première commande) ;
- peut-on le **déduire** ? (ville depuis le code postal, pays depuis le numéro) ;
- peut-on le **préremplir** ? (valeur par défaut, dernière valeur utilisée).

### 2.2 Structure

- **Une colonne**. Deux champs côte à côte seulement s'ils forment un tout
  (« Jour / Mois / Année »).
- **Libellé visible au-dessus** ou en libellé flottant (M3). **Jamais le
  placeholder seul** : il disparaît dès qu'on tape, et l'utilisateur oublie ce
  qu'on demandait.
- **Ordre logique** : celui de la pensée (nom → téléphone → adresse).
- **Grouper** les champs liés (D04, proximité), avec des titres de section si
  le formulaire est long.
- Indiquer les champs **optionnels** (« (facultatif) ») plutôt que les
  obligatoires avec des `*` : il y en a généralement moins.
- Formulaire long : le découper en **étapes** (stepper), avec la progression
  visible (« Étape 2 sur 3 »).

### 2.3 Le bon contrôle

| Donnée | Contrôle | Pourquoi |
|---|---|---|
| Choix parmi 2 à 5 options | `SegmentedButton` / radios | Options visibles, un seul toucher |
| Choix parmi beaucoup | `DropdownMenu` (avec recherche) | |
| Date | Sélecteur de date | Pas de format à deviner |
| Quantité | Stepper `– 1 +` | Pas de saisie invalide |
| Oui / non | `Switch` ou `Checkbox` | |
| Texte libre | `TextFormField` | |

## 3. Clavier et autoremplissage

| Champ | `keyboardType` | `autofillHints` | Autres |
|---|---|---|---|
| E-mail | `TextInputType.emailAddress` | `AutofillHints.email` | `autocorrect: false` |
| Téléphone | `TextInputType.phone` | `AutofillHints.telephoneNumber` | |
| Prix, quantité | `TextInputType.number` (ou `numberWithOptions(decimal: true)`) | — | `inputFormatters` pour filtrer |
| Mot de passe | `TextInputType.visiblePassword` | `AutofillHints.password` / `newPassword` | `obscureText: true` + bouton 👁 |
| Nom | `TextInputType.name` | `AutofillHints.name` | `textCapitalization: words` |
| Adresse | `TextInputType.streetAddress` | `AutofillHints.fullStreetAddress` | |

- `textInputAction: TextInputAction.next` : la touche « Suivant » du clavier
  passe au champ suivant. Sur le dernier champ, `TextInputAction.done` + `onFieldSubmitted` soumet.
- Entourer les champs d'un `AutofillGroup` permet au gestionnaire de mots de
  passe de proposer ses identifiants.

## 4. Quand valider ?

| Moment | Avantage | Inconvénient |
|---|---|---|
| À chaque frappe | Retour immédiat | Agressif : « E-mail invalide » dès la 1ʳᵉ lettre |
| Quand on quitte le champ | Juste après la saisie | Demande de gérer le focus |
| À la soumission | Simple, pas d'interruption | Erreurs découvertes tard |

**Stratégie recommandée (hybride)** :

1. **Ne rien afficher** tant que l'utilisateur n'a pas fini le champ, ou n'a pas soumis ;
2. à la **soumission**, valider tout et **amener le focus sur le premier champ en erreur** ;
3. ensuite, **revalider à chaque frappe** les champs en erreur, pour que
   l'erreur disparaisse dès que c'est corrigé.

En Flutter : `autovalidateMode: AutovalidateMode.onUserInteractionIfError`
(revalide après une première erreur), ou passer le `Form` en
`AutovalidateMode.onUserInteraction` **après** la première soumission.

## 5. Les messages d'erreur

Un bon message : **ce qui ne va pas** + **comment corriger**, dans la langue de
l'utilisateur, **sous le champ concerné**.

| ❌ | ✅ |
|---|---|
| « Champ invalide » | « Saisissez un e-mail au format nom@exemple.mg » |
| « Erreur » | « Le mot de passe doit contenir au moins 8 caractères » |
| « Requis » | « Saisissez le nom du produit » |
| « Error 409 » | « Un compte existe déjà avec cet e-mail. Se connecter ? » |
| « Mot de passe incorrect » (ton accusateur) | « E-mail ou mot de passe incorrect » (et ne pas dire lequel, pour la sécurité) |

Afficher aussi les **règles avant l'erreur** : « 8 caractères minimum » en texte
d'aide sous le champ mot de passe, **avant** que l'utilisateur se trompe.

## 6. Soumission, chargement, double soumission

```
[ ENREGISTRER ] ──toucher──► [ ◌ ] (bouton en chargement, champs désactivés)
                                 │
                 ┌───────────────┴────────────────┐
              succès                            échec
                 │                                │
   SnackBar « Produit enregistré »     Message d'erreur + données CONSERVÉES
   + navigation                        + bouton réactivé
```

- **Bloquer la double soumission** : bouton en état chargement (D09), action ignorée si déjà en cours.
- **Ne jamais vider le formulaire en cas d'échec.**
- **Erreur réseau** : un message distinct de l'erreur de validation (« Pas de
  connexion. Vos données sont conservées. RÉESSAYER »).

## 7. Confirmer les actions destructives

| Action | Réversible ? | Traitement |
|---|---|---|
| Retirer un article du panier | Oui | Action immédiate + SnackBar « ANNULER » |
| Archiver | Oui | Idem |
| Supprimer un produit et son historique | **Non** | **Dialogue de confirmation** |
| Supprimer son compte | **Non** | Confirmation **renforcée** (retaper un mot, mot de passe) |

Un bon dialogue de confirmation :

```
┌──────────────────────────────────────┐
│ Supprimer « Riz blanc 5 kg » ?       │  ← la question, avec l'objet
│                                      │
│ Son historique de stock (124         │  ← la conséquence
│ mouvements) sera aussi supprimé.     │
│ Cette action est irréversible.       │
│                                      │
│            [Annuler]  [SUPPRIMER]    │  ← verbe précis, couleur error
└──────────────────────────────────────┘
```

Pas de « Êtes-vous sûr ? » avec « Oui / Non ».

## 8. Exemple Flutter : formulaire de connexion

```dart
import 'package:flutter/material.dart';

class FormulaireConnexion extends StatefulWidget {
  const FormulaireConnexion({super.key, required this.seConnecter});

  /// Renvoie un message d'erreur, ou null si la connexion réussit.
  final Future<String?> Function(String email, String motDePasse) seConnecter;

  @override
  State<FormulaireConnexion> createState() => _FormulaireConnexionState();
}

class _FormulaireConnexionState extends State<FormulaireConnexion> {
  final _cleFormulaire = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _motDePasse = TextEditingController();
  bool _masque = true;
  bool _enCours = false;
  String? _erreurServeur;

  @override
  void dispose() {
    _email.dispose();
    _motDePasse.dispose();
    super.dispose();
  }

  Future<void> _soumettre() async {
    if (_enCours) return; // double soumission
    setState(() => _erreurServeur = null);
    if (!_cleFormulaire.currentState!.validate()) return;

    setState(() => _enCours = true);
    final erreur = await widget.seConnecter(_email.text.trim(), _motDePasse.text);
    if (!mounted) return; // l'écran a pu être fermé pendant l'attente
    setState(() {
      _enCours = false;
      _erreurServeur = erreur;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Form(
      key: _cleFormulaire,
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      child: AutofillGroup(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _email,
              enabled: !_enCours,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              autocorrect: false,
              textInputAction: TextInputAction.next,
              validator: (v) {
                final valeur = v?.trim() ?? '';
                if (valeur.isEmpty) return 'Saisissez votre e-mail';
                if (!valeur.contains('@') || !valeur.contains('.')) {
                  return 'Format attendu : nom@exemple.mg';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _motDePasse,
              enabled: !_enCours,
              obscureText: _masque,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                helperText: '8 caractères minimum',
                suffixIcon: IconButton(
                  tooltip: _masque
                      ? 'Afficher le mot de passe'
                      : 'Masquer le mot de passe',
                  icon: Icon(_masque ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _masque = !_masque),
                ),
              ),
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _soumettre(),
              validator: (v) => (v ?? '').length < 8
                  ? 'Le mot de passe contient au moins 8 caractères'
                  : null,
            ),
            if (_erreurServeur != null) ...[
              const SizedBox(height: 16),
              Text(_erreurServeur!, style: TextStyle(color: c.error)),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _enCours ? null : _soumettre,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: _enCours
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
```

À remarquer :

- `ListView` : le formulaire reste défilable quand le clavier apparaît (D12) ;
- `dispose()` des contrôleurs ;
- `if (!mounted) return;` après un `await` : l'utilisateur a pu quitter l'écran ;
- `_enCours` désactive les champs et le bouton, ce qui empêche la double soumission ;
- l'erreur serveur est affichée **séparément** des erreurs de validation ;
- `helperText` annonce la règle **avant** l'erreur.

## 9. Le flux d'inscription

```
( Ouvre l'app ) → [ Bienvenue ] ─┬─ « Créer un compte » → [ Inscription ] → [ Vérif. code SMS ] → [ Accueil ]
                                 └─ « J'ai un compte »  → [ Connexion ] ──────────────────────────→ [ Accueil ]
                                                              │
                                                    « Mot de passe oublié ? » → [ Réinitialisation ]
```

Bonnes pratiques :

- laisser **explorer avant de s'inscrire** si possible (catalogue visible sans compte) ;
- demander le **minimum** à l'inscription, et compléter le profil plus tard ;
- **un seul champ mot de passe** + bouton 👁, plutôt que « confirmer le mot de passe » ;
- connexion **et** inscription à un toucher l'une de l'autre ;
- après une erreur « compte existant », proposer directement de se connecter ;
- rappel (D12 de la roadmap) : la validation côté app est pour le **confort** ;
  la **sécurité** est toujours vérifiée par le serveur.

## 10. Erreurs fréquentes

- Le placeholder utilisé comme libellé.
- Des erreurs affichées dès la première frappe.
- Le formulaire vidé après une erreur serveur.
- Aucune protection contre la double soumission.
- Le mauvais clavier (texte pour un prix).
- « Êtes-vous sûr ? Oui / Non ».
- Oublier `dispose()` des `TextEditingController`.
- Utiliser `context` après un `await` sans vérifier `mounted`.

## 11. Questions de révision

1. Pourquoi ne jamais utiliser le placeholder seul ?
2. Décris la stratégie de validation hybride.
3. Réécris le message « Champ invalide » pour un champ de prix.
4. Quand préférer « Annuler » à une confirmation ?
5. À quoi sert `if (!mounted) return;` ?
6. Pourquoi un seul champ mot de passe avec 👁 plutôt que deux ?

## Pour aller plus loin

- Flutter, *Build a form with validation* : https://docs.flutter.dev/cookbook/forms/validation
- NN/g, *Website Forms Usability* : https://www.nngroup.com/articles/web-form-design/
- Material 3, *Text fields* : https://m3.material.io/components/text-fields/guidelines
