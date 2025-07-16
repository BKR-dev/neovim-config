#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the Neovim configuration directory
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Clone the repository if not already cloned
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
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
invim --headless -c 'MasonInstall awk-language-server bash-language-server cmake-language-server dockerfile-language-server gofumpt goimports gopls helm-ls html-lsp lua-language-server sql-formatter templ terraform-ls typescript-language-server yamllint' -c 'quitall'

echo "Setup complete! Launch Neovim to start using your configuration."
