-- file neogen.lua

return {
	"danymat/neogen",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"L3MON4D3/LuaSnip",
	},

	config = function()
		require("neogen").setup({
			snippet_engine = "luasnip",
		})

		vim.keymap.set("n", "<leader>cd", function()
			require("neogen").generate()
		end, { desc = "Generate documentation" })
	end,
}
