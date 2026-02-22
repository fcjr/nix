# nix

Personal nix-darwin configuration for macOS. Declaratively manages system settings, packages (Nix + Homebrew + Mac App Store), dotfiles, and development tools using Nix flakes, nix-darwin, and home-manager.

## New Machine Setup

1. [Install Nix](https://nixos.org/download/)
2. Grant your terminal app **Full Disk Access** in System Settings > Privacy & Security > Full Disk Access
3. Run:
   ```bash
   make install
   ```

The install target automatically backs up `/etc/bashrc` and `/etc/zshrc` before activating nix-darwin. If the `sudo mv` step fails with "Operation not permitted" even with Full Disk Access, you may need to remove immutable flags first:

```bash
sudo chflags noschg /etc/bashrc /etc/zshrc
make install
```

## Usage

```bash
make rebuild    # Apply configuration changes (default target)
make update     # Update flake.lock dependencies
```
