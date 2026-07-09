-- file gitsigns.lua

return {
	"lewis6991/gitsigns.nvim",

	config = function()
		local gs = require("gitsigns")

		require("gitsigns").setup({
			current_line_blame_opts = {
				delay = 100,
			},
		})

		vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next git hunk" })

		vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Previous git hunk" })

		vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview git hunk" })

		vim.keymap.set("n", "<leader>gb", gs.blame_line, { desc = "Git blame line" })

		vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset git hunk" })

		vim.keymap.set("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle inline git blame" })
	end,
}
