install:
	nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/nix#default

rebuild:
	darwin-rebuild switch --flake ~/nix#default

.PHONY: install rebuild
