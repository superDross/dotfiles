local ls = require("luasnip")
local snip = ls.snippet
local text = ls.text_node

ls.add_snippets(nil, {
  python = {
    snip({
      trig = "pdb",
      namr = "pdb",
      dscr = "Python pdb breakpoint",
    }, {
      text("import pdb;pdb.set_trace()  # fmt: skip")
    }),
    snip({
      trig = "rpdb",
      namr = "rpdb",
      dscr = "Insert a remote-pdb breakpoint",
    }, {
      text("from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 4444).set_trace()  # fmt: skip")
    }),
  },
})
