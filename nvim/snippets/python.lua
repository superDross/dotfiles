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


-- HELPER FUNCTIONS FOR CREATING CLASSES

local function clean_args(arg)
  -- removes type, white space and default value substrings from args
  -- e.g. '   arg: str = "string"  ' -> 'arg'
  local subs = { '%:.*', '%=.*' }
  for _, sub in pairs(subs) do
    arg = arg:gsub(sub, '')
  end
  return vim.trim(arg)
end

local function arg_to_attribute(arg)
  -- clean an func arg and transform it into an attribute
  -- e.g. '   arg: str = "string" ' -> 'self.arg = arg'
  local clean_arg = clean_args(arg)
  return '\t\tself.' .. clean_arg .. ' = ' .. clean_arg
end

local function args_to_attributes(arguments)
  -- takes a string of func args and transforms them into a table of attributes
  -- e.g. { { 'name: str, age: int = 15 ' } } -> { '\nself.name = name', '\nself.age = age' }
  local args = arguments[1][1]
  if not args or args == '' then
    return { '' }
  end
  local args_list = vim.split(args, ',', true)
  return vim.tbl_map(arg_to_attribute, args_list)
end

-- SNIPPETS

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


local pprint = snip({
  trig = "pprint",
  dscr = "Import and execute pprint",
}, fmt([[
  __import__('pprint').pprint({})
]], {
  insert(1),
}))


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
  func(args_to_attributes, { 2 }),
  insert(3, 'method_name'),
  insert(4, '*args, **kwargs'),
  insert(5, 'pass'),
}))


local scriptline = snip({
  trig = "scriptline",
  dscr = "Insert a script execution line",
}, fmt([[
  if __name__ == "__main__":
      {}({})
  ]], {
  insert(1, 'main'),
  insert(2),
}))


local property = snip({
  trig = "property",
  dscr = "Add a property method",
}, fmt([[

  @property
  def {}(self):
      {}
]], {
  insert(1),
  insert(2, 'pass'),
}))


-- EXPORT

ls.add_snippets(nil, {
  python = {
    pdb,
    rpdb,
    pprint,
    class,
    property,
    scriptline,
  }
})
