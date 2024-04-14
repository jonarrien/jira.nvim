local api = require('jira.api')

vim.api.nvim_create_user_command("JiraSprints", function()
  api.sprints({})
end, {})

vim.api.nvim_create_user_command("JiraSprintCurrent", function()
  api.sprints({ args = "--current" })
end, {})

vim.api.nvim_create_user_command("JiraSprintMine", function()
  api.sprints({ args = "--current -a$(jira me)" })
end, {})

vim.api.nvim_create_user_command("JiraSprintPrevious", function()
  api.sprints({ args = "--prev" })
end, {})

vim.api.nvim_create_user_command("JiraSprintNext", function()
  api.sprints({ args = "--next" })
end, {})

vim.api.nvim_create_user_command("JiraSprintFuture", function()
  api.sprints({ args = "--state future,active" })
end, {})

vim.api.nvim_create_user_command("JiraSprintAdd", function()
  -- zsh('jira sprint add')
end, {})
