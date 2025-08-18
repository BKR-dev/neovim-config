#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a command exists
check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo -e "${RED}Error: $1 is not installed.${NC}"
    echo -e "Please install $1 before continuing."
    exit 1
  fi
}

# Check for prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"
check_command nvim
check_command git
check_command wget
check_command npm
echo -e "${GREEN}All prerequisites satisfied!${NC}"

# Define the Neovim configuration directory
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Clone the repository if not already cloned
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
  echo -e "${YELLOW}Cloning Neovim configuration repository...${NC}"
  git clone https://github.com/BKR-dev/neovim-config.git "$NVIM_CONFIG_DIR" || {
    echo -e "${RED}Failed to clone the configuration repository.${NC}"
    exit 1
  }
  echo -e "${GREEN}Repository cloned successfully!${NC}"
else
  echo -e "${GREEN}Configuration directory already exists, skipping clone.${NC}"
fi

# Install packer.nvim if not already installed
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
  echo -e "${YELLOW}Installing packer.nvim...${NC}"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR" || {
    echo -e "${RED}Failed to install packer.nvim.${NC}"
    exit 1
  }
  echo -e "${GREEN}Packer installed successfully!${NC}"
else
  echo -e "${GREEN}Packer already installed, skipping.${NC}"
fi

# Run Neovim to install and compile plugins
echo -e "${YELLOW}Installing and compiling plugins with packer.nvim...${NC}"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || {
  echo -e "${RED}Error during plugin installation.${NC}"
  echo -e "${YELLOW}This might be expected on first run. Continuing...${NC}"
}

# Give plugins time to properly install
echo -e "${YELLOW}Waiting 5s for plugins to settle...${NC}"
sleep 5

# Install Mason tools (LSPs, linters, formatters)
echo -e "${YELLOW}Installing Mason tools...${NC}"
nvim --headless -c 'MasonInstall awk-language-server bash-language-server cmake-language-server dockerfile-language-server gofumpt goimports gopls helm-ls html-lsp lua-language-server sql-formatter templ terraform-ls typescript-language-server yamllint' -c 'quitall' || {
  echo -e "${RED}Error during Mason tool installation.${NC}"
  echo -e "${YELLOW}You may need to run :MasonInstall manually for missing tools.${NC}"
}

echo -e "${GREEN}Setup complete! Launch Neovim to start using your configuration.${NC}"
echo -e "${YELLOW}Note: You might see some errors on first launch while remaining plugins initialize.${NC}"
echo -e "${YELLOW}If prompted, run :PackerSync again from within Neovim.${NC}"
