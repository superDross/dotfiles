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


local debug = snip({
  trig = "debug",
  namr = "debug",
  dscr = "Lua debug breakpoint",
}, {
  text('local dbg = require("debugger"); dbg()')
})


ls.add_snippets(nil, {
  lua = { debug }
})
