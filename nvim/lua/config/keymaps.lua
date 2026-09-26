-- file keymaps.lua

-- Copy a mouse selection to the system clipboard as soon as the button is
-- released. Drag events have already positioned the end of the selection, so
-- replaying <LeftRelease> here would collapse it before the yank.
vim.keymap.set("x", "<LeftRelease>", '"+y', { remap = false, silent = true, desc = "Copy mouse selection" })

vim.keymap.set("n", "<leader>e", function()
	vim.cmd("Neotree focus")
end, { desc = "Open file tree" })

vim.keymap.set("n", "<leader>E", function()
	vim.cmd("Neotree close")
end, { desc = "Close file tree" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({
		lsp_fallback = true,
	})
end, { desc = "Format file" })

-- Window

vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Left window" })

vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Lower window" })

vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Upper window" })

vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Right window" })

vim.keymap.set("n", "<leader>wo", "<C-w>p", { desc = "Other window" })

vim.keymap.set("n", "<leader>wq", "<cmd>q<CR>", { desc = "Close window" })

vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

vim.keymap.set("n", "<leader>wc", "<C-w>c", { desc = "Close split" })

vim.keymap.set("n", "<leader>ww", "<cmd>w<CR>", { desc = "Save" })

vim.keymap.set("n", "<leader>wx", "<cmd>x<CR>", { desc = "Save and close" })

vim.keymap.set("n", "<leader>wr", "<C-w>r", { desc = "Rotate windows" })

-- Splits

vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Horizontal split" })

vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })

-- Tabs

vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })

vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "Close tab" })

vim.keymap.set("n", "<leader>th", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

vim.keymap.set("n", "<leader>tl", "<cmd>tabnext<CR>", { desc = "Next tab" })

vim.keymap.set("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close other tabs" })

-- move windows

vim.keymap.set("n", "<leader>wMk", "<C-w>K", { desc = "Move window top" })
vim.keymap.set("n", "<leader>wMj", "<C-w>J", { desc = "Move window bottom" })
vim.keymap.set("n", "<leader>wMh", "<C-w>H", { desc = "Move window left" })
vim.keymap.set("n", "<leader>wMl", "<C-w>L", { desc = "Move window right" })
vim.keymap.set("n", "<leader>wMt", "<C-w>T", { desc = "Move window to tab" })
vim.keymap.set("t", "<leader>wMk", [[<C-\><C-n><C-w>K]], { desc = "Move terminal top" })
vim.keymap.set("t", "<leader>wMj", [[<C-\><C-n><C-w>J]], { desc = "Move terminal bottom" })
vim.keymap.set("t", "<leader>wMh", [[<C-\><C-n><C-w>H]], { desc = "Move terminal left" })
vim.keymap.set("t", "<leader>wMl", [[<C-\><C-n><C-w>L]], { desc = "Move terminal right" })
vim.keymap.set("t", "<leader>wMt", [[<C-\><C-n><C-w>T]], { desc = "Move terminal to tab" })
