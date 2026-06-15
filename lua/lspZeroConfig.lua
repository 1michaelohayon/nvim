local lsp_zero = require('lsp-zero')

--------------------------------------------------------------------
-- LSP-ZERO
--------------------------------------------------------------------

lsp_zero.extend_lspconfig()

--------------------------------------------------------------------
-- MASON
--------------------------------------------------------------------

require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'ts_ls',
        'gopls',
        'jsonls',
        'yamlls',
        'pyright',
    },

    handlers = {
        lsp_zero.default_setup,
    },
})


--------------------------------------------------------------------
-- LSP ATTACH / KEYMAPS
--------------------------------------------------------------------

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    ----------------------------------------------------------------
    -- Navigation
    ----------------------------------------------------------------

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    ----------------------------------------------------------------
    -- Actions
    ----------------------------------------------------------------

    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    ----------------------------------------------------------------
    -- Diagnostics
    ----------------------------------------------------------------

    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

    ----------------------------------------------------------------
    -- Workspace
    ----------------------------------------------------------------

    vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)

    ----------------------------------------------------------------
    -- Signature Help
    ----------------------------------------------------------------

    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)

    ----------------------------------------------------------------
    -- Formatting
    ----------------------------------------------------------------

    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end)

--------------------------------------------------------------------
-- DIAGNOSTICS UI
--------------------------------------------------------------------

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

--------------------------------------------------------------------
-- SIGN ICONS
--------------------------------------------------------------------

lsp_zero.set_sign_icons({
    error = '✘',
    warn  = '▲',
    hint  = '⚑',
    info  = '»',
})
