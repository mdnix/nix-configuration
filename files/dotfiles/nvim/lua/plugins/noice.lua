-- plugins/noice.lua

require("noice").setup({
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    format = {
      cmdline = { icon = ":" },
      search_down = { icon = "/" },
      search_up = { icon = "?" },
      filter = { icon = "$" },
      lua = { icon = "lua" },
      help = { icon = "?" },
    },
  },
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
  },
  popupmenu = {
    enabled = true,
    backend = "nui",
  },
  notify = {
    enabled = true,
    view = "notify",
  },
  lsp = {
    progress = {
      enabled = true,
    },
    hover = {
      enabled = false, -- using built-in
    },
    signature = {
      enabled = false, -- using built-in
    },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
})

-- nvim-notify config
require("notify").setup({
  background_colour = "#131313",
  timeout = 3000,
  max_width = 80,
})
