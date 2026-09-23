-- plugins/treesitter.lua
--
-- nvim-treesitter `main`. This is a full, INCOMPATIBLE rewrite of `master`:
-- there is no `nvim-treesitter.configs`, no `ensure_installed`, no
-- `highlight.enable`. The plugin now only ships parsers + queries; the
-- features (highlight / fold / inject) belong to Neovim.
--
-- Requires the tree-sitter CLI (>= 0.26.1), curl, tar and a C compiler.
-- Every install/:TSUpdate shells out to `tree-sitter build`.

require('nvim-treesitter').install({
  -- carried over from the old ensure_installed
  'bash', 'go', 'graphql', 'javascript', 'json', 'jsonnet', 'rust',
  'typescript', 'tsx', 'yaml', 'toml',
  -- go tooling filetypes vim-go used to colour
  'gomod', 'gosum', 'gowork',
  -- this repo is a Nix flake and the editor config is Lua: both were missing
  'nix', 'lua', 'luadoc',
  -- needed by lazy.nvim / noice / :checkhealth rendering
  'markdown', 'markdown_inline', 'vim', 'vimdoc', 'query',
  'zig', 'diff', 'gitcommit', 'regex',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_enable', { clear = true }),
  callback = function(ev)
    -- Every step here can fail on a buffer that is not a real file. Plugins
    -- set `filetype` on scratch buffers to get syntax in their own windows,
    -- which fires this, and vim.treesitter.start() is
    --   local parser = assert(M.get_parser(buf, lang))
    -- i.e. it asserts rather than returning nil when it cannot build a parser
    -- for that buffer. So guard the buffer, then pcall the start itself: a
    -- buffer that cannot be parsed should go unhighlighted, never raise.
    if not vim.api.nvim_buf_is_loaded(ev.buf) then
      return
    end

    -- Resolve filetype -> parser language. Doing it this way handles the
    -- mismatches for free (the `bash` parser serves filetype `sh`, etc.)
    -- instead of hand-maintaining a pattern list.
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then
      return
    end

    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- Treesitter indent is still flagged EXPERIMENTAL upstream and is shaky
    -- for go/yaml. Left off; 'smartindent' already handles it.
  end,
})

-- Folds are now always available; don't open every file fully folded.
vim.o.foldlevelstart = 99
