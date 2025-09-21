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
        variant = "main",          -- "main" | "moon" | "dawn"
        dark_variant = "main",
        disable_background = true,        -- keep backgrounds enabled
        disable_float_background = true,  -- so we can set them to black
        disable_italics = false,
        highlight_groups = {
          -- core windows
          Normal          = { bg = "#000000" },
          NormalNC        = { bg = "#000000" },
          NormalFloat     = { bg = "#000000" },
          FloatBorder     = { bg = "#000000" },
          SignColumn      = { bg = "#000000" },
          LineNr          = { bg = "#000000" },
          CursorLine      = { bg = "#000000" },
          CursorLineNr    = { bg = "#000000" },

          -- popups/menus
          Pmenu           = { bg = "#000000" },
          PmenuSel        = { bg = "#111111" },
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
  {'airblade/vim-gitgutter'},
  {'tpope/vim-rhubarb'},

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
