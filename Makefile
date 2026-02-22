.DEFAULT_GOAL := rebuild

install:
	sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin 2>/dev/null || true
	sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin 2>/dev/null || true
	sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#fcjr

rebuild:
	sudo darwin-rebuild switch --flake .#fcjr

update:
	nix flake update

.PHONY: install rebuild update