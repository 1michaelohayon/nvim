-- Save bind, in its own file required last in init.lua so nothing loaded
-- anywhere else (plugins, remap.lua, hebrew.lua) can steal <C-s> after this.
-- Save-feedback flash (green/red) is handled separately in saveflash.lua,
-- attached to the write event itself rather than this keybind.
vim.api.nvim_set_keymap('n', '<c-s>', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<c-s>', '<c-o>:w<CR>', {noremap = true, silent = true})
