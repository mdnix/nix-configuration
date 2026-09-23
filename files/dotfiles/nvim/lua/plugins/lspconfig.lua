-- plugins/lspconfig.lua

vim.lsp.config('gopls', {
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

-- nixd needs no local config: nvim-lspconfig ships lsp/nixd.lua, and nix
-- formatting is owned by conform.nvim (nixfmt). The old
-- settings.nixd.formatting.command pointed at a binary that was not installed
-- anywhere, and would have been a second formatter for the same buffer.

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      -- Do NOT set Lua.workspace.library here: lazydev.nvim owns it and
      -- injects the Neovim runtime plus lazy plugin sources on demand.
      workspace = { checkThirdParty = false },
      format = { enable = false },  -- stylua via conform is the single owner
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('zls', {
  cmd = {"zls"},
  filetypes = {"zig", "zir"},
  root_markers = {"zls.json", "build.zig", ".git"},
})

vim.lsp.config('rust_analyzer', {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      check = {
        command = "clippy",
      },
      diagnostics = {
        enable = true,
      },
      procMacro = {
        enable = true,
      },
      inlayHints = {
        enable = true,
      },
    },
  },
})
-- Enable the LSP servers
vim.lsp.enable({ 'gopls', 'nixd', 'zls', 'rust_analyzer', 'lua_ls' })
