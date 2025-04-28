# Create this file at ~/.config/nvim/setup.sh
#!/bin/bash

echo "Setting up Neovim configuration..."

# Create necessary directories
mkdir -p ~/.config/nvim/pack/packer/start
mkdir -p ~/.config/nvim/plugin

# Clone Packer first
if [ ! -d ~/.config/nvim/pack/packer/start/packer.nvim ]; then
  echo "Installing Packer..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.config/nvim/pack/packer/start/packer.nvim
fi

# Run initial installation
echo "Installing plugins - this may take a while..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Compile plugins
echo "Compiling plugins..."
nvim --headless -c 'PackerCompile' -c 'q'

echo "Setup complete! You can now start Neovim."
