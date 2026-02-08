# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal nix-darwin configuration for macOS. Declaratively manages system settings, packages (Nix + Homebrew + Mac App Store), dotfiles, and development tools using Nix flakes, nix-darwin, and home-manager.

## Commands

```bash
make rebuild    # Apply configuration changes (default target, runs: sudo darwin-rebuild switch --flake .#fcjr)
make install    # First-time setup with nix-darwin
make update     # Update flake.lock dependencies (nix flake update)
```

## Architecture

**flake.nix** defines a single Darwin configuration (`fcjr`) combining:
- **nix-darwin** for system-level macOS configuration
- **home-manager** for user environment/dotfiles
- **nix-homebrew** for Homebrew integration (brew formulas, casks, Mac App Store apps)
- **personal-overlay** (`fcjr/nix-overlay`) for custom package definitions

**modules/** contains all configuration, split into:

| File/Dir | Purpose |
|---|---|
| `darwin.nix` | System config: Homebrew packages, macOS defaults, dock, security, VS Code extensions, activation scripts |
| `home.nix` | User config: PATH setup, dotfile symlinks, imports packages.nix |
| `packages.nix` | Home-manager Nix packages (fonts, CLI tools, dev tools) |
| `programs/` | Program configs with Nix integration (zsh via `shell/default.nix`, k9s) |
| `shell/` | Dotfiles: .gitconfig, .tmux.conf |
| `nvim/` | Neovim config (Lua, lazy.nvim plugin manager) |
| `ghostty/` | Ghostty terminal config |
| `vscode/` | VS Code settings.json |
| `zed/` | Zed editor settings |
| `skhd/` | Skhd hotkey daemon config |
| `yabai/` | Yabai tiling window manager config |
| `bin/` | Custom shell scripts (tmux-sessionizer, firefox-new-window, ghostty-new-window) |

**Package management is split across three systems:**
- `packages.nix` — Nix packages installed via home-manager
- `darwin.nix` Homebrew section — brew formulas, casks, and Mac App Store apps
- `darwin.nix` VS Code section — VS Code extensions managed via nix-darwin

**Shell configuration** lives in `programs/` (`shell/default.nix` for zsh) with dotfiles in `shell/` (git, tmux). Zsh aliases, environment variables, and shell functions are defined in `shell/default.nix`.
