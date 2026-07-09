-- file tokyonight.lua

return {
	"folke/tokyonight.nvim",

	priority = 1000,

	config = function()
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
