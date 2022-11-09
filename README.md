# scamp 🐕
![Semantic Versioning 2.0.0]
![Conventional Commits 1.0.0]

Scamp is a simple Neovim plugin for remotely editing files.
Scamp uses SCP and assumes key-based SSH authentication.
Scamp is designed for people who do not use Netrw, e.g.:
```lua
-- ~/.config/nvim/init.lua
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw       = 1
```

## Installing

Using [slowly](https://github.com/nat-418/slowly.nvim):

```lua
-- ~/.config/nvim/lua/plugins.lua
require('slowly').setup({
  disabled_builtins = {
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

## Configuration

Add the following to your configuration:
```lua
-- ~/.config/nvim/init.lua
require('scamp').setup()
```

## Usage

Scamp hooks into read and write events, so you can simply
`:edit scp://user@example.com/whatever` and `:write` normally.

[Conventional Commits 1.0.0]: https://flat.badgen.net/badge/Conventional%20Commits/1.0.0/
[Semantic Versioning 2.0.0]:  https://flat.badgen.net/badge/Semantic%20Versioning/2.0.0/
