-- Save bind, in its own file required last in init.lua so nothing loaded
-- anywhere else (plugins, remap.lua, hebrew.lua) can steal <C-s> after this.
vim.api.nvim_set_keymap('n', '<c-s>', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<c-s>', '<c-o>:w<CR>', {noremap = true, silent = true})
