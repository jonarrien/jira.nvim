local api = require('jira.api')

-- Start Jira ticket and store identifier in session
vim.api.nvim_create_user_command("JiraStart", function()
  vim.ui.input({ prompt = "Jira Issue: " }, function(input)
    if input == nil or input == "" then return end
    vim.g.JiraTicket = input
  end)
end, {})
