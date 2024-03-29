local builtin = require('telescope.builtin')
require('telescope').setup{
    defaults = {
        layout_strategy = "horizontal",
        layout_config = {
            prompt_position = "bottom",
            preview_cutoff = 70,
        },
    },
}

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

vim.keymap.set('n', 'gr', builtin.lsp_references, {})

--vim.api.nvim_exec([[
--  au VimEnter * Telescope find_files
--]], false)




