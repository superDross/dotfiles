## Data Types

`serial` is used to auto increment columns.

`cascade` specifies that when a referenced row is deleted, rows referencing it should be
automatically deleted too

### Key/Value Unstructured Data

There is `hstore` but seems to not be used often

The `json` data type stores raw json and preserves even white space, the order of the keys
and even duplicate keys in objects. It is mostly just stored as `text` really.

It offers a basic but SLOW json operations and validates every check to ensure is is valid json.

The `jsonb` data type on the other hand stores the data in a custom format that is optimised
for certain operations. It also has more operations available than `jsonb`.

Use `json` if you want to preserve the data exactly as it arrived and you won't be doing many
operations upon it, otherwise if you need to query the data often use `jsonb`.
