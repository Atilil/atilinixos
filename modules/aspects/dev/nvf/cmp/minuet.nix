_: {
  den.aspects.nvf.homeManager = {pkgs, ...}: let
    # Claude: provider = "claude", model = "claude-haiku-5-5", its own key, drop the Gemini-only `optional`
    provider = "gemini";
    model = "gemini-2.5-flash-lite";
    keyFile = "/run/secrets/gemini_api_key_yoann";
  in {
    # minuet-ai: AI ghost-text suggestions (virtualtext) in DevOps filetypes.
    programs.nvf.settings.vim.extraPlugins.minuet = {
      package = pkgs.vimPlugins.minuet-ai-nvim;
      setup =
        #lua
        ''
          local key_file = "${keyFile}"

          -- Stay inert where the secret is absent (other hosts, standalone HM)
          if vim.fn.filereadable(key_file) == 1 then
            local function read_key()
              local f = io.open(key_file, "r")
              if not f then return nil end
              local key = f:read("*l")
              f:close()
              return key
            end

            -- Matched on the basename; enable_predicates only gates auto-trigger
            local sensitive = { "^%.env", "secrets", "%.sops%.", "%.age$", "%.key$", "%.pem$" }

            require("minuet").setup({
              provider = "${provider}",
              throttle = 2000,
              debounce = 800,
              request_timeout = 4,
              n_completions = 1,
              enable_predicates = {
                function()
                  local name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
                  for _, pat in ipairs(sensitive) do
                    if name:find(pat) then return false end
                  end
                  return true
                end,
              },
              virtualtext = {
                auto_trigger_ft = {
                  "nix", "terraform", "hcl", "yaml", "yaml.ansible", "yaml.gitlab",
                  "dockercompose", "dockerfile", "sh", "bash", "python", "lua",
                  "helm", "json", "toml", "jinja",
                },
                keymap = {
                  accept = "<A-y>",
                  accept_line = "<A-e>",
                  next = "<A-n>",
                  prev = "<A-p>",
                  dismiss = "<A-c>",
                },
              },
              provider_options = {
                ${provider} = {
                  model = "${model}",
                  api_key = read_key,
                  optional = {
                    generationConfig = {
                      maxOutputTokens = 128,
                    },
                  },
                },
              },
            })

            vim.keymap.set("n", "<leader>at", "<cmd>Minuet virtualtext toggle<cr>", { desc = "[AI] Toggle ghost text" })
          end
        '';
    };
  };
}
