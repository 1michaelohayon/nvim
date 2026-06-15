require("nvim-treesitter").setup({
  ensure_installed = {
    "go", "yaml", "json", "dockerfile",
    "javascript", "typescript", "c",
    "lua", "vim", "vimdoc", "query"
  },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  autotag = {
    enable = false,
  },
})
