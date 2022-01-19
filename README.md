dotfiles
========

My dotfiles for neovim, tmux and everything else.
To be used at your own risk!

Locally, I store all my dotfiles in `~/Workspace/dotfiles` and then symlink the relevant files. 
My motivation for doing this is to separate out my own dotfiles from my home directory.

No installation steps are provided in this git.
One should know how to use the dotfiles else don't use it.

## Notable apps:
- https://alt-tab-macos.netlify.app/ 
- https://fork.dev/

## Tricky bits

Always start with:
- `xcode-select --install`
- `brew install ruby` -> needed for cocoapods and tmuxinator

iTerm2 escape shortcut:
- Shift+Enter to send Hex code `1B`

Neovim/COC settings:
- `ln -s ~/Workspace/dotfiles/coc-settings.json ~/.config/nvim/coc-settings.json`
- `ln -s ~/Workspace/dotfiles/init.vim ~/.config/nvim/init.vim`
