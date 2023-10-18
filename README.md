# Small but powerful nvim config

- clone repo into wherever
- `mv nvim ~/.config/` (backup your nvim config before hand!)
- install neovim (and npm for eslint, gopls for golang) `brew install neovim npm gopls`
- install packer (plugin manager)
- git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
- neovim ~/.config/nvim/lua/lio/packer.nvim
- open up neovim and then source the config and sync the package manager
- `:so`
- `:PackerSync`

now all plugins are getting installed, the configurations are already in place!

- make it nice and easy `echo "alias v='$(which nvim)" >> ~/.zshrc`

and now you have a pretty decent neovim config!

---

There is a branch for Templ integration, it is working but you need to install the templ binary so please read the templ documentation prior (https://templ.guide/commands-and-tools/ide-support/)
