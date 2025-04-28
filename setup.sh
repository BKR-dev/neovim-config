#!/bin/bash
# filepath: /home/bkr/.config/nvim/setup.sh

echo "Setting up Neovim configuration..."

# Create necessary directories
mkdir -p ~/.config/nvim/pack/packer/start
mkdir -p ~/.config/nvim/plugin

# Clone Packer first
if [ ! -d ~/.config/nvim/pack/packer/start/packer.nvim ]; then
  echo "Installing Packer..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.config/nvim/pack/packer/start/packer.nvim
fi

# Create temporary init file for installation only
cat > ~/.config/nvim/init_setup.lua << 'EOL'
-- Minimal init for plugin installation only
vim.opt.packpath:prepend(vim.fn.stdpath('config'))
vim.cmd('packadd packer.nvim')

-- Basic packer setup
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'JoosepAlviste/palenightfall.nvim'
  use 'numToStr/Comment.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'mfussenegger/nvim-dap'
  use 'theprimeagen/harpoon'
  -- Add other essential plugins here
end)
EOL

# Install plugins with minimal configuration
echo "Installing essential plugins..."
nvim --headless -u ~/.config/nvim/init_setup.lua -c 'PackerSync' -c 'sleep 2000m' -c 'q'

# Clean up temporary setup file
rm ~/.config/nvim/init_setup.lua

# Now install all plugins with regular config
echo "Installing all plugins..."
nvim --headless -c 'PackerSync' -c 'sleep 3000m' -c 'q'

# Compile plugins
echo "Compiling plugins..."
nvim --headless -c 'PackerCompile' -c 'q'

echo "Setup complete! You can now start Neovim."
