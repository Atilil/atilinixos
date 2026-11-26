# Snippets — format Lua (LuaSnip)

Format **programmatique**. Tu écris les snippets en Lua : tu débloques le calcul,
les conditions, les menus, les boucles. C'est le niveau « sophistiqué ».

Chargé par `require('luasnip.loaders.from_lua').lazy_load()` (câblé dans
`snippets.nix`), qui scanne le dossier `luasnippets/` du plugin généré.

- **Un fichier par filetype** : `nix.lua` → fichiers Nix, `yaml.lua` → YAML.
- Chaque fichier **retourne une liste de snippets** : `return { s(...), s(...) }`.

---

## 1. L'en-tête obligatoire

Tout fichier commence par récupérer les fonctions de LuaSnip. Copie-colle ce
bloc en haut de chaque `*.lua` :

```lua
local ls = require("luasnip")

local s     = ls.snippet         -- déclare un snippet
local t     = ls.text_node       -- texte fixe
local i     = ls.insert_node     -- trou éditable ($1, $2…)
local f     = ls.function_node   -- champ CALCULÉ à partir d'autres
local c     = ls.choice_node     -- menu de choix
local d     = ls.dynamic_node    -- bloc généré dynamiquement
local sn    = ls.snippet_node    -- sous-snippet (dans d() ou c())

local fmt   = require("luasnip.extras.fmt").fmt    -- gabarit lisible {}
local fmta  = require("luasnip.extras.fmt").fmta   -- gabarit lisible <>
local rep   = require("luasnip.extras").rep        -- miroir d'un nœud
```

Et se termine par :

```lua
return {
  -- tes snippets ici, séparés par des virgules
}
```

---

## 2. Les briques (nœuds)

Un snippet = une **liste de nœuds** assemblés. Les principaux :

| Nœud | Rôle | Exemple |
|---|---|---|
| `t("txt")` | texte fixe | `t("local ")` |
| `t({"l1","l2"})` | texte multi-lignes | saut de ligne entre `l1` et `l2` |
| `i(1)` | trou éditable n°1 | curseur ici, `Tab` pour avancer |
| `i(1, "defaut")` | trou pré-rempli | présélectionné |
| `i(0)` | position finale | fin du snippet |
| `rep(1)` | miroir du nœud 1 | recopie `i(1)` ailleurs |
| `f(fn, {1})` | champ calculé | dérive du texte du nœud 1 |
| `c(1, {...})` | choix | alterne entre plusieurs nœuds |
| `d(2, fn, {1})` | dynamique | génère un bloc selon le nœud 1 |

> Les **indices** (`i(1)`, `i(2)`…) fixent l'ordre de saut au `Tab`. `i(0)` = fin.

---

## 3. `fmt` / `fmta` — la lisibilité

Assembler des `t()` et `i()` à la main devient vite illisible. `fmt` te laisse
écrire le **gabarit en clair** avec des marqueurs, remplis par une liste de nœuds.

- `fmt` utilise `{}` comme marqueur.
- `fmta` utilise `<>` — **à préférer quand le code contient des `{}`** (Nix, Lua,
  JSON…), sinon il faut doubler les accolades `{{ }}`.

```lua
-- Équivalent du snippet `km`, version lisible (fmta car le Nix a des {})
s("km", fmta([[
{
  key = "<>";
  mode = ["<>"];
  action = "<>";
  desc = "<>";
  silent = true;
}]], { i(1), i(2), i(3), i(4) }))
```

Marqueurs nommés (utile quand un champ revient) :

```lua
s("svc", fmta([[
<name>:
  image: <img>
  networks:
    - <name>-net
]], { name = i(1), img = i(2) }))
-- <name> apparaît 2x : nommé, on ne le passe qu'une fois
```

---

## 4. La montée en puissance (exemples)

### a. Champ calculé — `f()`

Le nœud fonction reçoit le **texte des nœuds** qu'on lui désigne et retourne une
chaîne. Ici : dériver un nom de secret en MAJUSCULE depuis le nom du service.

```lua
s("db", fmta([[
<svc>-db:
  environment:
    - <up>_DB_PASSWORD_FILE=/run/secrets/<svc>_db_password
]], {
  svc = i(1, "app"),
  up  = f(function(args)
    -- args[1] = liste des lignes du nœud 1 ; on prend la 1re, en majuscules
    return args[1][1]:upper()
  end, { 1 }),
}))
```

Tape `app` au champ 1 → `APP_DB_PASSWORD_FILE` et `app_db_password` se
remplissent seuls. **Impossible en SnipMate** (qui ne sait que recopier à
l'identique).

### b. Menu de choix — `c()`

Le tier Swarm, en liste fermée au lieu d'un texte libre :

```lua
s("tier", fmta([[
placement:
  constraints:
    - node.labels.tier == <t>
]], {
  t = c(1, { t("apps"), t("infra"), t("media"), t("database") }),
}))
```

`Ctrl-e` (ou ta touche de choix) fait défiler les 4 options.

### c. Bloc conditionnel — `d()`

Le nœud dynamique génère un **sous-snippet** (`sn`) selon un autre champ. Ici :
n'afficher le bloc `secrets:` que si on répond `yes`.

```lua
s("svc-cond", fmta([[
<name>:
  image: <img>
<secrets>
]], {
  name = i(1),
  img  = i(2),
  secrets = d(3, function(args)
    -- args[1] = texte du nœud 1 (le nom) — on choisit selon un champ précédent
    if args[1][1] ~= "" then
      return sn(nil, fmta("  secrets:\n    - <>_password", { i(1) }))
    end
    return sn(nil, t(""))  -- rien
  end, { 1 }),
}))
```

> `sn(nil, {...})` = un mini-snippet réutilisable ; ses `i(1)` sont **locaux** au
> bloc dynamique.

---

## 5. Template à copier (`nix.lua` en est un exemplaire inerte)

```lua
local ls = require("luasnip")
local s, i, t = ls.snippet, ls.insert_node, ls.text_node
local fmta = require("luasnip.extras.fmt").fmta
local rep  = require("luasnip.extras").rep

return {
  s("MON_TRIGGER", fmta([[
premier : <>
rappel du premier : <>
fin
]], { i(1), rep(1) })),
}
```

---

## 6. Workflow

1. Crée/édite un `*.lua` ici (nom = filetype), termine par `return { ... }`.
2. **`git add`** — invisible pour le flake sinon.
3. `nh os switch` (ou `nh home switch -c "yoann@laptop"`).
4. Dans nvim : tape le trigger. Une **erreur Lua** dans le fichier casse le
   chargement de *tout* le filetype → vérifie `:messages` / `:LuaSnipListAvailable`.

---

## 7. Gotchas

- **`return` obligatoire** : un fichier sans `return { ... }` ne fournit aucun snippet.
- **Virgules** entre les snippets dans la liste (c'est une table Lua).
- **`fmta` vs `fmt`** : pour du Nix/Lua/JSON (pleins de `{}`), utilise `fmta`
  (`<>`) pour éviter d'échapper toutes les accolades.
- **Indices de nœuds** : `i(1)`, `i(2)`… pilotent l'ordre de `Tab`. Un `rep(n)`
  ou `f(_, {n})` ne crée pas de tab stop, il *reflète* le nœud `n`.
- **Autosnippets** : un fichier peut aussi retourner `return snippets, autosnippets`
  (2e liste = déclenchement sans `Tab`). À activer via `enable_autosnippets`.
