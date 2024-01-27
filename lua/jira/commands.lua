local api  = require('jira.api')

local cmds = {
  epic  = {
    done = "jira issue list -tEpic -sDone"
  },
  issue = {
    mine    = "jira issue list -s~Done --order-by rank --reverse -a $(jira me)",
    list    = "jira issue list -s~Done --order-by priority --paginate 100",
    todo    = "jira issue list -s 'To Do'",
    history = "jira issue list --history",
    view    = "jira issue view ISSUE-1 --comments 5",
  },
}

-- GENERIC

-- Run any Jira subcommand with arguments
vim.api.nvim_create_user_command("Jira", function(params)
  api.run(params.args)
end, { nargs = "*", bang = true, complete = "file" })

-- Edit given jira identifier
vim.api.nvim_create_user_command("JiraEdit", function(params)
  if params.args == nil or params.args == "" then
    api.edit(vim.g.JiraTicket)
  else
    api.edit(vim.fn.expandcmd(params.args))
  end
end, { nargs = "*" })

-- Show given jira identifier
vim.api.nvim_create_user_command("JiraView", function(params)
  if params.args == nil or params.args == "" then
    api.view(vim.g.JiraTicket)
  else
    api.view(vim.fn.expandcmd(params.args))
  end
end, { nargs = "*" })

-- Start Jira ticket and store identifier in session
vim.api.nvim_create_user_command("JiraStart", function()
  vim.ui.input({ prompt = "Jira Issue: " }, function(input)
    if input == nil or input == "" then return end
    vim.g.JiraTicket = input
  end)
end, {})

-- Open jira in browser
vim.api.nvim_create_user_command("JiraOpen", function()
  api.open_browser()
end, {})


-- NEW

vim.api.nvim_create_user_command("JiraNew", function()
  api.create()
end, {})

for _, issue_type in ipairs({ 'Epic', 'Feature', 'Story', 'Bug', 'Task' }) do
  vim.api.nvim_create_user_command("JiraNew" .. issue_type, function(params)
    api.create(issue_type, params.args)
  end, {})
end

-- ISSUES

for _, status in ipairs({ 'Open', 'To Do', 'Waiting', 'In Progress', 'In Review', 'Done', 'Cancelled' }) do
  local shortened = status:gsub("%s+", "")
  vim.api.nvim_create_user_command("JiraIssue" .. shortened, function()
    api.list_issues({ statuses = { status } })
  end, {})
end

-- List issues without status "Done" or "Cancelled"
vim.api.nvim_create_user_command("JiraIssueList", function()
  api.list_issues({
    statuses = { "~Done", "~Cancelled" },
    types = { "~Epic" }
  })
end, {})

vim.api.nvim_create_user_command("JiraWorkedToday", function()
  api.list_issues({
    query = "updated > startOfDay()",
    types = { "~Epic" }, 
    args = "--reverse -a $(jira me)"
  })
end, {})

vim.api.nvim_create_user_command("JiraWorkedThisWeek", function()
  api.list_issues({
    query = "updated >= startOfWeek()",
    types = { "~Epic" }, 
    args = "--reverse -a $(jira me)"
  })
end, {})

-- What ticket did I opened recently?
vim.api.nvim_create_user_command("JiraRecents", function()
  api.list_issues({ args = '--history' })
end, { nargs = "*", bang = true, complete = "file" })

vim.api.nvim_create_user_command("JiraMyTasks", function()
  api.list_issues({
    statuses = { "~Done", "~Cancelled" },
    types = { "~Epic" },
    order = "rank",
    args = "--reverse -a $(jira me)"
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

-- EPICS

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

-- SPRINTS

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

vim.api.nvim_create_user_command("JiraBacklog", function()
  api.list_issues({
    statuses = { "~Done", "~Cancelled" },
    query = "sprint is empty and issuetype not in (Epic, Sub-task)",
    order = "rank",
    args = "--reverse"
  })
end, {})
