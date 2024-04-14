local run = require('jira.run').interactive
local config = require('jira.config')

local plain = {
  columns = "key,priority,type,summary,labels,status"
}

local parse_results = function(output)
  local results = {}

  for line in output:gmatch("[^\r\n]+") do
    local key, priority, type, summary, labels, status = line:match(
      "(%S+)\t+(%S+)\t+(%S+)\t+(.*)\t+(%S+)\t+(.*)"
    )
    if key and key ~= nil and key ~= "KEY" then
      table.insert(results, {
        key = key,
        type = type,
        priority = priority,
        summary = summary,
        labels = labels,
        status = status,
      })
    end
  end
  return results
end

-- Generates Jira CLI command arguments
-- @param cmd string `issue list` or `sprint list`
-- @param opts table
local cli_arguments = function(cmd, opts)
  if opts.types then
    for _, t in ipairs(opts.types) do
      cmd = cmd .. " -t" .. t .. " "
    end
  end

  if opts.statuses then
    for _, status in ipairs(opts.statuses) do
      cmd = cmd .. ' -s"' .. status .. '" '
    end
  end

  if opts.query then
    cmd = cmd .. ' -q"' .. opts.query .. '" '
  end

  if opts.plain then cmd = cmd .. " --plain" end

  return string.format("%s --columns %s --order-by %s --paginate %s %s",
    cmd,
    opts.columns or config.columns,
    opts.order or config.order,
    opts.paginate or config.paginate,
    opts.args or ''
  )
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
  run(cli_arguments('issue list', opts))
end

M.epics = function(opts)
  local cmd = "epic list "

  if opts.statuses then
    for _, status in ipairs(opts.statuses) do cmd = cmd .. '-s"' .. status .. '" ' end
  end

  cmd = table.concat({
    cmd,
    "--order-by ", opts.order or config.order,
    opts.args or ''
  }, " ")
  run(cmd, { direction = 'horizontal' })
end

M.sprints = function(opts)
  local args = cli_arguments('sprint list', opts)
  if opts.plain then
    local output = io.popen("jira " .. args):read("*a")
    return parse_results(output)
  else
    run(args, { direction = 'horizontal' })
  end
end

M.open_browser = function()
  run("open")
end

-- Helper to export issues
M.plain = function(subcommand, opts)
  opts = opts or {}
  opts.columns = plain.columns
  opts.plain = true

  local args = cli_arguments(subcommand, opts)
  local output = io.popen("jira " .. args):read("*a")
  return parse_results(output)
end

return M
