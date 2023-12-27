local run = require('jira.run')

local defaults = {
  columns = "key,type,summary,priority,status,assignee,reporter,sprint,duedate,labels,description",
  order = "priority,rank",
  paginate = 50,
  issue_types = { 'Epic', 'Story', 'Task', 'Bug', 'Support' },
}

local parse_results = function(output)
  local results = {}
  for line in output:gmatch("[^\r\n]+") do
    local key, priority, kind, subject = line:match(
      "(%S+)%s+(%S+)%s+(%S+)%s+(.+)"
    )
    if key and key ~= nil and key ~= "KEY" then
      table.insert(results, {
        key = key,
        type = kind,
        priority = priority,
        description = subject,
      })
    end
  end
  return results
end

local M = {}

M.create = function(issue_type, args)
  local cmd = "issue create"
  if issue_type then
    local nvim_path = vim.api.nvim_list_runtime_paths()[1]
    local tmpl_path = nvim_path .. "/lua/jira/templates/" .. issue_type:lower() .. ".tmpl"
    cmd = cmd .. " -t" .. issue_type
    cmd = cmd .. " --template " .. tmpl_path
    cmd = cmd .. " " .. (args or '')
  end
  run(cmd)
end

M.edit = function(issue)
  run("issue edit " .. issue)
end

M.view = function(issue)
  run("issue view " .. issue .. " --comments 5")
end

M.list_issues = function(opts)
  local cmd = "issue list "

  if opts.types then
    for _, t in ipairs(opts.types) do cmd = cmd .. "-t" .. t .. " " end
  end

  if opts.statuses then
    for _, status in ipairs(opts.statuses) do cmd = cmd .. '-s"' .. status .. '" ' end
  end

  if opts.query then
    cmd = cmd .. '-q"' .. opts.query .. '" '
  end

  run(table.concat({
    cmd,
    "--columns ", opts.columns or defaults.columns,
    "--order-by ", opts.order or defaults.order,
    "--paginate ", opts.paginate or defaults.paginate,
    opts.args or ''
  }, " "))
end

M.epics = function(opts)
  local cmd = "epic list "

  if opts.statuses then
    for _, status in ipairs(opts.statuses) do cmd = cmd .. '-s"' .. status .. '" ' end
  end

  cmd = table.concat({
    cmd,
    "--order-by ", opts.order or defaults.order,
    opts.args or ''
  }, " ")
  run(cmd, { direction = 'horizontal' })
end

M.sprints = function(opts)
  local cmd = "sprint list "

  if opts.types then
    for _, t in ipairs(opts.types) do cmd = cmd .. "-t" .. t .. " " end
  end

  if opts.statuses then
    for _, status in ipairs(opts.statuses) do cmd = cmd .. '-s"' .. status .. '" ' end
  end

  if opts.query then
    cmd = cmd .. '-q"' .. opts.query .. '" '
  end

  cmd = table.concat({
    cmd,
    "--columns ", opts.columns or defaults.columns,
    "--order-by ", opts.order or defaults.order,
    "--paginate ", opts.paginate or defaults.paginate,
    opts.args or ''
  }, " ")

  if opts.plain then
    cmd = "jira " .. cmd .. " --plain"
    local output = io.popen(cmd):read("*a")
    return parse_results(output)
  else
    run(cmd, { direction = 'horizontal' })
  end
end

M.open_browser = function()
  run("open")
end

return M
