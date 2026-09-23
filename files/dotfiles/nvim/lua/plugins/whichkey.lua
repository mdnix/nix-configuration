-- plugins/whichkey.lua

require('which-key').setup({
  preset = 'modern',
  -- Must stay below 'timeoutlen' (400) or the mapping times out before the
  -- popup renders.
  delay = 250,
  icons = { mappings = false },
})

-- ONLY group labels live here.
--
-- The previous version restated a desc for every single mapping, which is how
-- <leader>g ended up labelled "LSP go to" while actually being a bare
-- :Telescope live_grep. which-key reads desc from each vim.keymap.set call
-- directly, so there is nothing left to keep in sync.
require('which-key').add({
  { '<leader>f', group = 'Find (telescope)' },
  { '<leader>s', group = 'Splits' },
  { '<leader>b', group = 'Buffers' },
  { '<leader>t', group = 'Tabs' },
  { '<leader>c', group = 'Code' },
  { '<leader>g', group = 'LSP' },
  { '<leader>h', group = 'Git hunks' },
  { '<leader>x', group = 'Trouble' },
  { '<leader>G', group = 'Git (fugitive)' },
  { '<leader>D', group = 'Debug (dap)' },
})
