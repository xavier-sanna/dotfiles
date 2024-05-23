-- define Space as leader key
vim.g.mapleader = " "

-- quick escape insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- quick highlight search
vim.keymap.set("n", "<C-l>", "<cmd>:nohl<CR>", { desc = "Clear highlight search", silent = true, noremap = true })
