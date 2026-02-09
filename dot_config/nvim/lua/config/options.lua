-- colors
vim.opt.termguicolors = true

-- cursor
vim.opt.cursorline = true

-- enable line number and relative line number
vim.opt.number = true
vim.opt.relativenumber = true

-- width of a tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- use number of spaces to insert a <Tab>
vim.opt.expandtab = true

-- search options
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- text options
vim.opt.wrap = false

-- undo/history
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.history = 10000

-- UI
vim.opt.signcolumn = "yes"

-- clipboard
if vim.env.WAYLAND_DISPLAY
    and vim.fn.executable("wl-copy") == 1
    and vim.fn.executable("wl-paste") == 1
then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy --type text/plain",
      ["*"] = "wl-copy --type text/plain --primary",
    },
    paste = {
      ["+"] = "wl-paste --no-newline",
      ["*"] = "wl-paste --no-newline --primary",
    },
    cache_enabled = 0,
  }
end

vim.opt.clipboard:append("unnamedplus")

-- spelling
-- vim.opt.spell = true
-- vim.opt.spelllang = 'en_us'
