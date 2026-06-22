# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for macOS — Neovim, tmux, zsh, WezTerm, and git tooling. Files live in `~/Workspace/dotfiles/` and are deployed via symlinks into the home directory. There are no build steps or tests; changes take effect when Neovim/tmux/zsh reload the relevant file.

## Reloading configs after changes

- **Neovim**: `:source %` or restart nvim. Lazy.nvim syncs plugins with `:Lazy sync`.
- **tmux**: `:source-file ~/.tmux.conf` or `C-a r` (bound to respawn, not reload — restart tmux to pick up config changes).
- **zsh**: `source ~/.zshrc` or open a new shell.

## Key files

| File | Purpose |
|------|---------|
| `init.lua` | Single-file Neovim config — lazy.nvim bootstrap + all plugin specs and keymaps |
| `.zshrc` | zsh config — antigen plugins, PATH setup, aliases |
| `.tmux.conf` | tmux config — prefix is `C-a` |
| `.wezterm.lua` | WezTerm terminal config |
| `.spaceshiprc.zsh` | Spaceship prompt config |
| `.gitui-keys.ron` / `.gitui-theme.ron` | gitui keybindings and theme |
| `bin/` | Custom scripts on PATH |
| `Runnerfile.sh` | Task runner via `runner` (starts tmuxinator sessions) |
| `.ai/context.md` | AI assistant context loaded automatically by magenta.nvim |

## Neovim architecture (`init.lua`)

All config is in one file. Structure:
1. **lazy.nvim bootstrap** — auto-installs if missing
2. **Core settings** — editor options, keymaps, leader key (`<Space>`)
3. **Plugin specs** — each plugin is a lazy.nvim spec block with inline `config = function()`

Leader key conventions (defined in comments near top):
- `<Leader>r?` = refresh/reload
- `<Leader>t?` = toggle

Key plugin dependencies that must be installed via Homebrew:
- `fzf`, `fd`, `bat`, `ripgrep`, `git-delta` — for fzf-lua
- `stylua` — Lua formatter
- `tree-sitter-cli` — Treesitter
- `gitui` — git TUI (opened with `<Leader>g`)

LSP servers are installed via npm (`vscode-langservers-extracted`, `purescript-language-server`, `purs-tidy`). TypeScript uses `pmizio/typescript-tools.nvim`.

## Secrets

`~/.zsh_secrets` is sourced by `.zshrc` but not committed. It holds 1Password `dotfiles` personal secrets (API keys etc.).

## Symlinks setup

The repo uses symlinks rather than copying files. Existing symlinks:
- `Desktop` → `~/Desktop`
- `Notes` → `~/Documents/Notes`
- `tmuxinator` → `~/Documents/tmuxinator`

tmuxinator project configs are in a cloud drive (not committed here). `TMUXINATOR_CONFIG` points to `~/Workspace/dotfiles/tmuxinator`.
