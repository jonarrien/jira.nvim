local api = require('jira.api')

-- Edit given jira identifier
vim.api.nvim_create_user_command("JiraEdit", function(params)
  if params.args == nil or params.args == "" then
    api.edit(vim.g.JiraTicket)
  else
    api.edit(vim.fn.expandcmd(params.args))
  end
end, { nargs = "*" })
