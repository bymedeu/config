-- file lsp.lua

return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason.nvim",
	},
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
		capabilities.textDocument.hover = capabilities.textDocument.hover or {}
		capabilities.textDocument.hover.contentFormat = { "markdown", "plaintext" }

		-- Let nvim-lspconfig launch JDT LS with a distinct workspace per project.
		-- Add Lombok support through the launcher's supported environment variable
		-- instead of replacing its command and losing that workspace isolation.
		local lombok = vim.fs.normalize(vim.fn.stdpath("data") .. "/../java/lombok.jar")
		if vim.uv.fs_stat(lombok) and not (vim.env.JDTLS_JVM_ARGS or ""):find(lombok, 1, true) then
			vim.env.JDTLS_JVM_ARGS = vim.trim((vim.env.JDTLS_JVM_ARGS or "") .. " -javaagent:" .. lombok)
		end

		local servers = {
			clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
				},
			},
			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly",
						},
					},
				},
			},
			lua_ls = {},
			bashls = {},
			jdtls = {
				init_options = {
					bundles = {},
				},
				settings = {
					java = {
						hover = {
							javadoc = {
								enabled = true,
							},
						},
						maven = {
							downloadSources = true,
						},
						eclipse = {
							downloadSources = true,
						},
						signatureHelp = {
							enabled = true,
							description = {
								enabled = true,
							},
						},
					},
				},
			},
			sqls = {},
			ts_ls = {},
			ada_ls = {},

			neocmake = {
				root_markers = { "CMakeLists.txt", ".neocmake.toml", ".git", "build", "cmake" },
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
