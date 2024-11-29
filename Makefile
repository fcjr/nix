.DEFAULT_GOAL := rebuild

install:
	nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#fcjr

rebuild:
	darwin-rebuild switch --flake .#fcjr

.PHONY: install rebuild