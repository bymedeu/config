-- file render_markdown.lua

return {
	"MeanderingProgrammer/render-markdown.nvim",

	ft = { "markdown" },

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
		"jbyuki/nabla.nvim",
	},

	config = function()
		local render_markdown = require("render-markdown")

			render_markdown.setup({
			-- Load enabled: this plugin is itself lazy-loaded for Markdown buffers,
			-- so a BufReadPost autocmd registered here is too late for the first file.
			enabled = true,

			file_types = { "markdown" },

			-- LSP hover windows are unlisted Markdown buffers. Leave those to
			-- Neovim's native hover renderer instead of applying full document
			-- rendering and Nabla virtual lines to a transient floating window.
			ignore = function(buf)
				return not vim.bo[buf].buflisted
			end,

			latex = {
				-- Nabla handles formulas below so fractions, integrals, and matrices
				-- can use multiple virtual lines instead of linear Unicode text.
				enabled = false,
			},

			win_options = {
				conceallevel = {
					rendered = 2,
				},
			},

			on = {
				render = function()
					require("nabla").enable_virt({ autogen = true })
				end,
				clear = function()
					require("nabla").disable_virt()
				end,
			},
		})

		vim.keymap.set("n", "<leader>mr", function()
			render_markdown.toggle()
		end, { desc = "Toggle markdown rendering" })
	end,
}
