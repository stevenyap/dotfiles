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

## Neovim keymaps

Leader is `<Space>`. The rule this layout follows: **nothing shadows a native
Vim command** — anything Vim does not ship lives under `<Leader>`, grouped by
its second key. The exception is grammar (motions, text objects, operators),
which cannot work behind a leader, so it sits in Vim's own namespaces but only
in slots Vim leaves empty.

### `<Leader>l` — LSP and logs

| Key | Does |
|-----|------|
| `<Leader>ld` | Jump to the definition of the symbol under the cursor |
| `<Leader>lh` | Show hover documentation for the symbol under the cursor |
| `<Leader>lp` | Peek the definition in a floating window, without leaving the file |
| `<Leader>lr` | List every reference to the symbol under the cursor |
| `<Leader>ln` | Rename the symbol under the cursor across the project |
| `<Leader>la` | Offer code actions for the cursor (also works on a Visual range) |
| `<Leader>le` | Show the full diagnostics for the current line in a float |
| `<Leader>lS` | Restart the language servers, for when one hangs |
| `<Leader>lm` | Open `:messages` — the editor and plugin log |

### `<Leader>g` — git, hunks included

| Key | Does |
|-----|------|
| `<Leader>gn` | Neo-tree listing only the changed files (against the review base if one is set, else HEAD) |
| `<Leader>gb` | Toggle the blame pane for the current file |
| `<Leader>gc` | Fuzzy-search the commit log and open a commit |
| `<Leader>gr` | Set the review base, e.g. `origin/development` — every buffer then diffs against that branch instead of the index. No argument resets it to the index |
| `<Leader>ga` | Apply (stage) the hunks under a motion or Visual selection |
| `<Leader>gu` | Undo (reset) the hunks under a motion or Visual selection |

### `<Leader>t` — toggles

| Key | Does |
|-----|------|
| `<Leader>tw` | Toggle line wrapping |
| `<Leader>tn` | Toggle relative line numbers |
| `<Leader>tm` | Toggle rendered markdown in the current buffer |
| `<Leader>tl` | Toggle inline (virtual-line) diagnostics |
| `<Leader>tg` | Toggle the diff overlay, showing the reference text inline |

### `<Leader>y` — yank

| Key | Does |
|-----|------|
| `<Leader>ya` | Yank the whole file and return the cursor to where it was |
| `<Leader>yr` | Yank the current lines with a `repo @ branch commit path:lines` header, marked `[uncommitted]` or `[UNSAVED buffer]` when they differ from HEAD. Works in Normal and Visual mode |

### `<Leader>m` — magenta (AI), plugin defaults

| Key | Does |
|-----|------|
| `<Leader>mt` | Toggle the magenta sidebar |
| `<Leader>mn` | Start a new thread |
| `<Leader>mc` | Clear magenta state |
| `<Leader>ma` | Abort the running operation |
| `<Leader>mp` | Paste the clipboard into the input buffer; in Visual mode, send the selection |
| `<Leader>mb` | Add the current buffer to context |
| `<Leader>mf` | Pick files to add to context |
| `<Leader>mP` | Pick the model profile |
| `<Leader>mw` | Start a worktree orchestrator thread |
| `<Leader>ms` | Toggle sandbox bypass for the thread under the cursor |

### `<Leader>` singles

| Key | Does |
|-----|------|
| `<Leader>s` | Write every modified buffer (`:wa`) |
| `<Leader>/` | Clear the search highlight |
| `<Leader>k` | Split the line at the cursor |
| `<Leader>K` | Split the line at column 0, pushing it down |
| `<Leader>n` | Toggle the file tree |
| `<Leader>?` | Fuzzy-search every keymap, with these descriptions |

### Grammar — takes counts, composes with operators

| Key | Does |
|-----|------|
| `]h` / `[h` | Next / previous changed hunk. Takes a count: `3]h` |
| `]H` / `[H` | Last / first hunk in the file |
| `ih` | The hunk under the cursor as a text object: `dih`, `yih`, `vih` |
| `]d` / `[d` | Next / previous diagnostic (Neovim's own, so it takes a count) |

### Ctrl — windows and pickers

| Key | Does |
|-----|------|
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Move to the window left / down / up / right |
| `<C-p>` | Fuzzy-find files |
| `<C-b>` | Fuzzy-find open buffers |
| `<C-f>` | Live grep the project |
| `<C-s>` | Fuzzy-find the files changed against git |

### Insert mode

| Key | Does |
|-----|------|
| `<C-l>` | Accept the whole AI suggestion |
| `<C-g>l` | Accept one word of the AI suggestion |
| `<C-g>j` / `<C-g>k` | Cycle to the next / previous AI suggestion |
| `<C-h>` | Expand the snippet under the cursor |
| `<C-f>` | Fuzzy-complete a file path |
| `<C-j>` / `<C-k>` | Next / previous completion item, or jump between snippet fields |
| `<C-Space>` | Open completion |
| `<C-e>` | Dismiss completion |
| `<S-CR>` | Escape (also in Normal, Visual, Cmdline and Terminal) |

### Left to Vim

`K` `gd` `ga` `gn` `gr` `gh` `gH` `gj` `gk` `gg` `gt` and the whole `z?` fold,
scroll and spell namespace all do exactly what stock Vim does. Neovim's own
`grr` `grn` `gra` `gri` `grt` `grx` `gO` still call `vim.lsp.buf.*` directly.

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
  - `ln -s ~/Workspace/dotfiles/.claude/settings.json $HOME/.claude/settings.json`
- Access other folders in dotfile tmux:
  - `ln -s ~/Desktop ~/Workspace/dotfiles/Desktop`
  - `ln -s ~/Documents/Notes ~/Workspace/dotfiles/Notes`
- Soft link to tmuxinator:
  - tmuxinator projects are saved in a Cloud drive which is not commited in this repo
  - `ln -s ~/Documents/tmuxinator ~/.tmuxinator`
  - `ln -s ~/Documents/tmuxinator ~/Workspace/dotfiles/tmuxinator`
