# File Associations (`associations.toml`)

One table decides which app opens which file. The file manager's double click, the shell's
`open`, and any app that hands a file on all ask the same table, so they cannot drift apart.

## The file

```toml
rb  = "run"
lua = "run"
bas = "run"
py  = "run"

md  = "/app/tool/picorabbit.app.rb"
nsf = "/app/tool/nsf_player.app.rb"

txt  = "edit"
toml = "edit"
json = "edit"
```

One line per extension, written without the dot, and one of three answers:

| Answer | What happens |
|---|---|
| `run` | The file is a program. It is spawned as an app |
| `edit` | It opens in the editor |
| `/app/…` | That app is spawned and handed the file |

An extension with no entry gets `edit` — showing a file is a better answer to "I do not
know" than doing nothing. A directory is never opened this way.

## Two layers

| File | |
|---|---|
| `/etc/associations.toml` | Ships with the firmware |
| `/home/associations.toml` | Yours. It wins, per extension |

So to send `.md` to the editor instead of the presentation tool, `/home/associations.toml`
needs one line and nothing else:

```toml
md = "edit"
```

The table is read once, when the app that consults it starts. A change takes effect the
next time that app is started.

## Receiving a file

An app that is handed a file gets it exactly as it gets a file from the file selector, so an
app that already handles that needs nothing new to be worth associating with an extension.

## Related

- [Default Apps](../getting_started/default_apps.md) — what is installed to open things with
- [App Config (.app.toml)](app_toml.md) — how an app gets into the launcher
