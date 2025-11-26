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

# Backup existing configuration if it exists and is not a git repo pointing to the correct origin
if [ -d "$NVIM_CONFIG_DIR" ]; then
    if [ -d "$NVIM_CONFIG_DIR/.git" ]; then
        cd "$NVIM_CONFIG_DIR"
        REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
        if [ "$REMOTE_URL" == "https://github.com/BKR-dev/neovim-config.git" ]; then
            echo "Neovim configuration already exists and matches the repository. Pulling latest changes..."
            git pull
        else
            echo "Backing up existing Neovim configuration to $NVIM_BACKUP_DIR..."
            mv "$NVIM_CONFIG_DIR" "$NVIM_BACKUP_DIR"
            echo "Cloning Neovim configuration repository..."
            git clone https://github.com/BKR-dev/neovim-config.git "$NVIM_CONFIG_DIR"
        fi
    else
        echo "Backing up existing Neovim configuration to $NVIM_BACKUP_DIR..."
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

# Run Neovim to install and compile plugins
echo "Installing and compiling plugins with packer.nvim..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Install Mason tools (LSPs, linters, formatters)
echo "Installing Mason tools..."
# Note: Ensure mason-lspconfig is configured to automatically install LSPs in your config,
# or explicitly install them here. The list below matches what was previously attempted.
nvim --headless -c 'MasonInstall awk-language-server bash-language-server cmake-language-server dockerfile-language-server gofumpt goimports gopls helm-ls html-lsp lua-language-server sql-formatter templ terraform-ls typescript-language-server yamllint' -c 'quitall'

echo "Setup complete! Launch Neovim to start using your configuration."
