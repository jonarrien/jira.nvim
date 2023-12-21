local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.set_current_ticket = function(prompt_bufnr)
  local ticket = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if not ticket then return end
  vim.g.JiraTicket = ticket.key
end

M.edit = function(prompt_bufnr)
  local ticket = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if not ticket then return end
  vim.cmd("JiraEdit " .. ticket.key)
end

M.view = function(prompt_bufnr)
  local ticket = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if not ticket then return end
  vim.cmd("JiraView " .. ticket.key)
end

return M
