# Small but Powerful Neovim Config

A lightweight yet feature-rich Neovim configuration using Lazy.nvim for plugin management and lsp-zero for LSP integration.

## ✨ Features

- 🚀 **Lazy.nvim** for fast plugin management
- 🔧 **LSP** support with full language server integration (Lua, Go, Terraform, YAML, and more)
- 📝 **Rich completion** with multiple sources (LSP, snippets, buffer, treesitter, git)
- 🎨 **Syntax highlighting** via Treesitter
- 🔍 **Telescope** for fuzzy finding
- 🎯 **Harpoon** for quick file navigation
- 🐛 **DAP** debugging support
- 💅 **Auto-formatting** on save
- 📊 **Beautiful diagnostics** with custom signs and virtual text

## 📋 Prerequisites

- **Neovim** 0.10.0 or later
- **Git**
- **Node.js** and **npm** (for some LSP servers)
- **Ripgrep** (for Telescope live grep)
- **A Nerd Font** (for icons)

### Install Prerequisites

**macOS (Homebrew):**
```bash
brew install neovim git node ripgrep
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
```

**Arch Linux:**
```bash
sudo pacman -S neovim git nodejs npm ripgrep
yay -S ttf-hack-nerd
```

**Ubuntu/Debian:**
```bash
sudo apt install neovim git nodejs npm ripgrep
```

## 🚀 Quick Installation

**One-line install** (automatically backs up existing config):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/BKR-dev/neovim-config/master/setup.sh)
```

This script will:
- ✅ Check for required dependencies
- ✅ Backup your existing Neovim configuration
- ✅ Clone this repository
- ✅ Install all plugins automatically
- ✅ Set up LSP servers via Mason
- ✅ Clean up old plugin managers (Packer)

## 🔧 Manual Installation

If you prefer manual installation:

### 1. Backup Existing Config
```bash
mv ~/.config/nvim ~/.config/nvim_backup_$(date +%Y%m%d_%H%M%S)
mv ~/.local/share/nvim ~/.local/share/nvim_backup_$(date +%Y%m%d_%H%M%S)
```

### 2. Clone Repository
```bash
git clone git@github.com:BKR-dev/neovim-config.git ~/.config/nvim
```

### 3. Launch Neovim
```bash
nvim
```

Lazy.nvim will automatically install all plugins on first launch. Just wait for it to complete!

### 4. Install LSP Servers
Open Neovim and run:
```vim
:Mason
```

Then press `i` to install the LSP servers you need (lua_ls, gopls, etc.)

## 📦 Installed Plugins

- **Plugin Manager:** lazy.nvim
- **LSP:** lsp-zero, nvim-lspconfig, mason.nvim
- **Completion:** nvim-cmp with multiple sources
- **Syntax:** nvim-treesitter
- **Fuzzy Finder:** telescope.nvim
- **Navigation:** harpoon
- **Git:** vim-fugitive
- **Debugging:** nvim-dap, nvim-dap-go, nvim-dap-ui
- **UI:** lualine, todo-comments, lsp_lines
- **Utils:** Comment.nvim, nvim-autopairs

## ⚙️ Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── core/
│   │   ├── init.lua        # Core initialization
│   │   ├── lazy.lua        # Lazy.nvim setup
│   │   ├── remap.lua       # Key mappings
│   │   └── set.lua         # Vim settings
│   ├── plugins/
│   │   ├── lsp.lua         # LSP configuration
│   │   ├── telescope.lua   # Telescope config
│   │   ├── treesitter.lua  # Treesitter config
│   │   └── ...             # Other plugin configs
│   └── snippets/
│       └── go.lua          # Go snippets
└── setup.sh                # Automated setup script
```

## 🎯 Key Bindings

Leader key: `<Space>`

### General
- `<leader>pv` - File explorer
- `<leader>pf` - Find files
- `<leader>ps` - Live grep
- `<leader>ld` - Show diagnostic details

### LSP
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `[d` / `]d` - Navigate diagnostics

### Harpoon
- `<leader>a` - Add file to harpoon
- `<C-e>` - Toggle harpoon menu
- `<C-h>` / `<C-t>` / `<C-n>` / `<C-s>` - Navigate harpoon files

## 🔄 Updating

To update the configuration and plugins:

```bash
cd ~/.config/nvim
git pull
nvim
:Lazy sync
```

## 🗑️ Uninstalling

To restore your previous configuration:

```bash
rm -rf ~/.config/nvim
mv ~/.config/nvim_backup_* ~/.config/nvim  # Use your backup timestamp
```

## 🐛 Troubleshooting

**Plugins not loading:**
```vim
:Lazy sync
```

**LSP not working:**
```vim
:Mason
:LspInfo
```

**Check for errors:**
```vim
:checkhealth
```

## 💡 Tips

### Useful Aliases

Add these to your `~/.zshrc` or `~/.bashrc`:

```bash
# Quick access to Neovim
alias v='nvim'

# Quick project navigation with fzf
alias fp='(file=$(find ~/Git -mindepth 1 -maxdepth 1 -type d | fzf); [ -n "$file" ] && cd "$file" && v .)'
```

---

Enjoy your powerful Neovim setup! 🎉
