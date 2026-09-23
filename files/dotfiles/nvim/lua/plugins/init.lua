-- plugins/init.lua

require('lazy').setup({
  -- Styling
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- "hard" + "material" is the pair that yields the #1d2021 / #d4be98 in
      -- modules/theme/palette.nix, so the editor matches the terminal it
      -- runs in.
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_transparent_background = 1
      vim.cmd.colorscheme("gruvbox-material")
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

  -- Treesitter -- `main` branch. The `master` branch was archived 2025-05-18
  -- and its query_predicates.lua stubs `make-range!` as a no-op, which breaks
  -- against the nvim 0.12 treesitter runtime. `main` is an incompatible
  -- rewrite: it only installs parsers/queries, and does NOT lazy-load.
  -- Needs the tree-sitter CLI from modules/profiles/development.nix.
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
  },

  -- Treesitter text objects: vif/vaf (function), vic/vac (type),
  -- via/vaa (argument). MUST track `main` like nvim-treesitter itself --
  -- the two rewrites share a runtime, and the `master` version of this
  -- plugin will not load against `main`.
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  -- Sticky header showing which function/block the cursor is inside.
  -- Uses Neovim's own treesitter API, so it is unaffected by the
  -- master/main split.
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = { max_lines = 3, multiline_threshold = 1 },
  },

  -- Debugging. delve comes from modules/profiles/development.nix, so there
  -- is no mason bridge here.
  { 'mfussenegger/nvim-dap' },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
  },
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = { 'mfussenegger/nvim-dap' },
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- Neovim LSP Config
  {'neovim/nvim-lspconfig'},

  -- Completion. blink registers its own LSP capabilities onto
  -- vim.lsp.config('*') from its plugin/ file, so there is deliberately no
  -- capabilities wiring in lspconfig.lua.
  {
    'saghen/blink.cmp',
    -- v2 on `main` is an in-progress breaking rewrite; upstream says pin v1.
    version = '1.*',
    -- CmdlineEnter matters: without it blink never loads when you press `:`,
    -- so cmdline completion simply would not appear.
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      -- "default" accepts with <C-y> and leaves <CR> unbound. "enter" makes
      -- <CR> accept. Either way blink binds <CR>/<Tab>/<S-Tab>/<C-Space>/
      -- <C-e> itself -- do NOT map those in keymaps.lua, which loads after
      -- lazy.setup() and would win.
      keymap = { preset = 'enter' },
      -- The Rust matcher ships as a downloaded prebuilt binary, which does
      -- not fit a nix-managed setup. Lua is fast enough and always works.
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
      sources = {
        -- blink's default also includes 'snippets'; LSP-provided snippets
        -- still arrive through the 'lsp' source. The 'lsp' provider has
        -- fallbacks = { 'buffer' } by default, so buffer words only appear
        -- when the LSP returns nothing -- the two-tier behaviour nvim-cmp had.
        default = { 'lsp', 'path', 'buffer' },
        -- Don't open the menu until 3 characters of a word are typed.
        -- Bypassed for trigger characters and manual <C-Space>, so `fmt.`
        -- still completes instantly. See sources/lib/provider: the global
        -- minimum is skipped when trigger kind is 'trigger_character' or
        -- 'manual'.
        min_keyword_length = 3,
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
        menu = { max_height = 12 },
      },
      cmdline = {
        -- blink enables cmdline completion by default, but its auto_show
        -- default only fires inside the command window, so the list stays
        -- hidden until <Tab>. Show it as you type instead, but keep it
        -- advisory: nothing is put on the line until <Tab> or <C-y>.
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = false, auto_insert = false } },
        },
      },
    },
  },

  -- Lua LSP support: Neovim API types + on-demand plugin sources for lua_ls
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- Formatting. Single owner for nixfmt / goimports / rustfmt / stylua /
  -- prettierd, and replaces the BufWritePre whitespace regex.
  {'stevearc/conform.nvim'},

  -- Linting (golangci-lint)
  {'mfussenegger/nvim-lint'},

  -- Diagnostics / quickfix UI
  {'folke/trouble.nvim', cmd = 'Trouble', opts = {}},

  -- Editing primitives. mini.pairs replaces the hand-rolled autopairs maps
  -- that turned don't into don''t.
  {'echasnovski/mini.pairs',    version = '*', opts = {}},
  {'echasnovski/mini.surround', version = '*', opts = {}},

  -- Undo history browser ('undofile'/'undodir' were set with no way to browse)
  {'mbbill/undotree', cmd = {'UndotreeToggle', 'UndotreeShow'}},
})

-- Load plugin configurations
require('plugins.airline')
require('plugins.treesitter')
require('plugins.lspconfig')
require('plugins.harpoon')
require('plugins.whichkey')
require('plugins.oil')
require('plugins.gitsigns')
require('plugins.noice')
require('plugins.alpha')
require('plugins.conform')
require('plugins.lint')
require('plugins.textobjects')
require('plugins.dap')
