{inputs, ...}: {
  den.aspects.nvf.homeManager = {lib, ...}: let
    inherit (lib.generators) mkLuaInline;
    inherit (inputs.nvf.lib.nvim.dag) entryBefore entryAfter;
  in {
    programs.nvf.settings.vim = {
      luaConfigRC = {
        dashboard-header-color = ''
          vim.api.nvim_set_hl(0, "DashboardHeader", { link = "String" })
        '';

        dashboard-start-time = entryBefore ["optionsScript"] ''
          _G.__nvf_start_time = vim.uv.hrtime()
        '';

        dashboard-startup-ms = entryAfter ["mappings"] ''
          _G.__nvf_startup_ms = (vim.uv.hrtime() - _G.__nvf_start_time) / 1e6
        '';
      };

      dashboard.dashboard-nvim = {
        enable = true;
        setupOpts = {
          theme = "doom";
          shortcut_type = "number";
          config = {
            header = [
              "                                                             "
              "███╗   ██╗███████╗██╗   ██╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ "
              "████╗  ██║██╔════╝╚██╗ ██╔╝██╔═══██╗██║   ██║██║████╗ ████║ "
              "██╔██╗ ██║█████╗   ╚████╔╝ ██║   ██║██║   ██║██║██╔████╔██║ "
              "██║╚██╗██║██╔══╝    ╚██╔╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ "
              "██║ ╚████║███████╗   ██║   ╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ "
              "╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
              "                                                             "
            ];
            center = [
              {
                action = "Telescope oldfiles";
                desc = " Recent Files";
                icon = "󰥔 ";
                key = "R";
              }
              {
                action = "Telescope find_files";
                desc = " Find Files";
                icon = "󰈞 ";
                key = "F";
              }
              {
                action = "ene | startinsert";
                desc = " New File";
                icon = " ";
                key = "N";
              }
              {
                action = "Telescope frecency";
                desc = " Frequency/MRU";
                icon = "󰗎 ";
                key = "M";
              }
              {
                action = "Telescope live_grep";
                desc = " Find word";
                icon = "󰈬 ";
                key = "G";
              }
              {
                action = "Telescope marks";
                desc = " Jump to bookmarks";
                icon = " ";
                key = "B";
              }
              {
                action = "lua require('mini.sessions').read()";
                desc = " Open last session";
                icon = "󰑓 ";
                key = "S";
              }
              {
                action = "qa";
                desc = " Quit";
                icon = "󰩈 ";
                key = "Q";
              }
            ];
            footer = mkLuaInline ''
              function()
                local quotes = {
                  "Il y a une différence entre connaître le chemin et arpenter le chemin.",
                  "Je montrerai à ces gens ce que vous ne voulez pas qu'ils voient. Je leur ferai voir un monde sans vous, un monde sans lois ni contrôle, sans limites ni frontières, un monde où tout est possible. Ce que nous en ferons ne dépendra que de vous.",
                  "Dites-moi, M. Anderson, à quoi bon téléphoner si vous êtes dans l'incapacité de parler ?",
                  "Tout ce qui a commencé doit finir.",
                  "Suis le lapin blanc.",
                  "Choisis la pilule bleue et tout s'arrête. Après, tu pourras faire de beaux rêves et penser ce que tu veux. Choisis la pilule rouge, tu restes au pays des merveilles et on descend avec le lapin blanc au fond du gouffre.",
                  "On n'est pas le meilleur quand on le croit mais quand on le sait.",
                  "Je ne peux que te montrer la porte, c'est à toi qu'il appartient de la franchir.",
                  "Je n'ai pas dit que ce serait facile, Néo, j'ai dit que ce serait la vérité.",
                  "Je ne crois pas qu'il faille s'en remettre à l'espoir, conseiller, je crois qu'il faut s'en remettre au temps.",
                  "Toute chose commence par un choix.",
                  "Il y a une seule et unique constante. Une seule règle d'or, une seule et unique vérité absolue, la causalité. Action ? - réaction. Cause ? - effet.",
                  "Le choix n'est rien qu'une illusion créée pour séparer ceux qui ont le pouvoir de ceux qui ne l'ont pas.",
                  "Oui je comprends. Qui a le temps ? Qui a le temps ? Mais si personne ne prenait son temps, comment ferait-on pour avoir du temps ? Château Haut-Brion 1959, magnifique bouquet. J'adore le vin français. Tout comme j'aime la langue française. J'ai testé toutes les langues, j'ai une faiblesse pour le français. C'est une langue merveilleuse. J'aime notamment les jurons français. Nom de Dieu de putain de bordel de merde de saloperie de connard d'enculé de ta mère. Vous voyez, c'est aussi jouissif que de se torcher le cul avec de la soie. J'adore ça.",
                  "La causalité ? Pas moyen d'y échapper ! Nous y sommes à jamais asservis. Notre seul espoir, notre seule paix consiste à le comprendre, à comprendre le pourquoi. Pourquoi. Voilà ce qui nous sépare d'eux ! Ce qui vous distingue de moi. Pourquoi est la seule vraie source de pouvoir, sans lui vous êtes paralysés.",
                  "N'essaie pas de tordre la cuillère car c'est impossible. Tu dois essayer de te concentrer pour faire éclater la vérité : la cuillère n'existe pas. Et là tu sauras que la seule chose qui se plie ce n'est pas la cuillère, c'est seulement ton reflet.",
                  "C'est drôle, je sais que ce steak n'existe pas, je sais que lorsque je le mets dans ma bouche c'est la Matrice qui dit à mon esprit que ce steak est saignant et délicieux... Au bout de neuf ans, vous savez ce que j'ai compris ? Les ignorants sont bénis !",
                  "Tu connais cette route. Tu sais exactement où elle mène. Et je sais que ce n'est pas là où tu veux être.",
                  "- POURQUOI ! POURQUOI, MR. ANDERSON, DEVEZ-VOUS INSISTER ! - Parce que je choisis de le faire.",
                  "Nous ne sommes pas ici parce que nous sommes libres, nous sommes ici parce que nous ne sommes pas libres.",
                }
                math.randomseed(os.time())
                local plugins = #vim.fn.globpath(vim.o.packpath, "pack/*/start/*", 0, 1)
                  + #vim.fn.globpath(vim.o.packpath, "pack/*/opt/*", 0, 1)

                -- NOTE: text wrap for quotes
                local lines = {
                  "",
                  string.format("%d plugins loaded in %.2fms", plugins, _G.__nvf_startup_ms or 0),
                  "",
                }
                local line = ""
                for word in quotes[math.random(#quotes)]:gmatch("%S+") do
                  local candidate = line == "" and word or (line .. " " .. word)
                  if vim.api.nvim_strwidth(candidate) > 60 then
                    table.insert(lines, line)
                    line = word
                  else
                    line = candidate
                  end
                end
                table.insert(lines, line)
                return lines
              end
            '';
          };
        };
      };
    };
  };
}
