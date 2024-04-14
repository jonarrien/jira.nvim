local api = require('jira.api')

vim.api.nvim_create_user_command("JiraEpics", function()
  api.epics({
    statuses = { "~Done" },
    order = "rank",
    args = "--reverse"
  })
end, {})

vim.api.nvim_create_user_command("JiraEpicsAll", function()
  api.epics({
    order = "rank",
    args = "--reverse"
  })
end, {})
