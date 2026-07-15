-- file treesitter.lua
return {
	"nvim-treesitter/nvim-treesitter",

	branch = "main",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		local parsers = {
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
		}

		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- The current nvim-treesitter main branch uses install(), not the old
		-- ensure_install option. This keeps the LaTeX parser present for
		-- render-markdown's math handler.
		require("nvim-treesitter").install(parsers)

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
