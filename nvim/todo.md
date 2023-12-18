# Nvim Todo

## Plugins

- Mason now supports `ensure_installed` not just for lspconfig, consider using the feature and removing `mason_installer` plugin

## Personal Plugins

- picobook, gives me the overwrite page warning when opening the file in another buffer, a nice feature would be to automatically ignore it or automatically open in predefined choice (e.g. open in read-only by default)
- picobook, no longer works with github links due to new indexing, maybe automatically show full path?
- picobook, fzf uses cwd if vim.g.notesdir is empty. We should raise an exception instead
- picobook, use `open -a /Applications/Firefox.app` instead of `firefox` in `GoToNoteWebPage` function if MacOS detected

## 0.10.0

- inlay hints
- Noice replacement for pretty lsp info now part of 0.10.0
