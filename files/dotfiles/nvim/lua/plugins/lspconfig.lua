-- plugins/lspconfig.lua

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('gopls', {
  capabilities = capabilities,
  cmd = {"gopls", "serve"},
  filetypes = {"go", "gomod", "gowork"},
  root_markers = {"go.work", "go.mod", ".git"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unreachable = true,
      },
      staticcheck = true,
    },
  },
})

vim.lsp.config('nixd', {
  capabilities = capabilities,
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

vim.lsp.config('zls', {
  capabilities = capabilities,
  cmd = {"zls"},
  filetypes = {"zig", "zir"},
  root_markers = {"zls.json", "build.zig", ".git"},
})

-- Enable the LSP servers
vim.lsp.enable({'gopls', 'nixd', 'zls'})
