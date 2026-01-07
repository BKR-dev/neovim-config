<div align="center">

# Neovim Config

### *Minimal. Powerful. Beautiful.*

[![Neovim](https://img.shields.io/badge/Neovim-0.10%2B-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

<br>

*A carefully crafted Neovim configuration that balances power with simplicity.*
*Zero bloat. Maximum productivity.*

<br>

**[Features](#-features)** · **[Installation](#-quick-start)** · **[Keybindings](#-keybindings)** · **[Customization](#-configuration)**

---

<br>

<img src="https://raw.githubusercontent.com/neovim/neovim.github.io/master/logos/neovim-mark-flat.png" width="100" alt="Neovim Logo">

</div>

<br>

## Why This Config?

> **"The right tool, without the clutter."**

Unlike heavyweight distributions like LazyVim or NvChad, this configuration gives you:

- **Instant startup** — Lazy-loaded plugins, no waiting
- **Full control** — Clean, readable code you can actually understand
- **Battle-tested** — Used daily in production development
- **Go-optimized** — First-class Go support with 20+ gopls enhancements
- **Terminal-first** — Custom floating terminal with tabs, deep Tmux integration

<br>

---

<br>

## ✨ Features

<table>
<tr>
<td width="50%">

### Core
- **Lazy.nvim** — Lightning-fast plugin manager
- **LSP Zero** — Opinionated LSP framework
- **Mason** — Auto-install language servers
- **Treesitter** — Modern syntax highlighting

</td>
<td width="50%">

### Navigation
- **Telescope** — Fuzzy find anything
- **Harpoon** — Instant file switching
- **Tmux Navigator** — Seamless pane movement
- **Undotree** — Visual undo history

</td>
</tr>
<tr>
<td width="50%">

### Editing
- **nvim-cmp** — 9 completion sources
- **LuaSnip** — Powerful snippets
- **Auto-pairs** — Smart bracket closing
- **Comment.nvim** — Easy commenting

</td>
<td width="50%">

### Developer Experience
- **DAP Debugging** — Full debugger support
- **Floating Terminal** — Tabbed terminal UI
- **Auto-format** — Format on save
- **Go Snippets** — Error handling templates

</td>
</tr>
</table>

<br>

### Language Support

| Language | Features |
|:---------|:---------|
| **Go** | Full gopls integration, auto-imports, gofumpt, error snippets, DAP debugging |
| **Lua** | lua_ls with Neovim API completion |
| **Terraform** | terraformls with syntax highlighting |
| **TypeScript** | Full LSP support via Mason |
| **YAML/JSON** | Schema validation, formatting |
| **+ More** | Bash, Docker, SQL, Markdown, HTML... |

<br>

---

<br>

## 🚀 Quick Start

### Prerequisites

```
Neovim ≥ 0.10.0  •  Git  •  Node.js  •  Ripgrep  •  Nerd Font
```

<details>
<summary><b>📦 Install prerequisites by platform</b></summary>

<br>

**macOS**
```bash
brew install neovim git node ripgrep
brew install --cask font-hack-nerd-font
```

**Arch Linux**
```bash
sudo pacman -S neovim git nodejs npm ripgrep
yay -S ttf-hack-nerd
```

**Ubuntu/Debian**
```bash
# Install latest Neovim from GitHub releases
sudo apt install git nodejs npm ripgrep
```

</details>

<br>

### One-Command Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/BKR-dev/neovim-config/master/setup.sh)
```

This automatically:
- ✓ Backs up your existing config
- ✓ Clones and installs plugins
- ✓ Configures LSP servers
- ✓ Cleans up old plugin managers

<br>

<details>
<summary><b>📖 Manual installation</b></summary>

<br>

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone this config
git clone https://github.com/BKR-dev/neovim-config.git ~/.config/nvim

# Launch Neovim (plugins install automatically)
nvim

# Install language servers
:Mason
```

</details>

<br>

---

<br>

## ⌨️ Keybindings

<kbd>Space</kbd> is the leader key.

<br>

### Navigation

| Keymap | Action |
|:-------|:-------|
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>f</kbd> | Find files |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>g</kbd> | Live grep |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>b</kbd> | Browse buffers |
| <kbd>Space</kbd> <kbd>f</kbd> <kbd>t</kbd> | File explorer |
| <kbd>Ctrl</kbd> <kbd>e</kbd> | Harpoon menu |
| <kbd>Space</kbd> <kbd>a</kbd> | Add to Harpoon |
| <kbd>Space</kbd> <kbd>1-4</kbd> | Jump to Harpoon 1-4 |

<br>

### LSP

| Keymap | Action |
|:-------|:-------|
| <kbd>g</kbd> <kbd>d</kbd> | Go to definition |
| <kbd>K</kbd> | Hover documentation |
| <kbd>Space</kbd> <kbd>c</kbd> <kbd>a</kbd> | Code actions |
| <kbd>Space</kbd> <kbd>r</kbd> <kbd>n</kbd> | Rename symbol |
| <kbd>Space</kbd> <kbd>l</kbd> <kbd>d</kbd> | Diagnostic details |
| <kbd>[</kbd> <kbd>d</kbd> / <kbd>]</kbd> <kbd>d</kbd> | Prev/Next diagnostic |

<br>

### Floating Terminal

| Keymap | Action |
|:-------|:-------|
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>t</kbd> | Toggle terminal |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>a</kbd> | Add terminal tab |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>w</kbd> | Close terminal tab |
| <kbd>H</kbd> / <kbd>L</kbd> | Switch tabs |
| <kbd>1-9</kbd> | Jump to tab |
| <kbd>Esc</kbd> | Exit terminal mode |

<br>

### Debugging (DAP)

| Keymap | Action |
|:-------|:-------|
| <kbd>Space</kbd> <kbd>d</kbd> <kbd>w</kbd> | Start/Continue |
| <kbd>Space</kbd> <kbd>d</kbd> <kbd>o</kbd> | Step over |
| <kbd>Space</kbd> <kbd>d</kbd> <kbd>i</kbd> | Step into |
| <kbd>Space</kbd> <kbd>q</kbd> | Toggle breakpoint |
| <kbd>Space</kbd> <kbd>w</kbd> | Open DAP UI |

<br>

<details>
<summary><b>📋 All keybindings</b></summary>

<br>

#### Harpoon (Quick Files)
| Keymap | Action |
|:-------|:-------|
| <kbd>Space</kbd> <kbd>a</kbd> | Add file to Harpoon |
| <kbd>Ctrl</kbd> <kbd>e</kbd> | Toggle Harpoon menu |
| <kbd>Space</kbd> <kbd>1</kbd> | Harpoon file 1 |
| <kbd>Space</kbd> <kbd>2</kbd> | Harpoon file 2 |
| <kbd>Space</kbd> <kbd>3</kbd> | Harpoon file 3 |
| <kbd>Space</kbd> <kbd>4</kbd> | Harpoon file 4 |
| <kbd>Space</kbd> <kbd>8</kbd> | Harpoon file 5 |
| <kbd>Space</kbd> <kbd>9</kbd> | Harpoon file 6 |
| <kbd>Space</kbd> <kbd>0</kbd> | Harpoon file 7 |

#### Tmux Integration
| Keymap | Action |
|:-------|:-------|
| <kbd>Ctrl</kbd> <kbd>h/j/k/l</kbd> | Navigate panes |
| <kbd>Space</kbd> <kbd>t</kbd> <kbd>1-9</kbd> | Switch tmux window |
| <kbd>Space</kbd> <kbd>n</kbd> | Next tmux window |
| <kbd>Space</kbd> <kbd>p</kbd> | Previous tmux window |

#### Utilities
| Keymap | Action |
|:-------|:-------|
| <kbd>Space</kbd> <kbd>u</kbd> | Toggle Undotree |
| <kbd>F13</kbd> | Save file (CapsLock) |
| <kbd>F20</kbd> | Go imports + save |

</details>

<br>

---

<br>

## 📁 Configuration

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── core/
│   │   ├── init.lua           # Core initialization
│   │   ├── lazy.lua           # Plugin manager setup
│   │   ├── set.lua            # Vim options
│   │   ├── remap.lua          # Key mappings
│   │   └── floatterminal.lua  # Floating terminal
│   ├── plugins/
│   │   ├── lsp.lua            # LSP & completion
│   │   ├── telescope.lua      # Fuzzy finder
│   │   ├── treesitter.lua     # Syntax
│   │   ├── harpoon.lua        # Quick navigation
│   │   ├── debugging.lua      # DAP setup
│   │   ├── colors.lua         # Theme
│   │   ├── lualine.lua        # Status line
│   │   └── utils.lua          # Utilities
│   └── snippets/
│       └── go.lua             # Go error snippets
└── setup.sh                    # Install script
```

<br>

---

<br>

## 🎨 Customization

### Theme

Uses **Palenightfall** with custom overrides for:
- Transparent background (blends with terminal)
- Custom line numbers and comments
- Magenta matching brackets

Edit `lua/plugins/colors.lua` to customize.

<br>

### Go Snippets

Built-in error handling snippets:

| Trigger | Expands to |
|:--------|:-----------|
| `iferr` | Basic `if err != nil { return err }` |
| `iferrwrap` | Wrapped error with `fmt.Errorf` |
| `iferrpanic` | `if err != nil { panic(err) }` |
| `iferrlog` | Error with `log.Println` |
| `iferrfatal` | Error with `log.Fatal` |

<br>

### Adding Plugins

```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({})
  end,
}
```

<br>

---

<br>

## 🔧 Maintenance

### Update

```bash
cd ~/.config/nvim && git pull
nvim -c "Lazy sync"
```

### Health Check

```vim
:checkhealth
```

### Troubleshooting

```vim
:Lazy sync      " Reinstall plugins
:Mason          " Manage LSP servers
:LspInfo        " LSP status
```

<br>

---

<br>

## 🗑️ Uninstall

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim
# Restore backup if needed:
mv ~/.config/nvim.bak ~/.config/nvim
```

<br>

---

<br>

<div align="center">

## 💡 Pro Tips

</div>

```bash
# Add to your shell config (~/.zshrc or ~/.bashrc)

alias v='nvim'
alias fp='cd $(find ~/projects -maxdepth 1 -type d | fzf) && v .'
```

<br>

---

<br>

<div align="center">

### Built with precision for developers who value their time.

<br>

**[⬆ Back to top](#neovim-config)**

<br>

<sub>Made with ❤️ by <a href="https://github.com/BKR-dev">BKR-dev</a></sub>

</div>
