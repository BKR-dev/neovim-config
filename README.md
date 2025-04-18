# Small but Powerful Neovim Config

## Installation Guide

### Prerequisites
1. Clone this repository:
   ```bash
   git clone https://github.com/BKR-dev/neovim-config.git
   ```
2. Backup your current Neovim configuration (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```
3. Move the cloned configuration into place:
   ```bash
   mv neovim-config ~/.config/nvim
   ```

4. Ensure the following dependencies are installed:
   - **Neovim**, **wget**, and **npm**:
     - macOS (Homebrew):  
       ```bash
       brew install neovim npm wget
       ```
     - Arch Linux (Pacman):  
       ```bash
       sudo pacman -S neovim npm wget
       ```
     - Other distros: Install these using your package manager.

### Automatic Setup Script (Optional)
To simplify the setup, you can use the following script to automate most of the steps:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/BKR-dev/neovim-config/main/setup.sh)
```

---

### Manual Setup

#### 1. Install Packer (Plugin Manager)
Install Packer to manage your Neovim plugins:
```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

#### 2. Source the Configuration
Open Neovim and source the plugin configuration file:
```bash
nvim -c "exec :normal! :source lua/lio/packer.lua '"
```
> ⚠️ Don't worry about any errors at this stage—they occur because the plugins haven't been installed yet.

#### 3. Install Plugins
Use Packer to install all plugins:
```bash
:PackerSync
```

---

### Additional Recommendations

#### Improve Workflow with Aliases
1. Add an alias for quick access to Neovim:
   ```bash
   echo "alias v='$(which nvim)'" >> ~/.zshrc
   ```
2. Add an alias to quickly navigate and open projects:
   ```bash
   echo "alias fp='(file=$(find ~/Git -mindepth 1 -maxdepth 1 -type d | fzf); [ -n \"$file\" ] && cd \"$file\" && v .)'" >> ~/.zshrc
   ```

#### Optional: For Templ Integration
If you're using the [Templ](https://templ.guide/commands-and-tools/ide-support/) integration branch, remember to install the `templ` binary by following the official documentation.

---

And that's it! You're now ready to enjoy a powerful Neovim setup 🎉.
