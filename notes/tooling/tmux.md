# Tmux

All commands are prefixed with Ctrl-b.

Check out [this](https://tmuxcheatsheet.com/) for the ultimate cheatsheeet thingy.

## Sessions

Creating a new session:

```
tmux new

# with a name
tmux new -s new-session
```

List all sessions:

```
tmux list-sessions
tmux ls

Ctrl-b s
```

Renaming a session:

```
tmux rename-session -t new-session old-session

Ctrl-b $
```

Deleting a session:

```
# delete last session
tmux kill-session

# delete new-session
tmux kill-session -t new-session

# delete all sessions
tmux kill-session -a
```

Detach a session:

```
tmux detach

Ctrl-b d
```

Attach a session:

```
# last session
tmux attach-session
tmux attach
tmux a

# by name
tmux a -t new-session
```

Move between sessions:

```
# move to next session
Ctrl-b )

# move to previous session
Ctrl-b (
```

## Windows

Create a new window:

```
Ctrl-b c
```

Rename current window:

```
Ctrl-b ,
```

Close the current window:

```
Ctrl-b &
```

Move to another window:

```
# next window
Ctrl-b n

# previous window
Ctrl-b p

# by number; 3rd window
Ctrl-b 3
```

MOve
