-- autocommands.lua

-- Clear trailing whitespace on save
local function trim_trailing_whitespace()
  local save = vim.fn.winsaveview()
  vim.cmd('%s/\\s\\+$//e')
  vim.fn.winrestview(save)
end

vim.api.nvim_create_augroup('TrimWhitespace', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'TrimWhitespace',
  pattern = '*',
  callback = trim_trailing_whitespace,
})
