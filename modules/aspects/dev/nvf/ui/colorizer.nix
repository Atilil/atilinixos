_: {
  den.aspects.nvf.homeManager = {lib, ...}: {
    programs.nvf.settings.vim.ui.colorizer = {
      enable = true;
      setupOpts = {
        filetypes = {
          "*" = {};
        };
        options.parsers.names.extra_word_chars = lib.generators.mkLuaInline ''
          "-" .. (function()
            local bytes = {}
            for b = 0x80, 0xFF do
              bytes[#bytes + 1] = string.char(b)
            end
            return table.concat(bytes)
          end)()
        '';
      };
    };
  };
}
