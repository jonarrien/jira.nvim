local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local commands = {
  set_current_ticket = "Set current ticket",
}

local menu_keys = function()
  local keys = {}
  local n = 0
  for k, v in pairs(commands) do
    n = n + 1
    keys[n] = k
  end
  return keys
end


-- execute
local execute = function(choice)
  -- accepts both number as well as string
  choice = choice and tonumber(choice) or choice -- returns a number if the choic is a number or string.

  -- Define your cases
  local case = {
    set_current_ticket = function()            -- case 1 :
      vim.notify("your choice is Number 1 ")   -- code block
    end,                                       -- break statement

    add = function()                           -- case 'add' :
      vim.notify("your choice is string add ") -- code block
    end,                                       -- break statement

    default = function()                       -- default case
      vim.notify("Invalid option")
    end,                                       -- u cant exclude end hear :-P
  }

  -- execution section
  if case[choice] then
    case[choice]()
  else
    case["default"]()
  end
end

-- Now you can use it as a regular function. Tadaaa..!!
-- switch(mychoice)


local M = {}

M.picker = function(prompt_bufnr)
  local ticket = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if not ticket then return end

  vim.ui.select(menu_keys(), {
      prompt = 'select',
      format_item = function(item)
        return commands[item]
      end,
    },
    function(command, idx)
      if command == nil then return end
      execute(command)
    end)
end


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
