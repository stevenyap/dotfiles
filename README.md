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
- `brew install gitui && brew install git-delta`
- `npm install -g @builder.io/ai-shell`
- `npm install -g tree-sitter-cli`

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
- Create `~/.zsh_secrets` with 1Password `dotfiles` personal secrets

Soft links settings:
- Local bash soft linking:
  - `ln -s ~/Workspace/dotfiles/init.lua ~/.config/nvim/init.lua`
  - `ln -s ~/Workspace/dotfiles/.wezterm.lua ~/.wezterm.lua`
  - `ln -s ~/Workspace/dotfiles/.spaceshiprc.zh ~/.spaceshiprc.zh`
  - `ln -s ~/Workspace/dotfiles/.zshrc ~/.zshrc`
  - `ln -s ~/Workspace/dotfiles/.tmux.conf ~/.tmux.conf`
  - `ln -s ~/Workspace/dotfiles/.gitconfig ~/.gitconfig`
  - `ln -s ~/Workspace/dotfiles/.gitignore_global ~/.gitignore_global`
  - `ln -s ~/Workspace/dotfiles/.gitui-keys.ron $HOME/.config/gitui/key_bindings.ron`
  - `ln -s ~/Workspace/dotfiles/.gitui-theme.ron $HOME/.config/gitui/theme.ron`
- Access other folders in dotfile tmux:
  - `ln -s ~/Desktop ~/Workspace/dotfiles/Desktop`
  - `ln -s ~/Documents/Notes ~/Workspace/dotfiles/Notes`
- Soft link to tmuxinator:
  - tmuxinator projects are saved in a Cloud drive which is not commited in this repo
  - `ln -s ~/Documents/tmuxinator ~/.tmuxinator`
  - `ln -s ~/Documents/tmuxinator ~/Workspace/dotfiles/tmuxinator`
