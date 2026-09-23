-- autocommands.lua

local augroup = vim.api.nvim_create_augroup

-- Trailing-whitespace trimming moved to conform.nvim. The ['_'] fallback entry
-- in lua/plugins/conform.lua runs trim_whitespace for every filetype without a
-- real formatter, which is what the old
--   BufWritePre  %s/\s\+$//e
-- hook did -- but without the winsaveview/winrestview dance, without stomping
-- the search register, and without touching markdown (where two trailing
-- spaces are a hard line break).

-- Briefly highlight yanked text, so <leader>y gives visible feedback.
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})
