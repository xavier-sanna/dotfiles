-- define Space as leader key
vim.g.mapleader = " "

-- using keymap
local keymap = vim.keymap

-- quick escape insert mode
keymap.set('i', 'jk', '<ESC>', { desc='Exit insert mode' })

-- quick highlight search
keymap.set('n', '<C-l>', '<cmd>:nohl<CR>', { desc='Clear highlight search', silent=true, noremap=true })
