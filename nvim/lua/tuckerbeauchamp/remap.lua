-- Description: Remap keys
-- Author: Tucker Beauchamp
-- Set mapleader to space
vim.g.mapleader = " "

-- Allow highlighted text to be moved with J and K in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- When moving up and down a page. Place cursor in middle of page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Allow copy into system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Prevent Q from putting us in Ex mode
vim.keymap.set("n", "Q", "<nop>")

-- Shortcut for find and replace for current word you are on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Create tab
vim.api.nvim_set_keymap("n", "<Leader>t", ":tabnew<CR>", { noremap = true, silent = true })
