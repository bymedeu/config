-- file treesitter.lua
return {
	"nvim-treesitter/nvim-treesitter",

	branch = "main",
	build = ":TSUpdate",

	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",

			ensure_install = {
				"cpp",
				"c",
				"lua",
				"python",
				"java",
				"javascript",
				"sql",
				"bash",
				"cmake",
				"vim",
				"vimdoc",
				"markdown",
				"markdown_inline",
				"latex",
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local filetype = vim.bo[args.buf].filetype

				local ok, parser = pcall(vim.treesitter.get_parser, args.buf, filetype)
				if not ok or not parser then
					return
				end

				vim.treesitter.start(args.buf)

				if filetype ~= "java" then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
