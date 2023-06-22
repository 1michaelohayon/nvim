

-- vim.opt.nu = true
-- vim.opt.rnu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.cursorline = true

vim.opt.laststatus=3

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- vim.api.nvim_set_option('statusline', vim.o.statusline .. [[%{&modified and '[Modified]' or '[Saved]'}]])
-- vim.o.statusline = vim.o.statusline .. '%{&modified and "[Modified]" or "[Saved]"}'


vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- vim.opt.colorcolumn = "80"


