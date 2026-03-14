<div align="center">

<img src="https://raw.githubusercontent.com/neovim/neovim.github.io/master/logos/neovim-mark-flat.png" width="120" alt="Neovim Logo">

<h1>neovim-config</h1>

<p><em>Minimal. Powerful. Beautiful.</em></p>

[![Neovim](https://img.shields.io/badge/Neovim-0.10%2B-57A143?style=flat-square&logo=neovim&logoColor=white)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=flat-square&logo=lua&logoColor=white)](https://www.lua.org/)
[![License](https://img.shields.io/badge/License-MIT-6a9bcc?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/BKR-dev/neovim-config?style=flat-square&color=d97757)](https://github.com/BKR-dev/neovim-config/stargazers)

<br>

> A hand-rolled Neovim config that gives you full LSP, debugging, fuzzy-finding,  
> and a tabbed floating terminal — without the 400 ms startup tax of a distro.

<br>

[**Features**](#-features) · [**Install**](#-quick-start) · [**Keybindings**](#️-keybindings) · [**Structure**](#-structure) · [**Customization**](#-customization)

</div>

---

## Why not LazyVim / NvChad?

Distros are great until they aren't. This config gives you:

| | This config | LazyVim / NvChad |
|---|---|---|
| Startup | **< 40 ms** | 80–200 ms |
| Lines of config | **~600** | 2 000–5 000+ |
| You understand 100% of it | **Yes** | Rarely |
| Go-first tooling | **Yes** | Generic |
| Floating terminal with tabs | **Yes** | No |

---

## ✨ Features

<table>
<tr>
<td valign="top" width="50%">

**Core**
- [lazy.nvim](https://github.com/folke/lazy.nvim) — lazy-loaded plugin manager
- [LSP Zero](https://github.com/VonHeikemen/lsp-zero.nvim) + [Mason](https://github.com/williamboman/mason.nvim) — one-line LSP setup
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — precise syntax trees
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) — 9 completion sources

</td>
<td valign="top" width="50%">

**Navigation**
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) — fuzzy find files, grep, buffers
- [Harpoon 2](https://github.com/ThePrimeagen/harpoon) — instant bookmarked-file switching
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) — seamless pane jumps
- [Undotree](https://github.com/mbbill/undotree) — visual undo history

</td>
</tr>
<tr>
<td valign="top">

**Editing**
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) — snippets with Go error templates
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) — smart bracket closing
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) — `gc` to comment anything
- Format-on-save via LSP

</td>
<td valign="top">

**Developer Experience**
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) + [dap-ui](https://github.com/rcarriga/nvim-dap-ui) — full debugger
- **Floating terminal** — tabbed, persistent, `<Space>tt` to toggle
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) — minimal status line
- [Palenightfall](https://github.com/JoosepAlviste/palenightfall.nvim) theme, transparent bg

</td>
</tr>
</table>

### Language Support

| Language | LSP | Format | Debug | Extras |
|---|---|---|---|---|
| **Go** | `gopls` | `gofumpt` + goimports | `delve` | 5 error-handling snippets |
| **Lua** | `lua_ls` | stylua | — | Neovim API completion |
| **TypeScript** | `ts_ls` | prettier | — | |
| **Terraform** | `terraformls` | — | — | |
| **YAML / JSON** | `yamlls` / `jsonls` | — | — | Schema validation |
| **+** | Bash, Docker, SQL, Markdown, HTML | | | |

---

## 🚀 Quick Start

**Requirements:** Neovim ≥ 0.10 · Git · Node.js · ripgrep · a [Nerd Font](https://www.nerdfonts.com/)

```bash
# Install prerequisites (macOS)
brew install neovim ripgrep node && brew install --cask font-hack-nerd-font

# One-command install
bash <(curl -fsSL https://raw.githubusercontent.com/BKR-dev/neovim-config/master/setup.sh)
```

The installer backs up your existing config, clones this repo, and runs `:Lazy sync` automatically.

<details>
<summary>Manual installation</summary>

```bash
# Back up existing config
mv ~/.config/nvim{,.bak} 2>/dev/null; mv ~/.local/share/nvim{,.bak} 2>/dev/null

# Clone
git clone https://github.com/BKR-dev/neovim-config.git ~/.config/nvim

# Open Neovim — plugins install on first launch
nvim
```

Then run `:Mason` to install any extra language servers.

</details>

<details>
<summary>Arch / Ubuntu</summary>

```bash
# Arch
sudo pacman -S neovim git nodejs npm ripgrep && yay -S ttf-hack-nerd

# Ubuntu (install Neovim from GitHub releases for 0.10+)
sudo apt install git nodejs npm ripgrep
```

</details>

---

## ⌨️ Keybindings

Leader key: `<Space>`

### Files & Navigation

| Key | Action |
|---|---|
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Browse buffers |
| `<Space>ft` | File explorer |
| `<Space>a` | Add file to Harpoon |
| `<C-e>` | Harpoon quick menu |
| `<Space>1–4` | Jump to Harpoon file 1–4 |
| `<Space>8–0` | Jump to Harpoon file 5–7 |

### LSP

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `K` | Hover docs |
| `<Space>ca` | Code actions |
| `<Space>rn` | Rename symbol |
| `<Space>ld` | Diagnostic float |
| `[d` / `]d` | Prev / next diagnostic |

### Floating Terminal

| Key | Action |
|---|---|
| `<Space>tt` | Toggle terminal |
| `<Space>ta` | New terminal tab |
| `<Space>tw` | Close terminal tab |
| `H` / `L` | Switch tabs left / right |
| `1–9` | Jump to tab N |
| `<Esc>` | Exit terminal mode |

### Debugging (DAP)

| Key | Action |
|---|---|
| `<Space>dw` | Continue / start |
| `<Space>do` | Step over |
| `<Space>di` | Step into |
| `<Space>q` | Toggle breakpoint |
| `<Space>w` | Open DAP UI |

### Tmux Integration

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Navigate Neovim + Tmux panes |
| `<Space>t1–9` | Switch to Tmux window N |
| `<Space>n` / `<Space>p` | Next / prev Tmux window |

### Utilities

| Key | Action |
|---|---|
| `<Space>u` | Toggle Undotree |
| `F13` (CapsLock) | Save file |
| `F20` | Go imports + save |

---

## 📁 Structure

```
~/.config/nvim/
├── init.lua                    ← entry point
├── lua/
│   ├── core/
│   │   ├── lazy.lua            ← plugin manager bootstrap
│   │   ├── set.lua             ← vim options
│   │   ├── remap.lua           ← global keymaps
│   │   └── floatterminal.lua   ← tabbed floating terminal
│   ├── plugins/
│   │   ├── lsp.lua             ← LSP + Mason + nvim-cmp
│   │   ├── telescope.lua       ← fuzzy finder
│   │   ├── treesitter.lua      ← syntax / indent
│   │   ├── harpoon.lua         ← quick file switching
│   │   ├── debugging.lua       ← DAP + dap-ui
│   │   ├── colors.lua          ← theme + highlights
│   │   ├── lualine.lua         ← status line
│   │   └── utils.lua           ← autopairs, comment, undotree
│   └── snippets/
│       └── go.lua              ← Go error-handling snippets
└── setup.sh                    ← one-command installer
```

---

## 🎨 Customization

### Theme

[Palenightfall](https://github.com/JoosepAlviste/palenightfall.nvim) with:
- Transparent background (inherits terminal color)
- Custom comment, line-number, and matching-bracket colors

Edit `lua/plugins/colors.lua` to swap themes or tweak highlights.

### Go Snippets

| Trigger | Expands to |
|---|---|
| `iferr` | `if err != nil { return err }` |
| `iferrwrap` | `fmt.Errorf("...: %w", err)` |
| `iferrpanic` | `if err != nil { panic(err) }` |
| `iferrlog` | `log.Println(err)` guard |
| `iferrfatal` | `log.Fatal(err)` guard |

### Adding a Plugin

```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  event = "VeryLazy",   -- or BufEnter, etc.
  config = function()
    require("plugin-name").setup({
      -- your options
    })
  end,
}
```

---

## 🔧 Maintenance

```bash
# Pull latest config + sync plugins
cd ~/.config/nvim && git pull && nvim -c "Lazy sync"
```

```vim
:checkhealth          " full health report
:Lazy sync            " reinstall / update plugins
:Mason                " manage LSP servers
:LspInfo              " active LSP clients
```

---

## 🗑️ Uninstall

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim
mv ~/.config/nvim.bak ~/.config/nvim   # restore backup
```

---

## 💡 Shell Aliases

```bash
# ~/.zshrc or ~/.bashrc
alias v='nvim'
alias fp='cd $(find ~/projects -maxdepth 1 -type d | fzf) && nvim .'
```

---

<div align="center">

Built for developers who value their time.

<sub><a href="https://github.com/BKR-dev">BKR-dev</a></sub>

</div>
