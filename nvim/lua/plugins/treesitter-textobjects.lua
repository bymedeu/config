-- Syntax-aware text objects for functions and classes.
return {
	"nvim-treesitter/nvim-treesitter-textobjects",

	branch = "main",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},

	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
				selection_modes = {
					["@function.outer"] = "V",
				},
				include_surrounding_whitespace = false,
			},
		})

		local select = require("nvim-treesitter-textobjects.select")

		vim.keymap.set({ "x", "o" }, "af", function()
			select.select_textobject("@function.outer", "textobjects")
		end, { desc = "Around function" })

		vim.keymap.set({ "x", "o" }, "if", function()
			select.select_textobject("@function.inner", "textobjects")
		end, { desc = "Inside function" })

		vim.keymap.set({ "x", "o" }, "ac", function()
			select.select_textobject("@class.outer", "textobjects")
		end, { desc = "Around class" })

		vim.keymap.set({ "x", "o" }, "ic", function()
			select.select_textobject("@class.inner", "textobjects")
		end, { desc = "Inside class" })
	end,
}
