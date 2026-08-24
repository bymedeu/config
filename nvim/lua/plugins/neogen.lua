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
			local opts = {}
			if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
				opts.annotation_convention = "doxygen"
			end

			require("neogen").generate(opts)
		end, { desc = "Generate Doxygen/documentation" })
	end,
}
