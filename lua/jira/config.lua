return {
  columns = "key,type,summary,priority,status,assignee,reporter,sprint,duedate,labels,description",
  order = "priority,rank",
  paginate = 50,
  issue_types = {
    'Epic',
    'Feature',
    'Story',
    'Bug',
    'Task',
    'Support',
  },
  statuses = {
    'Open',
    'To Do',
    'Waiting',
    'In Progress',
    'In Review',
    'Done',
    'Cancelled'
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
