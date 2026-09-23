-- keymaps.lua
--
-- Prefix scheme. Every <leader> key below is EITHER a bare mapping OR a group
-- prefix -- never both. That invariant is what removes the 1s timeoutlen
-- stalls on <leader>g / <leader>h / <leader>c / <leader>p, and the
-- <leader>dd-can-never-fire bug.
--
--   <leader>f*  find (telescope)   <leader>s*  splits
--   <leader>b*  buffers            <leader>t*  tabs
--   <leader>c*  code               <leader>g*  LSP (no built-in equivalent)
--   <leader>x*  trouble            <leader>G*  git (fugitive)
--   <leader>h*  git hunks -- buffer-local, see lua/plugins/gitsigns.lua
--
--   Bare, and their prefixes are kept empty on purpose:
--   <leader>d  black-hole delete operator     <leader>y / <leader>p  clipboard
--   <leader>u  undotree                       <leader>o  open line on GitHub
--   <leader>a / <leader>e / <leader>1..4      harpoon (plugins/harpoon.lua)
--
-- Deliberately NOT mapped -- Neovim 0.12 already provides these:
--   grn rename           grr references       gri implementation
--   gra code action      grt type definition  grx codelens
--   gO document symbols  K hover              i_CTRL-S signature help
--   ]d [d diagnostics    <C-W>d diagnostic float
--   ]b [b buffers        ]q [q quickfix       gc/gcc comment
--   -   oil parent dir (plugins/oil.lua)

local map = vim.keymap.set

--------------------------------------------------------------------- escape --
map('i', 'jj', '<Esc>', { desc = 'Escape' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Terminal: leave insert mode' })

--------------------------------------------------------------------- splits --
map('n', '<leader>sh', '<Cmd>split<CR>',  { desc = 'Split horizontal' })
map('n', '<leader>sv', '<Cmd>vsplit<CR>', { desc = 'Split vertical' })
map('n', '<leader>sc', '<Cmd>close<CR>',  { desc = 'Close split' })

map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

map('n', '<leader>+',       '<Cmd>resize +2<CR>',          { desc = 'Height +' })
map('n', '<leader>-',       '<Cmd>resize -2<CR>',          { desc = 'Height -' })
map('n', '<leader><Right>', '<Cmd>vertical resize +2<CR>', { desc = 'Width +' })
map('n', '<leader><Left>',  '<Cmd>vertical resize -2<CR>', { desc = 'Width -' })

-------------------------------------------------------------------- buffers --
map('n', '<leader>bd', '<Cmd>bdelete<CR>', { desc = 'Delete buffer' })

----------------------------------------------------------------------- tabs --
map('n', '<leader>tn', '<Cmd>tabnew<CR>',   { desc = 'New tab' })
map('n', '<leader>tc', '<Cmd>tabclose<CR>', { desc = 'Close tab' })

------------------------------------------------------------------ telescope --
map('n', '<leader>ff', '<Cmd>Telescope find_files<CR>',  { desc = 'Find files' })
map('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>',   { desc = 'Live grep' })
map('n', '<leader>fb', '<Cmd>Telescope buffers<CR>',     { desc = 'Buffers' })
map('n', '<leader>fr', '<Cmd>Telescope oldfiles<CR>',    { desc = 'Recent files' })
map('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>',   { desc = 'Help tags' })
map('n', '<leader>fd', '<Cmd>Telescope diagnostics<CR>', { desc = 'Diagnostics' })

------------------------------------------------------------------ registers --
-- No 'clipboard=unnamedplus' on purpose: yank/paste stay explicit.
map({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete to black hole' })
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
map('x', 'p', '"_dP', { desc = 'Paste over selection, keep register' })

--------------------------------------------------------------- text motions --
map('v', '<', '<gv', { desc = 'Dedent, keep selection' })
map('v', '>', '>gv', { desc = 'Indent, keep selection' })
map('n', 'J', 'mzJ`z',     { desc = 'Join lines, keep cursor' })
map('n', 'n', 'nzzzv',     { desc = 'Next match, centered' })
map('n', 'N', 'Nzzzv',     { desc = 'Prev match, centered' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down, centered' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up, centered' })

map('n', '<A-j>', '<Cmd>m .+1<CR>==', { silent = true, desc = 'Move line down' })
map('n', '<A-k>', '<Cmd>m .-2<CR>==', { silent = true, desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move selection up' })

------------------------------------------------------------------------ LSP --
-- Everything else is a 0.12 default (see header). These have none.
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto definition' })
map('n', '<leader>gc', vim.lsp.buf.incoming_calls,   { desc = 'Incoming calls' })
map('n', '<leader>go', vim.lsp.buf.outgoing_calls,   { desc = 'Outgoing calls' })
map('n', '<leader>gw', vim.lsp.buf.workspace_symbol, { desc = 'Workspace symbols' })

----------------------------------------------------------------------- code --
map({ 'n', 'v' }, '<leader>cf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer / selection' })

------------------------------------------------------------------- undotree --
map('n', '<leader>u', '<Cmd>UndotreeToggle<CR>', { desc = 'Undotree' })

-------------------------------------------------------------------- trouble --
map('n', '<leader>xx', '<Cmd>Trouble diagnostics toggle<CR>',
  { desc = 'Diagnostics (workspace)' })
map('n', '<leader>xX', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>',
  { desc = 'Diagnostics (buffer)' })
map('n', '<leader>xs', '<Cmd>Trouble symbols toggle<CR>', { desc = 'Symbols' })
map('n', '<leader>xq', '<Cmd>Trouble qflist toggle<CR>',  { desc = 'Quickfix list' })
map('n', '<leader>xl', '<Cmd>Trouble loclist toggle<CR>', { desc = 'Location list' })

--------------------------------------------------- git (fugitive / rhubarb) --
map('n', '<leader>Ga', '<Cmd>Gwrite<CR>',               { desc = 'Stage file' })
map('n', '<leader>Gc', '<Cmd>Git commit --verbose<CR>', { desc = 'Commit' })
map('n', '<leader>Gp', '<Cmd>Git push<CR>',             { desc = 'Push' })
map('n', '<leader>Gl', '<Cmd>Git pull<CR>',             { desc = 'Pull' })
map('n', '<leader>Gs', '<Cmd>Git<CR>',                  { desc = 'Status' })
map('n', '<leader>Gb', '<Cmd>Git blame<CR>',            { desc = 'Blame' })
map('n', '<leader>Gd', '<Cmd>Gvdiffsplit<CR>',          { desc = 'Diff split' })
map('n', '<leader>Gr', '<Cmd>GRemove<CR>',              { desc = 'Remove file' })
map('n', '<leader>o',  '<Cmd>.GBrowse<CR>',             { desc = 'Open line on GitHub' })

-- Completion keys (<CR> accept, <Tab>/<S-Tab> snippet jump, <C-Space> show,
-- <C-e> cancel, <C-n>/<C-p> select, <C-b>/<C-f> scroll docs) are bound by
-- blink.cmp's "enter" preset. They are NOT mapped here on purpose: this file
-- is required after lazy.setup(), so anything mapped here would override
-- blink and break the menu.
