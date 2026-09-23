-- plugins/dap.lua
--
-- Debugging. The adapter is delve, which comes from
-- modules/profiles/development.nix -- nvim-dap-go finds it on PATH, so there
-- is no mason bridge and nothing is downloaded.
--
-- Keymaps live under <leader>D, NOT <leader>d: <leader>d is the black-hole
-- delete operator in lua/keymaps.lua, and making it a prefix as well is
-- exactly the collision this config was cleaned up to remove. <leader>D
-- mirrors <leader>G for fugitive.

local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

-- Sensible default: delve for Go, configured from the launch templates
-- nvim-dap-go ships (debug file, debug test, attach).
require('dap-go').setup()

-- Open the UI when a session starts, close it when it ends. Without this the
-- panes have to be toggled by hand every time.
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

local map = vim.keymap.set

map('n', '<leader>Db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
map('n', '<leader>DB', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Conditional breakpoint' })

map('n', '<leader>Dc', dap.continue,  { desc = 'Continue / start' })
map('n', '<leader>Di', dap.step_into, { desc = 'Step into' })
map('n', '<leader>Do', dap.step_over, { desc = 'Step over' })
map('n', '<leader>DO', dap.step_out,  { desc = 'Step out' })
map('n', '<leader>Dl', dap.run_last,  { desc = 'Run last' })
map('n', '<leader>Dr', dap.repl.toggle, { desc = 'Toggle REPL' })
map('n', '<leader>Du', dapui.toggle,  { desc = 'Toggle debug UI' })

map('n', '<leader>Dt', function()
  dap.terminate()
  dapui.close()
end, { desc = 'Terminate session' })

-- Go-specific: debug the test function under the cursor.
map('n', '<leader>DT', function() require('dap-go').debug_test() end,
  { desc = 'Debug nearest Go test' })
