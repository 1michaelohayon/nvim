local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'gopls',
  'tsserver',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    sign_icons = {
    error = '',
    warn = '',
    hint = '',
    info = ''
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vw", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<F4>", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  
  vim.keymap.set("n", "<F3>", function() vim.lsp.buf.format() end, opts)
end)



lsp.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['lua_ls'] = {'lua'},
    ['gopls'] = {'go'},
  }
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
