-- plugins/lint.lua

local lint = require('lint')

lint.linters_by_ft = {
  go = { 'golangcilint' },
}

-- golangci-lint here is v2.x, which REMOVED `--out-format` (JSON is now
-- `--output.json.path=stdout`). If :messages shows an unknown-flag error after
-- a save, nvim-lint's bundled args are still on v1 -- uncomment:
--
-- lint.linters.golangcilint.args = {
--   'run', '--output.json.path=stdout',
--   '--issues-exit-code=0', '--show-stats=false',
-- }

-- BufWritePost only: golangci-lint type-checks the whole package and must
-- never sit on the typing path.
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('nvim_lint', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
