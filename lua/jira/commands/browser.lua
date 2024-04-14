local api = require('jira.api')

-- Open jira in browser
vim.api.nvim_create_user_command("JiraOpenBrowser", function()
  api.open_browser()
end, {})
