-- Lua snippets for the `nix` filetype.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
	-- Example: a keymap block.
	-- s("km", fmta([[
	-- {
	--   key = "<>";
	--   mode = ["<>"];
	--   action = "<>";
	--   desc = "<>";
	--   silent = true;
	-- }]], { i(1), i(2), i(3), i(4) })),
}
