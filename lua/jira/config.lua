return {
  statuses = {
    'Open',
    'To Do',
    'Waiting',
    'In Progress',
    'In Review',
    'Done',
    'Cancelled'
  },
  issue_types = {
    'Epic',
    'Feature',
    'Story',
    'Bug',
    'Task'
  },

  highlights = {
    priority = {
      Highest = 'DevIconHtm',
      High    = 'DevIconMl',
      Medium  = 'DevIconPp',
      Low     = 'DevIconDefault',
      Lowest  = 'DevIconDsStore',
    },
    type = {
      Bug          = 'Error', --  'DevIconErl', DevIconHrl
      Story        = 'DevIconLiquid',
      Feature      = 'DevIconBmp',
      Support      = 'DevIconMl',
      Task         = 'DevIconCss',
      ["Sub-task"] = 'DevIconAac',
    },
    status = {
      ["Todo"]        = 'Function',
      ["In Analysis"] = '@lsp.type.parameter',
      ["Waiting"]     = 'Conditional',
      ["In Progress"] = 'Boolean',
      ["In Review"]   = 'String',
    }
  }
}
