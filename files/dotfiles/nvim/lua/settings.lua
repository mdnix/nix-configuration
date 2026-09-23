-- settings.lua

vim.g.mapleader = ' '

-- 1000ms (the default) was long enough that every multi-key <leader> sequence
-- felt stuck. See the prefix scheme in lua/keymaps.lua.
vim.opt.timeoutlen = 400
vim.opt.updatetime = 250

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'utf-8'
vim.opt.exrc = true
vim.opt.guicursor = 'a:block-blinkon1'
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.ruler = true
vim.cmd('highlight Normal guibg=none')

-- The LSP log had grown to 4.0 GB. It is a debugging tool, not telemetry.
vim.lsp.log.set_level('OFF')

-- Completion is blink.cmp (lua/plugins/init.lua). Neovim's own
-- 'autocomplete' is deliberately left off: two engines both driving the
-- popup fight each other.
