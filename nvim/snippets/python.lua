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

-- Debugger

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

local example = snip({
  trig = "example",
  name = "example",
  descr = "an example with insert nodes",
}, fmt([[
  class {}: 
      {}  # test
      {}
  ]], {
  -- i(1) is at nodes[1], i(2) at nodes[2].
  insert(1, "PlaceHolder"), insert(2, "pass"), insert(3, "33"),
}))



-- TODO: create a class builder

ls.add_snippets(nil, {
  python = { pdb, rpdb, example }
})
