-- plugins/init.lua

require('lazy').setup({
  -- Styling
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "main",
        dark_variant = "main",
        disable_background = true,
        disable_float_background = true,
        disable_italics = false,
        highlight_groups = {
          -- core windows
          Normal          = { bg = "#131313" },
          NormalNC        = { bg = "#131313" },
          NormalFloat     = { bg = "#131313" },
          FloatBorder     = { bg = "#131313" },
          SignColumn      = { bg = "#131313" },
          LineNr          = { bg = "#131313" },
          CursorLine      = { bg = "#1a1a1a" },
          CursorLineNr    = { bg = "#131313" },
          -- popups/menus
          Pmenu           = { bg = "#131313" },
          PmenuSel        = { bg = "#1e1e1e" },
        },
      })
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  -- Airline --
  {'vim-airline/vim-airline'},
  {'vim-airline/vim-airline-themes'},


  -- Centered editing --
  {'shortcuts/no-neck-pain.nvim', version = '*'},

  -- Todo comment highlighting
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Git
  {'tpope/vim-fugitive'},
  {'tpope/vim-rhubarb'},
  {'lewis6991/gitsigns.nvim'},

  -- Which-key (keybinding popup)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },

  -- Noice (pretty cmdline, messages, notifications)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- Alpha (dashboard/startup screen)
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Oil (file explorer as buffer)
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Fuzzy finder
  {'nvim-lua/plenary.nvim'},
  {'nvim-telescope/telescope.nvim'},
  {'BurntSushi/ripgrep'},

  -- Treesitter
  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- Neovim LSP Config
  {'neovim/nvim-lspconfig'},

  -- LSP autocomplete
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},

  -- Snippets
  {'L3MON4D3/LuaSnip'},
  {'saadparwaiz1/cmp_luasnip'},

  -- Go Bundle
  {'fatih/vim-go', build = ':GoInstallBinaries'},

  -- Rust
  {'rust-lang/rust.vim'},
})

-- Load plugin configurations
require('plugins.airline')
require('plugins.vimgo')
require('plugins.treesitter')
require('plugins.lspconfig')
require('plugins.cmp')
require('plugins.harpoon')
require('plugins.whichkey')
require('plugins.oil')
require('plugins.gitsigns')
require('plugins.noice')
require('plugins.alpha')
