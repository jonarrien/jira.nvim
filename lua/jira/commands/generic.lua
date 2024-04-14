local api = require('jira.api')

-- Run any Jira subcommand with arguments
vim.api.nvim_create_user_command("Jira", function(params)
  api.run(params.args)
end, { nargs = "*", bang = true, complete = "file" })
