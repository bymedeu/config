-- file whichkey.lua

return {
	"folke/which-key.nvim",

	config = function()
		require("which-key").setup()

		require("which-key").add({
			{ "<leader>f", group = "Finder commands" },
			{ "<leader>c", group = "Code" },
			{ "<leader>d", group = "Diagnostics" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Harpoon" },
			{ "<leader>w", group = "Window" },
			{ "<leader>t", group = "Tabs & Term" },
		})
	end,
}
