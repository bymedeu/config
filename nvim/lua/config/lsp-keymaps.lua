-- file lsp-keymaps.lua

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }

		-- Navigation
		vim.keymap.set(
			"n",
			"<leader>dd",
			vim.lsp.buf.definition,
			vim.tbl_extend("force", opts, { desc = "Go to definition" })
		)

		vim.keymap.set(
			"n",
			"<leader>dr",
			vim.lsp.buf.references,
			vim.tbl_extend("force", opts, { desc = "Find references" })
		)

		vim.keymap.set(
			"n",
			"<leader>dD",
			vim.lsp.buf.declaration,
			vim.tbl_extend("force", opts, { desc = "Go to declaration" })
		)

		vim.keymap.set(
			"n",
			"<leader>di",
			vim.lsp.buf.implementation,
			vim.tbl_extend("force", opts, { desc = "Go to implementation" })
		)

		vim.keymap.set("n", "K", function()
			-- Neovim combines hover results from all attached clients. Press K a
			-- second time to focus the window, scroll it normally, and press q to close.
			vim.lsp.buf.hover({
				border = "rounded",
				max_width = math.floor(vim.o.columns * 0.7),
				max_height = math.floor(vim.o.lines * 0.5),
				title = " Documentation ",
				title_pos = "center",
			})
		end, vim.tbl_extend("force", opts, { desc = "Show documentation" }))

		-- Refactoring
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

		vim.keymap.set(
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code actions" })
		)

		-- Diagnostics

		vim.keymap.set("n", "<leader>d[", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

		vim.keymap.set("n", "<leader>d]", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

		vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic details" })

		vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic list" })
	end,
})
