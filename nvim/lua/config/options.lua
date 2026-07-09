-- file options.lua

-- expose pyenv binaries (e.g. latex2text) to neovim
vim.env.PATH = "/home/amade/.pyenv/versions/3.12.9/bin:" .. vim.env.PATH

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
