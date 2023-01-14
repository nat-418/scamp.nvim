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

```sh
$ git clone --depth 1 https://github.com/nat-418/scamp.nvim ~/.local/share/nvim/site/pack/bufala/start/scamp.nvim
```

## Configuration

Add the following to your configuration:

```lua
-- ~/.config/nvim/init.lua
require('scamp').setup()
```

This setup function accepts a table of configuration options.
Here are the defaults:

```lua
-- ~/.config/nvim/init.lua
require('scamp').setup({
  -- see man(5) ssh_config for more control options
  scp_options = {
    'ConnectTimeout=5'
  }
})
```

## Usage

Scamp hooks into read and write events, so you can simply
`:edit scp://user@example.com/whatever` and `:write` normally.

[Conventional Commits 1.0.0]: https://flat.badgen.net/badge/Conventional%20Commits/1.0.0/
[Semantic Versioning 2.0.0]:  https://flat.badgen.net/badge/Semantic%20Versioning/2.0.0/
