# Global

## Print

Print all lines containing `print`:

```
:g/print
:g/print/p
```

## Delete

Delete all lines containing `print`:

```
:g/print/d
```

Delete all lines that do not contain `print`:

```
:v/print/d
```

Delete all lines containing `print` except those with parenthesis:

```
:g/print/ v/(.*)/d
```

## Copy

Yank and put all lines starting with `##` to line 0:

```
:g/^##/t0
```

Yank all lines containing `normal` to register A:

```
:g/normal/y A
```

## Move

Move all lines starting with `##` to line 0:

```
:g/^##/m0
```

## Put

Paste contents from register `a` after substitution section:

```
:g/^## Substitution/pu a
```

## Substitution

Select lines not starting with `##` and sub `print` for `console`

```
:v/^##/ s/print/console/g
```

## Normal

Place a comment before every function in the file:

```
:g/^def/ normal O# TODO: clean this up
```

## Macros

Record the macro to q register:

```
qq
Wvaw~<Esc>q
```

Execute on all lines starting with `##`:

```
:g/^##/ normal @q
```

## Ranges

Within the Substitution section (after the header and before the next), delete all lines not starting with `:g`:

```
:/^## Substitution/+1;/^##/-1 v/^:g/d
```

Remove lines between lines between the first to the fourth last, containing `:g`:

```
:1,$ -4 g/^:g/d
```
