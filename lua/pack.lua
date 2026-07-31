
vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-lua/plenary.nvim", -- required for telescope line above
	"https://www.github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/VonHeikemen/lsp-zero.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim", -- required for lsp zero
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*"), }, -- autocomplete window
  "https://github.com/karb94/neoscroll.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
	-- Language Server Protocols
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
  "https://github.com/folke/trouble.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rebelot/kanagawa.nvim",
  "https://github.com/nvim-zh/colorful-winsep.nvim",
})
