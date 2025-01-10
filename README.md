dotfiles
========

My dotfiles for neovim, tmux and everything else.
To be used at your own risk!

Locally, I store all my dotfiles in `~/Workspace/dotfiles` and then symlink the relevant files. 
My motivation for doing this is to separate out my own dotfiles from my home directory.

No installation steps are provided in this git.
One should know how to use the dotfiles else don't use it.

## Notable apps:
- https://rectangleapp.com/pro
- https://alt-tab-macos.netlify.app/ 
- https://www.alfredapp.com/

## Neovim:
For python-provider, we need to:
- `brew install python3`
- `python3 -m venv ./pyenv`
- `source ./pyenv/bin/activate`
- `pip install pynvim`
- Add `vim.g.python3_host_prog = './pyenv/bin/python'` in `init.lua`

## Tricky bits

Always start with:
- `xcode-select --install`
- Install Xcode App
- `brew install ruby` -> needed for cocoapods and tmuxinator

Soft links settings:
- `ln -s ~/Workspace/dotfiles/init.lua ~/.config/nvim/init.lua`
- `ln -s ~/Workspace/dotfiles/.wezterm.lua ~/.wezterm.lua
- `ln -s ~/Workspace/dotfiles/.spaceshiprc.zh ~/.spaceshiprc.zh`
- `ln -s ~/Workspace/dotfiles/.zshrc ~/.zshrc`
- `ln -s ~/Workspace/dotfiles/.tmuxinator ~/.tmuxinator`
- `ln -s ~/Workspace/dotfiles/.tmux.conf ~/.tmux.conf`
- `ln -s ~/Workspace/dotfiles/.gitconfig ~/.gitconfig`
- `ln -s ~/Workspace/dotfiles/.gitignore_global ~/.gitignore_global`
- `ln -s ~/Notes ~/Workspace/dotfiles//Users/stevenyap/Dropbox/Notes`
  - This is for easy access to Notes in dotfiles tmux session
