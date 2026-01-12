-- keymaps.lua

-- Remap jj to ESC
vim.keymap.set('i', 'jj', '<ESC>')

-- File explorer (Oil)
vim.keymap.set('n', '<Leader>pv', '<CMD>Oil<CR>')

-- Split windows
vim.keymap.set('n', '<Leader>h', ':split<CR>')
vim.keymap.set('n', '<Leader>v', ':vsplit<CR>')
vim.keymap.set('n', '<Leader>cs', ':close<CR>')

-- Resize splits using Leader key
vim.keymap.set('n', '<Leader>+', ':resize +2<CR>')
vim.keymap.set('n', '<Leader>-', ':resize -2<CR>')
vim.keymap.set('n', '<Leader><Right>', ':vertical resize +2<CR>')
vim.keymap.set('n', '<Leader><Left>', ':vertical resize -2<CR>')

-- Git commands (fugitive) - capital G to avoid LSP conflicts
vim.keymap.set('n', '<Leader>Ga', ':Gwrite<CR>')
vim.keymap.set('n', '<Leader>Gc', ':Git commit --verbose<CR>')
vim.keymap.set('n', '<Leader>Gp', ':Git push<CR>')
vim.keymap.set('n', '<Leader>Gl', ':Git pull<CR>')
vim.keymap.set('n', '<Leader>Gs', ':Git<CR>')
vim.keymap.set('n', '<Leader>Gb', ':Git blame<CR>')
vim.keymap.set('n', '<Leader>Gd', ':Gvdiffsplit<CR>')
vim.keymap.set('n', '<Leader>Gr', ':GRemove<CR>')

-- Navigate splits
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Dont put deleted into register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Yank to system clipboard
vim.keymap.set({'n', 'v'}, '<Leader>y', '"+y')
vim.keymap.set({'n', 'v'}, '<Leader>p', '"+p')

-- Move current line or selected lines up or down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true })

-- Buffer navigation
vim.keymap.set('n', '<Leader>z', ':bp<CR>')
vim.keymap.set('n', '<Leader>x', ':bn<CR>')
vim.keymap.set('n', '<Leader>c', ':bd<CR>')

-- Tabs (use gt/gT for next/prev, they're built-in)
vim.keymap.set('n', '<Leader>tn', ':tabnew<CR>')
vim.keymap.set('n', '<Leader>tc', ':tabclose<CR>')

-- Open current line on GitHub
vim.keymap.set('n', '<Leader>o', ':.GBrowse<CR>')

-- Autocomplete pairs
vim.keymap.set('i', '{', '{}<Esc>ha')
vim.keymap.set('i', '(', '()<Esc>ha')
vim.keymap.set('i', '[', '[]<Esc>ha')
vim.keymap.set('i', '"', '""<Esc>ha')
vim.keymap.set('i', "'", "''<Esc>ha")
vim.keymap.set('i', '`', '``<Esc>ha')

-- Telescope
vim.keymap.set('n', '<Leader>f', ':Telescope find_files<CR>')
vim.keymap.set('n', '<Leader>g', ':Telescope live_grep<CR>')
vim.keymap.set('n', '<Leader>b', ':Telescope buffers<CR>')

-- Diagnostics
vim.keymap.set('n', '<Leader>dd', vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set('n', '<Leader>dl', vim.diagnostic.setloclist, { desc = "Diagnostic list" })

-- LSP Keymaps
vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<Leader>sh', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<Leader>K', vim.lsp.buf.hover)
vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation)
vim.keymap.set('n', '<Leader>gc', vim.lsp.buf.incoming_calls)
vim.keymap.set('n', '<Leader>td', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<Leader>gr', vim.lsp.buf.references)
vim.keymap.set('n', '<Leader>gn', vim.lsp.buf.rename)
vim.keymap.set('n', '<Leader>gs', vim.lsp.buf.document_symbol)
vim.keymap.set('n', '<Leader>gw', vim.lsp.buf.workspace_symbol)
