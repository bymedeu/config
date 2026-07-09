-- file conform.lua

return {
	"stevearc/conform.nvim",

	config = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 100,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				c = { "clang_format" },
				cpp = { "clang_format" },

				python = { "ruff_format" },

				lua = { "stylua" },

				javascript = { "prettier" },
				typescript = { "prettier" },

				sql = { "sql_formatter" },
			},
		})
	end,
}
