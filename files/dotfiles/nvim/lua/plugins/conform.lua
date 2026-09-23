-- plugins/conform.lua
--
-- Single owner for formatting. The nixd `formatting.command` setting was
-- removed from lua/plugins/lspconfig.lua so nixfmt is configured in one place.

-- Filetypes whose only formatter is prettier. Prettier will happily reformat a
-- whole file in a repo that has never used it, turning one save into a
-- 400-line diff. Manual-only via <leader>cf; everything else formats on save.
local manual_only = {
  javascript = true, javascriptreact = true,
  typescript = true, typescriptreact = true,
  json = true, jsonc = true, yaml = true, markdown = true,
}

require('conform').setup({
  formatters_by_ft = {
    nix  = { 'nixfmt' },
    go   = { 'goimports' },  -- superset of gofmt; from `gotools`
    rust = { 'rustfmt' },
    lua  = { 'stylua' },

    javascript      = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescript      = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    json            = { 'prettierd' },
    jsonc           = { 'prettierd' },
    yaml            = { 'prettierd' },
    markdown        = { 'prettierd' },

    -- Fallback for any filetype with no entry above. This replaces the old
    -- BufWritePre `%s/\s\+$//e` hook in autocommands.lua -- without the
    -- winsaveview dance, without stomping the search register, and without
    -- touching markdown (where two trailing spaces are a hard line break).
    ['_'] = { 'trim_whitespace' },
  },

  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return nil
    end
    if manual_only[vim.bo[bufnr].filetype] then
      return nil
    end
    return { timeout_ms = 1000, lsp_format = 'fallback' }
  end,
})

-- Escape hatch for repos that disagree with your formatter.
vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { bang = true, desc = 'Disable format-on-save (! = this buffer only)' })

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = 'Re-enable format-on-save' })
