# Snippets — format SnipMate

Format **texte, déclaratif**. Simple à écrire, mais sans logique : on déclare
des « trous » à remplir, rien de plus. Pour des snippets qui *calculent* ou
s'*adaptent*, voir `../lua/README.md`.

Chargé par `require('luasnip.loaders.from_snipmate').lazy_load()` (câblé dans
`snippets.nix`), qui scanne le dossier `snippets/` du plugin généré.

---

## 1. Anatomie d'un fichier

- **Un fichier par filetype** : `nix.snippets` s'applique aux fichiers Nix,
  `yaml.snippets` aux YAML. Le nom du fichier **est** le filetype.
- **Un snippet** = une ligne `snippet` + un corps indenté :

```snippets
snippet <trigger> <description optionnelle>
  ligne 1 du corps
  ligne 2 du corps
```

- Le **corps** est tout ce qui est indenté sous la ligne `snippet`. luasnip
  retire le premier niveau d'indentation (ici **2 espaces**) et garde le reste.
- Une **ligne vide** sépare deux snippets.

> ⚠️ **Indentation en 2 espaces**, pas de tab. C'est ce que génère la chaîne de
> build et ce que luasnip attend ici. Important surtout pour le YAML dont
> l'indentation est sémantique.

---

## 2. La syntaxe des trous

| Syntaxe | Nom | Effet |
|---|---|---|
| `$1`, `$2`, … | tab stop | position du curseur, `Tab` saute à la suivante |
| `$0` | tab stop final | où le curseur se pose à la fin (implicite si absent) |
| `${1:defaut}` | placeholder | tab stop pré-rempli, présélectionné (tape par-dessus) |
| `$1` répété | miroir | la même valeur recopiée à plusieurs endroits, en direct |
| `${1:${2:x}}` | imbrication | un placeholder qui contient lui-même un tab stop |

### Échappements

| Pour obtenir | Écrire |
|---|---|
| un `$` littéral | `\$` |
| un backtick littéral | `` \` `` (le backtick seul déclenche une interpolation) |

> Note `$$` : dans les snippets Swarm, `$$(cat …)` est **voulu tel quel** —
> docker-compose interprète `$$` → `$` côté conteneur. On le laisse littéral.

---

## 3. Exemples commentés (tirés de ce repo)

### Simple — `km` (nix.snippets)

```snippets
snippet km Keymap nvf
  {
    key = "$1";
    mode = ["$2"];
    action = "$3";
    desc = "$4";
    silent = true;
  }
```

Tu tapes `km`, valides, puis `Tab` te promène de `key` → `mode` → `action` →
`desc`.

### Miroir — un nom réutilisé

```snippets
snippet svc Service minimal
  ${1:nom}:
    image: $2
    networks:
      - $1-net
    # $1 réapparaît : tape le nom une fois, il se propage
```

---

## 4. Template à copier

```snippets
snippet MON_TRIGGER Ma description
  premier champ : ${1:defaut}
  deuxième champ : $2
  rappel du premier : $1
  fin : $0
```

---

## 5. Workflow

1. Édite/crée un `*.snippets` ici (nom = filetype).
2. **`git add`** — sans ça le flake ne voit pas le fichier, snippet absent.
3. `nh os switch` (ou `nh home switch -c "yoann@laptop"`).
4. Dans nvim : tape le trigger, il apparaît dans le menu blink.

---

## 6. Limites (quand passer au Lua)

SnipMate **ne sait pas** :

- transformer une valeur (mettre `$1` en MAJUSCULE ailleurs) → seulement la répéter à l'identique ;
- rendre un bloc **conditionnel** (ex. « ajoute `secrets:` seulement si mot de passe ») ;
- proposer un **menu de choix** (ex. tier `apps|infra|media|database`) ;
- répéter un nombre **variable** de champs.

Dès que tu butes sur un de ces besoins → `../lua/README.md`.
