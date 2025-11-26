#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check for required commands
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed."
    exit 1
fi

if ! command -v nvim &> /dev/null; then
    echo "Error: nvim is not installed."
    exit 1
fi

# Define the Neovim configuration directory
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_BACKUP_DIR="$HOME/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)"

# Ensure the .config directory exists
mkdir -p "$HOME/.config"

# Backup existing configuration if it exists
if [ -e "$NVIM_CONFIG_DIR" ]; then
    if [ -d "$NVIM_CONFIG_DIR" ] && [ -d "$NVIM_CONFIG_DIR/.git" ]; then
        # It's a directory and a git repo
        REMOTE_URL=$(git -C "$NVIM_CONFIG_DIR" remote get-url origin 2>/dev/null || echo "")
        if [ "$REMOTE_URL" == "https://github.com/BKR-dev/neovim-config.git" ]; then
            echo "Neovim configuration already exists and matches the repository. Pulling latest changes..."
            git -C "$NVIM_CONFIG_DIR" pull
        else
            echo "Backing up existing Neovim configuration to $NVIM_BACKUP_DIR..."
            mv "$NVIM_CONFIG_DIR" "$NVIM_BACKUP_DIR"
            echo "Cloning Neovim configuration repository..."
            git clone https://github.com/BKR-dev/neovim-config.git "$NVIM_CONFIG_DIR"
        fi
    else
        # It's either not a directory (a file) or not a git repo (or not the right one)
        echo "Backing up existing Neovim configuration (file or directory) to $NVIM_BACKUP_DIR..."
        mv "$NVIM_CONFIG_DIR" "$NVIM_BACKUP_DIR"
        echo "Cloning Neovim configuration repository..."
        git clone https://github.com/BKR-dev/neovim-config.git "$NVIM_CONFIG_DIR"
    fi
else
    echo "Cloning Neovim configuration repository..."
    git clone https://github.com/BKR-dev/neovim-config.git "$NVIM_CONFIG_DIR"
fi

# Install packer.nvim if not already installed
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
  echo "Installing packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
fi

# Function to restore the after directory
restore_after() {
  if [ -d "$NVIM_CONFIG_DIR/after.tmp" ]; then
    echo "Restoring 'after' directory..."
    rm -rf "$NVIM_CONFIG_DIR/after"
    mv "$NVIM_CONFIG_DIR/after.tmp" "$NVIM_CONFIG_DIR/after"
  fi
}

# Set up trap to ensure restore_after is called on exit
trap restore_after EXIT

# Temporarily move 'after' directory to prevent plugins from loading before installation
if [ -d "$NVIM_CONFIG_DIR/after" ]; then
  echo "Temporarily moving 'after' directory for bootstrapping..."
  mv "$NVIM_CONFIG_DIR/after" "$NVIM_CONFIG_DIR/after.tmp"
fi

# Run Neovim to install and compile plugins
echo "Installing and compiling plugins with packer.nvim..."
nvim --headless -c 'lua require("lio.packer")' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Restore 'after' directory explicitly (trap will also catch it if script fails)
restore_after

# Install Mason tools (LSPs, linters, formatters)
echo "Installing Mason tools..."
# Note: Ensure mason-lspconfig is configured to automatically install LSPs in your config,
# or explicitly install them here. The list below matches what was previously attempted.
nvim --headless -c 'MasonInstall bash-language-server cmake-language-server dockerfile-language-server gofumpt goimports gopls helm-ls html-lsp lua-language-server sql-formatter templ terraform-ls typescript-language-server yamllint' -c 'quitall'

echo "Setup complete! Launch Neovim to start using your configuration."
