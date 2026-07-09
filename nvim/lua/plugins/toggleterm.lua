-- file toggleterm.lua

return {
	"akinsho/toggleterm.nvim",

	version = "*",

	config = function()
		require("toggleterm").setup({
			size = 15,
			direction = "horizontal",
		})

		local Terminal = require("toggleterm.terminal").Terminal

		-- Current file directory
		vim.keymap.set("n", "<leader>tt", function()
			local cwd = vim.fn.expand("%:p:h")

			local term = Terminal:new({
				direction = "horizontal",
				dir = cwd,
				close_on_exit = false,
			})

			term:toggle()
		end, { desc = "Terminal (current file dir)" })

		-- Project root
		vim.keymap.set("n", "<leader>tT", function()
			local root = vim.fn.getcwd()

			local term = Terminal:new({
				direction = "tab",
				dir = root,
				close_on_exit = false,
			})

			term:toggle()
		end, { desc = "Terminal (project root)" })
	end,
}
