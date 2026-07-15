-- file render_markdown.lua

return {
	"MeanderingProgrammer/render-markdown.nvim",

	ft = { "markdown" },

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local render_markdown = require("render-markdown")

		render_markdown.setup({
			-- Load enabled: this plugin is itself lazy-loaded for Markdown buffers,
			-- so a BufReadPost autocmd registered here is too late for the first file.
			enabled = true,

			file_types = { "markdown" },

			latex = {
				enabled = true,
				-- pylatexenc supplies latex2text on this system. The LaTeX parser,
				-- installed by the treesitter spec, identifies formulas in Markdown.
				converter = { "latex2text" },
			},
		})

		vim.keymap.set("n", "<leader>mr", function()
			render_markdown.toggle()
		end, { desc = "Toggle markdown rendering" })
	end,
}
