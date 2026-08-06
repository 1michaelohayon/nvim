
vim.opt.termguicolors = true
require("options")
require("statusline")
require("autocmds")
require("plugins")
require("hebrew")
require("markdown")
require("remap") -- keep last to not get keys overwritten by plugins
require("save") -- keep absolute last: <C-s> always wins

setup_dynamic_statusline()


if vim.o.background == "dark" then
  vim.cmd.colorscheme("kanagawa-dragon")
else
  vim.cmd.colorscheme("kanagawa-lotus")
end


local function make_transparent()
  vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight NormalNC guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight NonText guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight LineNr guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight SignColumn guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight VertSplit guibg=NONE ctermbg=NONE]])
end
make_transparent()

