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


local link = snip({
  trig = "link",
  dscr = "Create a markdown link [txt](url)",
}, fmt([[
  [{}]({})
]], {
  insert(1),
  insert(2),
}))

local img = snip({
  trig = "img",
  dscr = "Create a markdown img ![txt](path)",
}, fmt([[
  ![{}]({})
]], {
  insert(1),
  insert(2),
}))


local note = snip({
  trig = "note",
  dscr = "create an information box",
}, fmt([[ 
  > :information_source: **Note**
  >
  > {}
]], {
  insert(1)
}))

local info = snip({
  trig = "info",
  dscr = "create an information box",
}, fmt([[ 
  > :information_source: **Note**
  >
  > {}
]], {
  insert(1)
}))


local warning = snip({
  trig = "warning",
  dscr = "create an information box",
}, fmt([[ 
  > :warning: **Warning**
  >
  > {}
]], {
  insert(1)
}))

ls.add_snippets(nil, {
  markdown = { link, img, note, warning, info }
})
