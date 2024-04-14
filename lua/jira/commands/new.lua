local api = require('jira.api')
local config = require('jira.config')

-- NEW

vim.api.nvim_create_user_command("JiraNew", function()
  api.create()
end, {})

for _, issue_type in ipairs(config.issue_types) do
  vim.api.nvim_create_user_command("JiraNew" .. issue_type, function(params)
    api.create(issue_type, params.args)
  end, {})
end
