vim.g.mapleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lsp-keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    error("lazy.nvim not installed")
end


vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
