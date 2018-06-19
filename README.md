Contains all major dotfiles

# ViM Tips
Insert the same character (1) across an entire column:
```
CTRL-V j SHIFT-i 1 ESC
```
Send cursor back to previous location:
```
CTRL-O
```
Go back to most recent location:
```
CTRL-I
```
Autocomplete code:
```
CTRL-N
```
Autocomplete filepaths:
```
CTRL-X CTRL-F
```
Switch to insert mode at the location you left insert mode:
```
gi
```
Open a weblink that the cursor is hovering on:
```
gx
```
Increment/Decriment highlighted numbers:
```
v CTRL-A/CTRL-X
```
Undo the last 10 minutes of editing
```
:earlier 10m
```

## REGEX
### Global
Delete all lines containing the word orange:
```
:g/orange/d
```
Delete all words NOT containing the word orange:
```
:g!/orange/d
```
Delete lines between line 8-19 that contain orange:
```
:8,19g/orange/d
```
Delete all lines begining with D:
```
g/^D/d
```
Add Celsius to the end of each line that begins with Temperature
```
:g/^Temperature/s/$/Celsius
```

### Search and Replace
Replace all instances of lbs to grams on the line:
```
:s/lbs/grams/g
```
Replace the first instance of lbs to grams on the line:
```
:s/lbs/grams
```
Replace all instances of lbs to grams across all lines:
```
:%s/lbs/grams/g
```
