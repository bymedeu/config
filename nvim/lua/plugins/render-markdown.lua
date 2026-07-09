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
			enabled = false,

			file_types = { "markdown" },

			latex = {
				enabled = true,
				converter = { "latex2text" },
			},
		})

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
			pattern = { "*.md", "*.markdown" },
			callback = function()
				render_markdown.enable()
			end,
		})

		vim.keymap.set("n", "<leader>mr", function()
			render_markdown.toggle()
		end, { desc = "Toggle markdown rendering" })
	end,
}
