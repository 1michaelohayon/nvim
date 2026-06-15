require("blink.cmp").setup({
keymap = {
  preset = "none",

  ["<C-Space>"] = { "show", "hide" },

  ["<CR>"] = { "accept", "fallback" },
  ["<Tab>"] = { "accept", "fallback" },  -- ONLY accept

  ["<C-j>"] = { "select_next", "fallback" },
  ["<C-k>"] = { "select_prev", "fallback" },

  ["<C-n>"] = { "select_next", "fallback" },
  ["<C-p>"] = { "select_prev", "fallback" },

  ["<Down>"] = { "select_next", "fallback" },
  ["<Up>"] = { "select_prev", "fallback" },
},
  appearance = { nerd_font_variant = "mono" },
  completion = { menu = { auto_show = true } },
  sources = { default = { "lsp", "path", "buffer", "snippets" } },
  snippets = {
    expand = function(snippet)
      require("luasnip").lsp_expand(snippet)
    end,
  },
  fuzzy = {
    implementation = "prefer_rust",
    prebuilt_binaries = { download = true },
  },
})

vim.lsp.config["*"] = {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
}
