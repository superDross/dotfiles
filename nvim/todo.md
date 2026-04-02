# Nvim Todo

- consider using `vim.pack` over using `lazy.nvim`
- consider using `vim.snip` over using `LuaSnip`
- consider using `vim.lsp.completion` over using `nvim-cmp` plugins
- codecompanion v19.4+ does not work
- cmp-nvim-lsp-signature-help gives a deprecate warning, this should fix it when it is merged: https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/55 

## New Text Object stuff

```

" =========================
" TREE-SITTER TEXT OBJECTS (PLUGIN)
" =========================
" Requires: nvim-treesitter-textobjects

vaf        " select around function
vif        " select inside function
daf        " delete function
yaf        " yank (copy) function
cif        " change function body

vac        " select around class
vic        " select inside class

vaa        " select around argument
via        " select inside argument

vai        " select around if block
vii        " select inside if block

val        " select around loop
vil        " select inside loop


" =========================
" INCREMENTAL SELECTION (BUILT-IN 0.12)
" =========================
" No default keymaps — must be called manually

:lua vim.treesitter.incremental_selection.init()
:lua vim.treesitter.incremental_selection.increment()
:lua vim.treesitter.incremental_selection.decrement()

```


## Personal Plugins

- picobook, **bug** `wm` creates a new file and deletes the old one rather than moving it
- picobook, FindPicoNotes command
- picobook, auto create link e.g. if writing `[Inheritence]` in an index it should auto complete the link `[Inheritence](../<index_name>/inheritence.md)`
- picobook, gives me the overwrite page warning when opening the file in another buffer, a nice feature would be to automatically ignore it or automatically open in predefined choice (e.g. open in read-only by default)
- picobook, disallow creating files outside the notesdir
- picobook, command to go back to last page (useful when several C-o inputs is not enough)

