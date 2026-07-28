-- file mason-lspconfig.lua

return {
	"williamboman/mason-lspconfig.nvim",

	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},

	opts = {
		-- Keep CMake support reproducible on a fresh machine instead of relying
		-- on a language server having been installed manually.
		ensure_installed = {
			"neocmake",
		},
	},
}
