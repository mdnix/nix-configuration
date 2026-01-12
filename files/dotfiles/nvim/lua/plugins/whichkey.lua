-- plugins/whichkey.lua

local wk = require("which-key")

wk.setup({
  preset = "modern",
  delay = 300,
  icons = {
    mappings = false,
  },
})

wk.add({
  -- Git (fugitive) - capital G
  { "<leader>G", group = "Git (fugitive)" },
  { "<leader>Ga", desc = "Git add file" },
  { "<leader>Gc", desc = "Git commit" },
  { "<leader>Gp", desc = "Git push" },
  { "<leader>Gl", desc = "Git pull" },
  { "<leader>Gs", desc = "Git status" },
  { "<leader>Gb", desc = "Git blame" },
  { "<leader>Gd", desc = "Git diff" },
  { "<leader>Gr", desc = "Git remove" },

  -- LSP (go to...)
  { "<leader>g", group = "LSP go to" },
  { "<leader>gd", desc = "Definition" },
  { "<leader>gr", desc = "References" },
  { "<leader>gi", desc = "Implementation" },
  { "<leader>gc", desc = "Incoming calls" },
  { "<leader>gn", desc = "Rename" },
  { "<leader>gs", desc = "Document symbols" },
  { "<leader>gw", desc = "Workspace symbols" },
  { "<leader>K", desc = "Hover docs" },
  { "<leader>sh", desc = "Signature help" },

  -- Diagnostics
  { "<leader>d", group = "Diagnostics/Delete" },
  { "<leader>dd", desc = "Show diagnostic" },
  { "<leader>dl", desc = "Diagnostic list" },
  { "]d", desc = "Next diagnostic" },
  { "[d", desc = "Prev diagnostic" },

  -- Tabs/Type
  { "<leader>t", group = "Tabs/Toggle/Type" },
  { "<leader>tn", desc = "New tab" },
  { "<leader>tc", desc = "Close tab" },
  { "<leader>td", desc = "Type definition" },
  { "<leader>tb", desc = "Toggle line blame" },

  -- Gitsigns (hunks)
  { "<leader>h", group = "Hunks/Split" },
  { "<leader>hs", desc = "Stage hunk" },
  { "<leader>hr", desc = "Reset hunk" },
  { "<leader>hS", desc = "Stage buffer" },
  { "<leader>hu", desc = "Undo stage hunk" },
  { "<leader>hR", desc = "Reset buffer" },
  { "<leader>hp", desc = "Preview hunk" },
  { "<leader>hb", desc = "Blame line" },
  { "<leader>hd", desc = "Diff this" },
  { "<leader>hD", desc = "Diff this ~" },
  { "<leader>hx", desc = "Toggle deleted" },
  { "]c", desc = "Next hunk" },
  { "[c", desc = "Previous hunk" },

  -- Harpoon
  { "<leader>a", desc = "Harpoon add" },
  { "<leader>e", desc = "Harpoon menu" },
  { "<leader>1", desc = "Harpoon 1" },
  { "<leader>2", desc = "Harpoon 2" },
  { "<leader>3", desc = "Harpoon 3" },
  { "<leader>4", desc = "Harpoon 4" },
  { "]h", desc = "Next harpoon" },
  { "[h", desc = "Prev harpoon" },

  -- Splits
  { "<leader>v", desc = "Vertical split" },
  { "<leader>cs", desc = "Close split" },
  { "<leader>+", desc = "Increase height" },
  { "<leader>-", desc = "Decrease height" },
  { "<leader><Right>", desc = "Increase width" },
  { "<leader><Left>", desc = "Decrease width" },

  -- Telescope
  { "<leader>f", desc = "Find files" },
  { "<leader>b", desc = "Buffers" },

  -- Buffers
  { "<leader>z", desc = "Previous buffer" },
  { "<leader>x", desc = "Next buffer" },
  { "<leader>c", desc = "Close buffer" },

  -- Clipboard
  { "<leader>y", desc = "Yank to clipboard" },
  { "<leader>p", desc = "Paste from clipboard" },

  -- Misc
  { "<leader>o", desc = "Open on GitHub" },
  { "<leader>pv", desc = "File explorer (Oil)" },
  { "-", desc = "Oil parent directory" },

  -- Ctrl mappings (splits)
  { "<C-h>", desc = "Left split" },
  { "<C-j>", desc = "Down split" },
  { "<C-k>", desc = "Up split" },
  { "<C-l>", desc = "Right split" },

  -- Alt mappings
  { "<A-j>", desc = "Move line down" },
  { "<A-k>", desc = "Move line up" },
})
