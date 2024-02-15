local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

-- local cmdline = require('cmdline')
-- local action = require('cmdline.actions')
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorter = require("telescope.sorters")
local entry_display = require("telescope.pickers.entry_display")

local config = require("jira.config")
local api = require('jira.api')
local fn = require('jira.fn')

local cache = nil

local displayer = entry_display.create({
  separator = " ",
  items = {
    { width = 9 },
    { width = 10 },
    { width = 10 },
    { width = 15 },
    { remaining = true },
    { width = 30 },
  },
})

local make_display = function(entry)
  local priority_hl = config.highlights.priority[entry.priority] or 'Error'
  local type_hl = config.highlights.type[entry.type] or 'Error'
  local status_hl = config.highlights.status[entry.status] or 'Error'

  return displayer({
    { entry.id,       "Function" },
    { entry.priority, priority_hl },
    { entry.type,     type_hl },
    { entry.status,   status_hl },
    { entry.summary },
    { entry.labels,   "Comment" },
  })
end

local autocomplete = function(text)
  if cache ~= nil then return cache end
  cache = api.plain('sprint list', {
    statuses = { "~Done", "~Cancelled" },
    types = { "~Epic" },
    args = "--current -a$(jira me)"
  })
  return cache
end

local make_finder = function(config)
  return finders.new_dynamic({
    fn = autocomplete,
    entry_maker = function(entry)
      entry.id = entry.key
      entry.value = entry.key
      entry.ordinal = entry.key .. " " .. entry.summary .. " " .. entry.labels
      entry.display = make_display
      return entry
    end,
  })
end

local make_picker = function(opts)
  return pickers.new(opts, {
    prompt_title = "Jira",
    prompt_prefix = " 󰌃  ",
    finder = make_finder(),
    sorter = sorter.get_fzy_sorter(opts),
    attach_mappings = function(_, map)
      map("i", '<CR>', fn.picker)
      map("i", '<C-e>', fn.edit)
      map("i", '<C-v>', fn.view)
      return true
    end,
  })
end

return telescope.register_extension({
  exports = {
    jira = function(opts)
      make_picker(opts):find()
    end
  }
})
