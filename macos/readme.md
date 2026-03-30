# MacOS

## Karabiner

To copy over across all systems use the following command:

```
 ln -s ~/bin/dotfiles/macos/karabiner/ ~/.config/karabiner
```

## Shortcuts (v15)

Window management shortcuts can be found [here](https://support.apple.com/en-gb/guide/mac-help/mchl9674d0b0/mac)

| Action            | Shortcut                                      |
| ----------------- | --------------------------------------------- |
| Temp Fullscreen   | Option-Enter                                  |
| Maximise Window   | Fn-Ctrl-F (Ctrl-Shift-F, via karabiner)       |
| Center Window     | Fn-Ctrl-C                                     |
| Move to Left Half | Fn-Ctrl-Left (Ctrl-Shift-Left, via karabiner) |
| Swap 2 windows    | Fn-Ctrl-Shift-Left                            |

Workspace shortcuts:

| Action                    | Shortcut        |
| ------------------------- | --------------- |
| Open Workspace Fullscreen | Cmd-Ctrl-F      |
| Switch to Right Screen    | Ctrl-Right      |
| Switch to Left Screen     | Ctrl-Left       |
| Switch to Desktop         | Ctrl-\<number\> |
| Spotlight Search          | Cmd-Space       |


## Install

```sh
# needed for nvim tresitter to work
brew install tree-sitter tree-sitter-cli

# ensure lua 5.1 is installed for some neovim related plugins
brew install luajit
# make it available as a binary for other distributions
ln -s $(which luajit) /opt/homebrew/bin/lua
```
