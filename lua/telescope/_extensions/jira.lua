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

local api = require('jira.api')
local fn = require('jira.fn')

local cache = nil

local displayer = entry_display.create({
  separator = " ",
  items = {
    { width = 9 },
    { width = 10 },
    { width = 10 },
    { remaining = true },
  },
})

local priority_highlight = {
  Highest = 'DevIconHtm',
  High    = 'DevIconMl',
  Medium  = 'DevIconPp',
  Low     = 'DevIconDefault',
  Lowest  = 'DevIconDsStore',
}

local type_highlight = {
  Bug     = 'Error',
  Story   = 'DevIconLiquid',
  Feature = 'DevIconErl',
  Support = 'DevIconMl',
  Task    = 'DevIconCss',
}

local make_display = function(entry)
  local id_hl = priority_highlight[entry.priority] or 'Error'
  local type_hl = type_highlight[entry.type] or 'Error'
  return displayer({
    { entry.id,          "DevIconEx" },
    { entry.priority,    id_hl },
    { entry.type,        type_hl },
    { entry.description, 'Comment' },
  })
end

local autocomplete = function(text)
  if cache ~= nil then return cache end
  cache = api.sprints({
    statuses = { "~Done", "~Cancelled" },
    types = { "~Epic" },
    plain = true,
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
      entry.ordinal = entry.key .. " " .. entry.description
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
      map("i", '<CR>', fn.set_current_ticket)
      map("i", '<C-e>', fn.edit)
      map("i", '<C-v>', fn.view)
      return true
    end,
  })
end

local current_sprint = function(opts)
  make_picker(opts):find()
end

return telescope.register_extension({
  exports = {
    jira = current_sprint,
  }
})
