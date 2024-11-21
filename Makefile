.DEFAULT_GOAL := rebuild

install:
	nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#default

rebuild:
	darwin-rebuild switch --flake .#default

.PHONY: install rebuild