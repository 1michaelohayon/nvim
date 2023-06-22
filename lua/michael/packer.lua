-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    ---------------
    use "rebelot/kanagawa.nvim"
    use {
        "phha/zenburn.nvim",
        config = function() require("zenburn").setup() end
    }
    use({ 'rose-pine/neovim', as = 'rose-pine' })

    ---------------
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    use('nvim-treesitter/playground')

    ---------------
    use("ThePrimeagen/harpoon")
    ---------------
    use('mbbill/undotree')
    ---------------
    use('tpope/vim-fugitive')
    ---------------
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    ---------------
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    ---------------
    ---------------
    use 'nvim-tree/nvim-web-devicons'
    ---------------
    use 'norcalli/nvim-colorizer.lua'
    ---------------
    use 'windwp/nvim-ts-autotag'
    ---------------
    ---------------
    use 'karb94/neoscroll.nvim'
    require('neoscroll').setup()
    ---------------
    ---------------
    ---------------
    use 'echasnovski/mini.files'

    ---------------
    ---------------
---------------

end)
