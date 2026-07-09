-- file neotree.lua

return {
	"nvim-neo-tree/neo-tree.nvim",

	branch = "v3.x",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},

	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,

			window = {
				width = 35,

				mappings = {
					["O"] = "expand_all_nodes",
				},
			},

			filesystem = {
				follow_current_file = {
					enabled = true,
				},

				group_empty_dirs = true,
			},
		})
	end,
}
