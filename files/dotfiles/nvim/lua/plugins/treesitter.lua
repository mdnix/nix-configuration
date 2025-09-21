-- plugins/treesitter.lua

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'go', 'rust', 'yaml', 'json', 'graphql', 'typescript', 'javascript', 'bash', 'jsonnet' },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
