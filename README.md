# My personal config for Nvim and Golang lint and LSP Server

## Instalation Nvim
````bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
````

### Note: Some folders have my username, due to configuration criteria in Linux, I recommend changing it to your username for correct organization and operation.

### After cloning the repository, open nvim and update the plugins.Use the command ":Lazy" to open the plugin manager. Lazy will automatically download and install whatever is necessary.

# Plugins installed:
  - Alpha
  - Auto-session
  - AutoPairs
  - Buffeline
  - Colorscheme
  - Comment
  - Dressing
  - Folding
  - Formatting
  - Indent-bankline
  - Linting
  - Lualine
  - Nvim-cmp
  - Nvim-tree
  - Substitute
  - Surround
  - Telescope
  - Treesitter
  - Trouble
  - Vim-maximizer
  - Which-key
# LSP - (Language Servers)
  - Golang
  - Gopls
