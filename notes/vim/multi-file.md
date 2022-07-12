# Multi File Changes

Notes on how to perform one action on multiple files/buffers/windows.

## Argdo

Perform action on multiple files:

```vim
:arg **/*.py                        " add all python files recursively
:argadd README.md                   " add individual file
:arg                                " display all files added
:argdo %s/logging/TEMP/ge | update   " search/replace on all files and save
```

The `e` means no error if the pattern is not found.

## Bufdo

As above but on all *buffers*:

```vim
:bufdo %s/logging/TEMP/ge | update
```

## Windo

As above but on all *windows*:

```vim
:windo %s/logging/TEMP/ge | update
```
