#!/bin/bash

# Neovim Configuration Setup Script
# This script automatically backs up your existing Neovim config and installs this configuration
# Usage: curl -fsSL https://raw.githubusercontent.com/BKR-dev/neovim-config/main/setup.sh | bash

# Exit immediately if a command exits with a non-zero status
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check for required commands
if ! command -v git &> /dev/null; then
    print_error "git is not installed. Please install git first."
    exit 1
fi

if ! command -v nvim &> /dev/null; then
    print_error "nvim is not installed. Please install Neovim first."
    exit 1
fi

# Check Neovim version (requires 0.10.0+)
NVIM_VERSION=$(nvim --version | head -n1 | sed -n 's/.*v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/p')
REQUIRED_VERSION="0.10.0"

# Simple version comparison
version_ge() {
    # Returns 0 (success) if $1 >= $2
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

if [ -z "$NVIM_VERSION" ]; then
    print_warn "Could not detect Neovim version. Proceeding anyway..."
elif ! version_ge "$NVIM_VERSION" "$REQUIRED_VERSION"; then
    print_error "Neovim version $NVIM_VERSION is too old. This config requires Neovim $REQUIRED_VERSION or later."
    exit 1
else
    print_info "Neovim version $NVIM_VERSION detected. ✓"
fi

# Define directories
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_DATA_DIR="$HOME/.local/share/nvim"
NVIM_BACKUP_DIR="$HOME/.config/nvim_backup_$(date +%Y%m%d_%H%M%S)"
DATA_BACKUP_DIR="$HOME/.local/share/nvim_backup_$(date +%Y%m%d_%H%M%S)"
REPO_URL="git@github.com:BKR-dev/neovim-config.git"
REPO_URL_HTTPS="https://github.com/BKR-dev/neovim-config.git"

# Ensure the .config directory exists
mkdir -p "$HOME/.config"

# Backup existing configuration if it exists
if [ -e "$NVIM_CONFIG_DIR" ]; then
    if [ -d "$NVIM_CONFIG_DIR" ] && [ -d "$NVIM_CONFIG_DIR/.git" ]; then
        # It's a directory and a git repo
        REMOTE_URL=$(git -C "$NVIM_CONFIG_DIR" remote get-url origin 2>/dev/null || echo "")
        if [[ "$REMOTE_URL" == *"BKR-dev/neovim-config"* ]]; then
            print_info "Neovim configuration already exists and matches the repository. Pulling latest changes..."
            git -C "$NVIM_CONFIG_DIR" pull
            CONFIG_UPDATED=true
        else
            print_warn "Existing Neovim configuration found. Backing up to $NVIM_BACKUP_DIR..."
            mv "$NVIM_CONFIG_DIR" "$NVIM_BACKUP_DIR"
            print_info "Backup created at: $NVIM_BACKUP_DIR"
            CONFIG_UPDATED=false
        fi
    else
        print_warn "Existing Neovim configuration found. Backing up to $NVIM_BACKUP_DIR..."
        mv "$NVIM_CONFIG_DIR" "$NVIM_BACKUP_DIR"
        print_info "Backup created at: $NVIM_BACKUP_DIR"
        CONFIG_UPDATED=false
    fi
fi

# Clone the repository if not already present or updated
if [ "$CONFIG_UPDATED" != "true" ]; then
    print_info "Cloning Neovim configuration repository..."
    # Try SSH first, fall back to HTTPS
    if ! git clone "$REPO_URL" "$NVIM_CONFIG_DIR" 2>/dev/null; then
        print_warn "SSH clone failed, trying HTTPS..."
        git clone "$REPO_URL_HTTPS" "$NVIM_CONFIG_DIR"
        # Set remote to SSH for future pushes if the user has SSH keys
        print_info "Setting remote URL to SSH for future operations..."
        git -C "$NVIM_CONFIG_DIR" remote set-url origin "$REPO_URL"
    fi
fi

# Clean up old plugin managers (Packer)
if [ -d "$NVIM_DATA_DIR/site/pack/packer" ]; then
    print_info "Removing old Packer installation..."
    rm -rf "$NVIM_DATA_DIR/site/pack/packer"
fi

# Backup and clean Neovim data directory for fresh start
if [ -d "$NVIM_DATA_DIR" ]; then
    print_warn "Backing up existing Neovim data directory to $DATA_BACKUP_DIR..."
    cp -r "$NVIM_DATA_DIR" "$DATA_BACKUP_DIR"
    print_info "Data backup created at: $DATA_BACKUP_DIR"
    
    # Clean up state files but keep Mason installations if they exist
    print_info "Cleaning up old state files..."
    rm -rf "$NVIM_DATA_DIR/lazy" "$NVIM_DATA_DIR/lazy-lock.json" 2>/dev/null || true
    rm -rf "$NVIM_DATA_DIR/shada" "$NVIM_DATA_DIR/swap" "$NVIM_DATA_DIR/undo" 2>/dev/null || true
fi

# Lazy.nvim will auto-install on first run, so we just need to trigger it
print_info "Installing plugins with Lazy.nvim..."
nvim --headless "+Lazy! sync" +qa

# Wait a moment for plugin installation to complete
sleep 2

# Install Mason tools (LSPs, linters, formatters)
print_info "Installing LSP servers and tools via Mason..."
nvim --headless -c "MasonInstall bash-language-server cmake-language-server dockerfile-language-server gofumpt goimports gopls helm-ls html-lsp lua-language-server sql-formatter templ terraform-ls typescript-language-server yamllint yaml-language-server" -c "sleep 5" -c "qall"

# Final verification
print_info "Verifying installation..."
if nvim --headless -c "lua print('OK')" -c "qall" 2>/dev/null; then
    echo ""
    print_info "✓ Setup complete! Launch Neovim to start using your configuration."
    echo ""
    
    # Show what backups were created
    BACKUP_CREATED=false
    if [ -d "$NVIM_BACKUP_DIR" ] || [ -d "$DATA_BACKUP_DIR" ]; then
        print_info "Backups created:"
        [ -d "$NVIM_BACKUP_DIR" ] && echo "  - Config: $NVIM_BACKUP_DIR" && BACKUP_CREATED=true
        [ -d "$DATA_BACKUP_DIR" ] && echo "  - Data:   $DATA_BACKUP_DIR" && BACKUP_CREATED=true
        echo ""
        
        if [ "$BACKUP_CREATED" = true ]; then
            print_info "To restore your old config, run:"
            [ -d "$NVIM_BACKUP_DIR" ] && echo "  rm -rf $NVIM_CONFIG_DIR && mv $NVIM_BACKUP_DIR $NVIM_CONFIG_DIR"
            [ -d "$DATA_BACKUP_DIR" ] && [ ! -d "$NVIM_BACKUP_DIR" ] && echo "  rm -rf $NVIM_DATA_DIR && mv $DATA_BACKUP_DIR $NVIM_DATA_DIR"
        fi
    else
        print_info "No backups created (config was already up to date or freshly installed)."
    fi
else
    print_error "Installation verification failed. Please check for errors above."
    exit 1
fi
