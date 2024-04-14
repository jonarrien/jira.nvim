local terminal = require('toggleterm.terminal').Terminal

local M = {}

M.interactive = function(command, opts)
  vim.notify(vim.inspect(command))
  opts = opts or {}
  local term = terminal:new({
    cmd = "jira " .. command,
    direction = opts.direction or "float",
    hidden = true
  })
  term:toggle()
  term:resize(40)
end

-- TODO: This is a WIP
-- M.list_issues = function(cmd, args, opts)
--   local output = vim.system({ "jira", "issue", "list" }, { text = true }):wait()
--   local user = vim.trim(output.stdout)
-- end

return M
