local terminal = require('toggleterm.terminal').Terminal

return function(command, opts)
  opts = opts or {}
  local term = terminal:new({
    cmd = "jira " .. command,
    direction = opts.direction or "float",
    hidden = true
  })
  term:toggle()
  term:resize(40)
end
