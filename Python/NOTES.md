# Notes — à retenir

## Semaine 1

### Exécuter du Python
- `python3 fichier.py` exécute un script ; `python3` seul ouvre l'interpréteur interactif (on le quitte avec `exit()` ou Ctrl+D).
- Python lit le fichier **de haut en bas** et s'arrête à la première erreur.

### Types de base
- `int` : nombre entier (`42`), `float` : nombre décimal (`3.14`), `str` : texte (`"42"`).
- `type(x)` affiche le type d'une valeur.
- `/` renvoie toujours un `float` ; `//` donne la division entière ; `%` le reste.
- `0.1 + 0.2` vaut `0.30000000000000004` : c'est normal, les `float` sont des approximations.

### Variables
- `nom = valeur` : le `=` **range** une valeur dans une étiquette, il ne teste pas une égalité.
- Noms en `snake_case`, sans accent, sans espace, sans commencer par un chiffre.
- Constante par convention : `TAUX_TVA = 0.2` (les majuscules signalent « ne pas modifier »).

### Erreurs déjà rencontrées
| Message | Cause habituelle |
|---|---|
| `SyntaxError` | Guillemet ou parenthèse non fermé, faute de syntaxe |
| `NameError: name 'x' is not defined` | Faute de frappe, ou variable utilisée avant d'être créée |
| `TypeError: can only concatenate str (not "int") to str` | `"texte" + nombre` : il faut convertir avec `str()` ou utiliser une f-string |
| `IndentationError: unexpected indent` | Espace parasite en début de ligne |
