Contains all major dotfiles

## ViM Tips
https://bluz71.github.io/2017/05/15/vim-tips-tricks.html
### Insert
Insert the same character (1) across an entire column:
```
CTRL-V j SHIFT-i 1 ESC
```
Increment/Decriment highlighted numbers:
```
v CTRL-A/CTRL-X
```
Undo the last 10 minutes of editing
```
:earlier 10m
```
Insert calculation of 3 + 4:
```
CTRL-R =3+4 ENTER
```

### Moving
Send cursor back to previous location:
```
CTRL-SHIFT-O
```
Go back to most recent location:
```
CTRL-SHIFT-I
```
Switch to insert mode at the location you left insert mode:
```
gi
```
Jump back to the lst edit:
```
g;
```

### Autocomplete
Autocomplete code:
```
CTRL-N
```
Autocomplete filepaths:
```
CTRL-X CTRL-F
```
Autocomplete words e.g. some to sometimes:
```
CTRL-X CTRL-K
```

### Web
Open a weblink that the cursor is hovering on:
```
gx
```
Open up a webpages HTML source in Vim:
```
http://example.com/
```

### Regex
##### Global
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

##### Search
Count number of lines that match the word orange:
```
:%s/orange//ng
```

##### Search and Replace
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
