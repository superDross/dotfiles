local ls = require("luasnip")

local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamic = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require('luasnip.extras').rep


local pdb = snip({
  trig = "pdb",
  namr = "pdb",
  dscr = "Python pdb breakpoint",
}, {
  text("import pdb;pdb.set_trace()  # fmt: skip")
})

local rpdb = snip({
  trig = "rpdb",
  namr = "rpdb",
  dscr = "Insert a remote-pdb breakpoint",
}, {
  text("from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 4444).set_trace()  # fmt: skip")
})

-- TODO: use fmt instead of text nodes here for greater readability
--
local class_constructor = snip({
  trig = 'cls',
  name = 'class',
  dscr = 'Class Constructor',
}, {
  text('class '),
  insert(1, { 'MyClass' }),
  -- text('('),
  -- insert(2, { '' }),
  text({ ':', '\t' }),
  text({ 'def init(self,' }),
  insert(2),
  text({ '):', '' }),
  func(function(args)
    if not args[1][1] or args[1][1] == '' then
      return { '' }
    end
    local a = vim.tbl_map(function(item)
      local trimed = vim.trim(item)
      return '\t\tself.' .. trimed .. ' = ' .. trimed
    end, vim.split(
      args[1][1],
      ',',
      true
    ))
    return a
  end, {
    2,
  }),
  insert(0),
})

ls.add_snippets(nil, {
  python = { pdb, rpdb, class_constructor }
})
