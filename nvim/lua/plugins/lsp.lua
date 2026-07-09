-- file lsp.lua

return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local servers = {
			clangd = {},
			pyright = {},
			lua_ls = {},
			bashls = {},
			jdtls = {
				cmd = {
					vim.fn.stdpath("data") .. "/mason/bin/jdtls",
					"--jvm-arg=-javaagent:" .. vim.fn.expand("~/.local/share/java/lombok.jar"),
				},
				init_options = {
					bundles = {},
				},

				settings = {
					java = {
						hover = {
							enabled = true,
						},
						contentProvider = {
							preferred = "fernflower",
						},
					},
				},
			},
			sqls = {},
			ts_ls = {},
			ada_language_server = {},

			cmake = {
				cmd = { "cmake-language-server" },
				filetypes = { "cmake" },
			},

			ruff = {
				cmd = { "ruff", "server" },
				filetypes = { "python" },
			},
		}

		for name, opts in pairs(servers) do
			opts.capabilities = capabilities

			vim.lsp.config(name, opts)
			vim.lsp.enable(name)
		end
	end,
}
