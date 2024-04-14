-- =============================================================================
-- JIRA CLI integration
-- Author: @jonarrien
-- =============================================================================

local M = {}

M.setup = function()
  local token = os.getenv("JIRA_API_TOKEN")
  if token == nil or token == "" then
    vim.notify("JIRA_API_TOKEN is not set", vim.log.levels.WARN)
    return
  end

  require('jira.commands.browser')
  require('jira.commands.edit')
  require('jira.commands.epics')
  require('jira.commands.generic')
  require('jira.commands.list')
  require('jira.commands.new')
  require('jira.commands.sprints')
  require('jira.commands.start')
  require('jira.commands.view')
end

return M
