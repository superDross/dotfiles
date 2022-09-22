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


local class = snip({
  trig = 'class',
  name = 'class',
  dscr = 'Class Constructor',
}, fmt([[
  class {}:
      def __init__(self, {}):
  {}

      def {}(self, {}):
          {}
  ]], {
  insert(1, 'ClassName'),
  insert(2),
  -- TODO: remove default values and types in args when reworking as self.arg
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
  insert(3, 'method_name'),
  insert(4, '*args, **kwargs'),
  insert(5, 'pass'),
}))


local scriptline = snip({
  trig = "scriptline",
  description = "Insert a script execution line",
}, fmt([[
  if __name__ == "__main__":
      {}({})
  ]], {
  insert(1, 'main'),
  insert(2),
}))


ls.add_snippets(nil, {
  python = { pdb, rpdb, class, scriptline }
})
