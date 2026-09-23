-- plugins/textobjects.lua
--
-- Treesitter-aware text objects. This is the payoff for moving nvim-treesitter
-- to `main`: the parsers are already installed, this just adds queries and
-- keymaps on top of them.

require('nvim-treesitter-textobjects').setup({
  select = {
    -- Jump forward to the next function when the cursor is not inside one,
    -- rather than failing.
    lookahead = true,
  },
})

local select = require('nvim-treesitter-textobjects.select').select_textobject
local move = require('nvim-treesitter-textobjects.move')

-- letter -> treesitter query. `@class` is what the queries call a type
-- declaration, so `ic`/`ac` is a Go struct/interface or a Rust impl block.
local objects = {
  f = { query = '@function',  label = 'function'  },
  c = { query = '@class',     label = 'type'      },
  a = { query = '@parameter', label = 'argument'  },
}

for key, obj in pairs(objects) do
  for prefix, part in pairs({ i = '.inner', a = '.outer' }) do
    vim.keymap.set({ 'x', 'o' }, prefix .. key, function()
      select(obj.query .. part, 'textobjects')
    end, {
      desc = (prefix == 'i' and 'Inside ' or 'Around ') .. obj.label,
    })
  end
end

-- Jump between functions. ]f / [f rather than ]m, to match the `f` above.
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
  move.goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Next function' })

vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
  move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Previous function' })
