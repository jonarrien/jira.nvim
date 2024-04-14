local api = require('jira.api')

-- Show given jira identifier
vim.api.nvim_create_user_command("JiraView", function(params)
  if params.args == nil or params.args == "" then
    api.view(vim.g.JiraTicket)
  else
    api.view(vim.fn.expandcmd(params.args))
  end
end, { nargs = "*" })
