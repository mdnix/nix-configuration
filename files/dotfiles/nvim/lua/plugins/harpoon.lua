local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<Leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Quick select with Leader + number
vim.keymap.set("n", "<Leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<Leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<Leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<Leader>4", function() harpoon:list():select(4) end)

-- Navigate harpoon list
vim.keymap.set("n", "[h", function() harpoon:list():prev() end)
vim.keymap.set("n", "]h", function() harpoon:list():next() end)

