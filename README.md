# scamp 🐕

Scamp is a simple Neovim plugin that allows remotely editing files.
Scamp uses SCP and assumes key-based SSH authentication.

# Installing

Using [slowly](https://github.com/nat-418/slowly.nvim):

```lua
require('slowly').setup({
  disabled_builtins = {
    -- Scamp is designed for people who don't use Netrw.
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
  },
  plugins = {
    {url = "https://github.com/nat-418/scamp.nvim", start = true}
    -- other plugins...
  }
})
```

# Configuration

Add the following to, e.g., `init.lua`:
```lua
require('scamp').setup()
```

# Usage

Scamp hooks into read and write events, so you can simply
`:edit scp:...` and `:write` normally.

```bash
$ nvim scp://user@host:/path/to/file
```

