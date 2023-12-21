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

  require('jira.commands')
end

return M
