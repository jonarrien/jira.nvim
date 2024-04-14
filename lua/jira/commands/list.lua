local api    = require('jira.api')
local config = require('jira.config')

-- local cmds   = {
--   epic  = {
--     done = "jira issue list -tEpic -sDone"
--   },
--   issue = {
--     mine    = "jira issue list -s~Done --order-by rank --reverse -a $(jira me)",
--     list    = "jira issue list -s~Done --order-by priority --paginate 100",
--     todo    = "jira issue list -s 'To Do'",
--     history = "jira issue list --history",
--     view    = "jira issue view ISSUE-1 --comments 5",
--   },
-- }

-- List all issues
vim.api.nvim_create_user_command("JiraIssueListAll", function()
  api.list_issues({ types = { "~Epic" } })
end, {})

-- By status
for _, status in ipairs(config.statuses) do
  local shortened = status:gsub("%s+", "")
  vim.api.nvim_create_user_command("JiraIssueList" .. shortened, function()
    api.list_issues({ statuses = { status } })
  end, {})
end

-- List issues without status "Done" or "Cancelled"
vim.api.nvim_create_user_command("JiraIssueListPending", function()
  api.list_issues({ statuses = { "~Done", "~Cancelled" }, types = { "~Epic" } })
end, {})

-- Watching
vim.api.nvim_create_user_command("JiraWatching", function()
  api.list_issues({
    statuses = { "~Done", "~Cancelled" },
    types = { "~Epic" },
    args = "-w"
  })
end, {})

-- Worked Today
vim.api.nvim_create_user_command("JiraWorkedToday", function()
  api.list_issues({
    query = "updated > startOfDay()",
    types = { "~Epic" },
    args = "--reverse -a $(jira me)"
  })
end, {})

-- Worked this week
vim.api.nvim_create_user_command("JiraWorkedThisWeek", function()
  api.list_issues({
    query = "updated >= startOfWeek()",
    types = { "~Epic" },
    args = "--reverse -a $(jira me)"
  })
end, {})

-- Worked this month
vim.api.nvim_create_user_command("JiraWorkedThisMonth", function()
  api.list_issues({
    query = "updated >= startOfMonth()",
    types = { "~Epic" },
    args = "--reverse -a $(jira me)"
  })
end, {})

-- What ticket did I opened recently?
vim.api.nvim_create_user_command("JiraRecents", function()
  api.list_issues({ args = '--history' })
end, { nargs = "*", bang = true, complete = "file" })

-- Assigned to me
vim.api.nvim_create_user_command("JiraAssignedToMe", function()
  api.list_issues({
    statuses = { "~Done", "~Cancelled" },
    types = { "~Epic" },
    order = "rank",
    args = "--reverse -a $(jira me)"
  })
end, {})

-- Reported by me
vim.api.nvim_create_user_command("JiraReportedByMe", function()
  api.list_issues({
    types = { "~Epic" },
    order = "rank",
    args = "--reverse -r $(jira me)"
  })
end, {})

-- List issues in status other than "Open" and is assigned to no one
vim.api.nvim_create_user_command("JiraIssueOrphans", function()
  api.list_issues({
    statuses = { "~Open" },
    order = "rank",
    args = "-ax"
  })
end, {})

-- List issues from all projects
vim.api.nvim_create_user_command("JiraIssueAllProjects", function()
  api.list_issues({
    statuses = { "~Done", "~Cancelled" },
    types = { "~Epic" },
    query = "project IS NOT EMPTY",
  })
end, {})

vim.api.nvim_create_user_command("JiraBacklog", function()
  api.list_issues({
    statuses = { "~Done", "~Cancelled" },
    query = "sprint is empty and issuetype not in (Epic, Sub-task)",
    order = "rank",
    args = "--reverse"
  })
end, {})

-- List issues whose status is not done and is created before 6 months and is assigned to someone
vim.api.nvim_create_user_command("JiraIssueOlderThan6Months", function()
  api.list_issues({
    statuses = { "~Done", "~Cancelled" },
    types = { "~Epic" },
    args = "--created-before -24w -a~x"
  })
end, {})
