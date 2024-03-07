# Nvim Todo
- try normal pdb and using `docker attach (container id)`
- consider altering `$MYVIMRC` env var directly to this config rather than use the symbolic links
  - wonder if this will mess lead to regular vim using init.lua?
- allow lua-fzf to search .nexus and .gitlab-ci.yml and .github dir/files; an exception list to the dotfiles essentially
  - only seems to be a problem with ripgrep `<leader>fg`

## Plugins

- Mason now supports `ensure_installed` not just for lspconfig, consider using the feature and removing `mason_installer` plugin

## Personal Plugins

- picobook, **bug** `wm` creates a new file and deletes the old one rather than moving it
- picobook, auto create link e.g. if writing `[Inheritence]` in an index it should auto complete the link `[Inheritence](../<index_name>/inheritence.md)`
- picobook, gives me the overwrite page warning when opening the file in another buffer, a nice feature would be to automatically ignore it or automatically open in predefined choice (e.g. open in read-only by default)
- picobook, disallow creating files outside the notesdir
- picobook, command to go back to last page (useful when several C-o inputs is not enough)

## 0.10.0

- inlay hints
- Noice replacement for pretty lsp info now part of 0.10.0
